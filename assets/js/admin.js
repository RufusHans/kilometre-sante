/**
 * Kilomètre-Santé — Panneau administration
 */
(function () {
  const loginView = document.getElementById("login-view");
  const adminView = document.getElementById("admin-view");
  const loginForm = document.getElementById("login-form");
  const loginError = document.getElementById("login-error");
  const logoutBtn = document.getElementById("logout-btn");
  const pharmacyTable = document.getElementById("pharmacy-table");
  const modal = document.getElementById("modal");
  const modalTitle = document.getElementById("modal-title");
  const pharmacyForm = document.getElementById("pharmacy-form");
  const addBtn = document.getElementById("add-pharmacy");
  const productsPanel = document.getElementById("products-panel");
  const productsList = document.getElementById("products-list");
  const productForm = document.getElementById("product-form");
  const adminStatus = document.getElementById("admin-status");

  let pharmacies = [];
  let selectedPharmacyId = null;
  let editingId = null;

  function showLogin() {
    loginView.hidden = false;
    adminView.hidden = true;
  }

  function showAdmin() {
    loginView.hidden = true;
    adminView.hidden = false;
  }

  async function requireAuth() {
    const client = window.KS.getClient();
    if (!client) {
      adminStatus.textContent =
        "Supabase non configuré — configurez assets/js/config.js";
      showLogin();
      return;
    }
    const { data } = await client.auth.getSession();
    if (data.session) {
      showAdmin();
      await loadPharmacies();
    } else {
      showLogin();
    }
  }

  loginForm.addEventListener("submit", async (e) => {
    e.preventDefault();
    loginError.textContent = "";
    const client = window.KS.getClient();
    if (!client) {
      loginError.textContent = "Supabase non configuré.";
      return;
    }
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value;
    const { error } = await client.auth.signInWithPassword({ email, password });
    if (error) {
      loginError.textContent = error.message;
      return;
    }
    sessionStorage.removeItem("ks_pharmacies_cache");
    showAdmin();
    await loadPharmacies();
  });

  logoutBtn.addEventListener("click", async () => {
    const client = window.KS.getClient();
    if (client) await client.auth.signOut();
    sessionStorage.removeItem("ks_pharmacies_cache");
    showLogin();
  });

  async function loadPharmacies() {
    const client = window.KS.getClient();
    if (!client) return;
    const { data, error } = await client
      .from("pharmacies")
      .select("*, products(*)")
      .order("name");
    if (error) {
      adminStatus.textContent = "Erreur : " + error.message;
      return;
    }
    pharmacies = data || [];
    adminStatus.textContent = `${pharmacies.length} pharmacies chargées`;
    renderTable();
  }

  function escapeHtml(str) {
    const d = document.createElement("div");
    d.textContent = String(str ?? "");
    return d.innerHTML;
  }

  function renderTable() {
    pharmacyTable.innerHTML = pharmacies
      .map(
        (p) => `
      <tr data-id="${p.id}">
        <td>${escapeHtml(p.name)}</td>
        <td>${escapeHtml(p.quartier)}</td>
        <td>${escapeHtml(p.arrondissement)}</td>
        <td>
          <button type="button" class="btn-toggle-duty ${p.is_on_duty ? "on" : ""}" data-duty="${p.id}" aria-pressed="${p.is_on_duty}">
            ${p.is_on_duty ? "De garde" : "Fermée"}
          </button>
        </td>
        <td class="actions">
          <button type="button" class="btn-sm" data-products="${p.id}">Produits</button>
          <button type="button" class="btn-sm" data-edit="${p.id}">Modifier</button>
          <button type="button" class="btn-sm btn-danger" data-delete="${p.id}">Suppr.</button>
        </td>
      </tr>`
      )
      .join("");

    pharmacyTable.querySelectorAll("[data-duty]").forEach((btn) => {
      btn.onclick = () => toggleDuty(btn.dataset.duty);
    });
    pharmacyTable.querySelectorAll("[data-edit]").forEach((btn) => {
      btn.onclick = () => openModal(btn.dataset.edit);
    });
    pharmacyTable.querySelectorAll("[data-delete]").forEach((btn) => {
      btn.onclick = () => deletePharmacy(btn.dataset.delete);
    });
    pharmacyTable.querySelectorAll("[data-products]").forEach((btn) => {
      btn.onclick = () => showProducts(btn.dataset.products);
    });
  }

  async function toggleDuty(id) {
    const p = pharmacies.find((x) => x.id === id);
    if (!p) return;
    const client = window.KS.getClient();
    const { error } = await client
      .from("pharmacies")
      .update({ is_on_duty: !p.is_on_duty })
      .eq("id", id);
    if (error) alert(error.message);
    sessionStorage.removeItem("ks_pharmacies_cache");
    await loadPharmacies();
  }

  function openModal(id) {
    editingId = id || null;
    modal.hidden = false;
    modalTitle.textContent = id ? "Modifier la pharmacie" : "Ajouter une pharmacie";
    if (id) {
      const p = pharmacies.find((x) => x.id === id);
      document.getElementById("f-name").value = p.name;
      document.getElementById("f-arr").value = p.arrondissement;
      document.getElementById("f-quartier").value = p.quartier;
      document.getElementById("f-phone").value = p.phone;
      document.getElementById("f-hours").value = p.hours;
      document.getElementById("f-image").value = p.image_url || "";
      document.getElementById("f-duty").checked = p.is_on_duty;
    } else {
      pharmacyForm.reset();
      document.getElementById("f-duty").checked = false;
    }
  }

  function closeModal() {
    modal.hidden = true;
    editingId = null;
  }

  document.getElementById("modal-cancel").onclick = closeModal;
  document.getElementById("modal-close").onclick = closeModal;
  addBtn.onclick = () => openModal(null);

  pharmacyForm.addEventListener("submit", async (e) => {
    e.preventDefault();
    const client = window.KS.getClient();
    const payload = {
      name: document.getElementById("f-name").value.trim(),
      arrondissement: document.getElementById("f-arr").value.trim(),
      quartier: document.getElementById("f-quartier").value.trim(),
      phone: document.getElementById("f-phone").value.trim(),
      hours: document.getElementById("f-hours").value.trim(),
      image_url: document.getElementById("f-image").value.trim() || null,
      is_on_duty: document.getElementById("f-duty").checked,
    };
    let error;
    if (editingId) {
      ({ error } = await client.from("pharmacies").update(payload).eq("id", editingId));
    } else {
      payload.legacy_id = "ph-" + Date.now();
      ({ error } = await client.from("pharmacies").insert(payload));
    }
    if (error) {
      alert(error.message);
      return;
    }
    sessionStorage.removeItem("ks_pharmacies_cache");
    closeModal();
    await loadPharmacies();
  });

  async function deletePharmacy(id) {
    const p = pharmacies.find((x) => x.id === id);
    if (!confirm(`Supprimer « ${p?.name} » ?`)) return;
    const client = window.KS.getClient();
    const { error } = await client.from("pharmacies").delete().eq("id", id);
    if (error) alert(error.message);
    sessionStorage.removeItem("ks_pharmacies_cache");
    await loadPharmacies();
  }

  async function showProducts(pharmacyId) {
    selectedPharmacyId = pharmacyId;
    const p = pharmacies.find((x) => x.id === pharmacyId);
    productsPanel.hidden = false;
    document.getElementById("products-title").textContent =
      "Produits — " + (p?.name || "");
    const products = p?.products || [];
    productsList.innerHTML = products.length
      ? products
          .map(
            (pr) => `
        <li>
          <img src="${escapeHtml(pr.image_url || "")}" alt="" width="40" height="40" loading="lazy">
          <span>${escapeHtml(pr.name)} — ${pr.price_fcfa} FCFA</span>
          <button type="button" class="btn-sm btn-danger" data-del-product="${pr.id}">×</button>
        </li>`
          )
          .join("")
      : "<li>Aucun produit</li>";

    productsList.querySelectorAll("[data-del-product]").forEach((btn) => {
      btn.onclick = async () => {
        const client = window.KS.getClient();
        await client.from("products").delete().eq("id", btn.dataset.delProduct);
        sessionStorage.removeItem("ks_pharmacies_cache");
        await loadPharmacies();
        showProducts(pharmacyId);
      };
    });
  }

  document.getElementById("products-close").onclick = () => {
    productsPanel.hidden = true;
    selectedPharmacyId = null;
  };

  productForm.addEventListener("submit", async (e) => {
    e.preventDefault();
    if (!selectedPharmacyId) {
      alert("Sélectionnez d'abord une pharmacie (bouton Produits).");
      return;
    }
    const client = window.KS.getClient();
    const fileInput = document.getElementById("p-image-file");
    let imageUrl = document.getElementById("p-image-url").value.trim();

    if (fileInput.files[0]) {
      const file = fileInput.files[0];
      const path = `${selectedPharmacyId}/${Date.now()}-${file.name}`;
      const { error: upErr } = await client.storage
        .from("product-images")
        .upload(path, file, { upsert: true });
      if (upErr) {
        alert("Upload : " + upErr.message);
        return;
      }
      const { data: pub } = client.storage.from("product-images").getPublicUrl(path);
      imageUrl = pub.publicUrl;
    }

    const { error } = await client.from("products").insert({
      pharmacy_id: selectedPharmacyId,
      name: document.getElementById("p-name").value.trim(),
      price_fcfa: parseInt(document.getElementById("p-price").value, 10) || 0,
      category: document.getElementById("p-category").value.trim() || "Général",
      image_url: imageUrl || null,
      in_stock: document.getElementById("p-stock").checked,
    });
    if (error) alert(error.message);
    else {
      productForm.reset();
      sessionStorage.removeItem("ks_pharmacies_cache");
      await loadPharmacies();
      showProducts(selectedPharmacyId);
    }
  });

  document.getElementById("pharmacy-image-file")?.addEventListener("change", async (e) => {
    if (!editingId || !e.target.files[0]) return;
    const client = window.KS.getClient();
    const file = e.target.files[0];
    const path = `${editingId}/facade-${Date.now()}-${file.name}`;
    const { error } = await client.storage.from("pharmacy-images").upload(path, file, { upsert: true });
    if (error) {
      alert(error.message);
      return;
    }
    const { data: pub } = client.storage.from("pharmacy-images").getPublicUrl(path);
    document.getElementById("f-image").value = pub.publicUrl;
  });

  requireAuth();
})();
