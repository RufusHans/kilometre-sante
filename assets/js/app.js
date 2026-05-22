/**
 * Kilomètre-Santé — Application publique
 */
(function () {
  const FAV_KEY = "ks_favorites";
  let allPharmacies = [];
  let filterDutyOnly = false;
  let filterArrondissement = "";
  let searchQuery = "";

  const els = {
    search: document.getElementById("search"),
    filterDuty: document.getElementById("filter-duty"),
    filterArr: document.getElementById("filter-arrondissement"),
    favoritesSection: document.getElementById("favorites-section"),
    favoritesList: document.getElementById("favorites-list"),
    results: document.getElementById("results"),
    skeleton: document.getElementById("skeleton"),
    count: document.getElementById("result-count"),
    status: document.getElementById("data-status"),
  };

  function getFavorites() {
    try {
      return JSON.parse(localStorage.getItem(FAV_KEY) || "[]").map(String);
    } catch {
      return [];
    }
  }

  function setFavorites(ids) {
    localStorage.setItem(FAV_KEY, JSON.stringify(ids.map(String)));
  }

  function toggleFavorite(id) {
    const sid = String(id);
    const favs = getFavorites();
    const idx = favs.indexOf(sid);
    if (idx >= 0) favs.splice(idx, 1);
    else favs.push(sid);
    setFavorites(favs);
    render();
  }

  function escapeHtml(str) {
    const d = document.createElement("div");
    d.textContent = str;
    return d.innerHTML;
  }

  function formatPrice(n) {
    return new Intl.NumberFormat("fr-FR").format(n) + " FCFA";
  }

  function matchesSearch(p) {
    const q = searchQuery.toLowerCase().trim();
    if (!q) return true;
    return (
      p.name.toLowerCase().includes(q) ||
      p.quartier.toLowerCase().includes(q) ||
      p.arrondissement.toLowerCase().includes(q)
    );
  }

  function getFiltered() {
    return allPharmacies.filter((p) => {
      if (filterDutyOnly && !p.is_on_duty) return false;
      if (filterArrondissement && p.arrondissement !== filterArrondissement)
        return false;
      return matchesSearch(p);
    });
  }

  function renderProducts(products) {
    if (!products || !products.length) {
      return '<p class="products-empty">Aucun produit référencé.</p>';
    }
    return `<ul class="products-list">
      ${products
        .map(
          (pr) => `
        <li class="product-item">
          <img src="${escapeHtml(pr.image_url || "")}" alt="" class="product-thumb" loading="lazy" decoding="async" width="48" height="48" onerror="this.style.visibility='hidden'">
          <div class="product-info">
            <span class="product-name">${escapeHtml(pr.name)}</span>
            <span class="product-meta">${escapeHtml(pr.category)} · ${formatPrice(pr.price_fcfa)}</span>
            <span class="product-stock ${pr.in_stock ? "in-stock" : "out-stock"}">${pr.in_stock ? "En stock" : "Rupture"}</span>
          </div>
        </li>`
        )
        .join("")}
    </ul>`;
  }

  function renderCard(p, isFavoriteSection) {
    const favs = getFavorites();
    const isFav = favs.includes(String(p.id));
    const badgeClass = p.is_on_duty ? "badge--duty" : "badge--closed";
    const badgeText = p.is_on_duty ? "De garde" : "Fermée";
    const img = p.image_url
      ? `<img class="card-image" src="${escapeHtml(p.image_url)}" alt="Façade ${escapeHtml(p.name)}" loading="lazy" decoding="async" width="400" height="200">`
      : `<div class="card-image card-image--placeholder" aria-hidden="true"></div>`;

    return `
      <article class="pharmacy-card" data-id="${escapeHtml(String(p.id))}">
        ${img}
        <div class="card-body">
          <div class="card-header">
            <h2 class="card-title">${escapeHtml(p.name)}</h2>
            <button type="button" class="btn-fav ${isFav ? "is-fav" : ""}" aria-label="${isFav ? "Retirer des favoris" : "Ajouter aux favoris"}" data-fav="${escapeHtml(String(p.id))}">
              <span aria-hidden="true">${isFav ? "★" : "☆"}</span>
            </button>
          </div>
          <span class="badge ${badgeClass}">${badgeText}</span>
          <p class="card-location">${escapeHtml(p.quartier)} · ${escapeHtml(p.arrondissement)}</p>
          <p class="card-hours">${escapeHtml(p.hours)}</p>
          <a class="card-phone" href="tel:${escapeHtml(p.phone.replace(/\s/g, ""))}">${escapeHtml(p.phone)}</a>
          <details class="products-details">
            <summary>Produits en vente (${(p.products || []).length})</summary>
            ${renderProducts(p.products)}
          </details>
        </div>
      </article>`;
  }

  function renderFavorites() {
    const favs = getFavorites();
    const favPharmacies = favs
      .map((id) => allPharmacies.find((p) => String(p.id) === id))
      .filter(Boolean);

    if (!favPharmacies.length) {
      els.favoritesSection.hidden = true;
      return;
    }

    els.favoritesSection.hidden = false;
    els.favoritesList.innerHTML = favPharmacies
      .map((p) => renderCard(p, true))
      .join("");
    bindFavoriteButtons(els.favoritesList);
  }

  function bindFavoriteButtons(root) {
    root.querySelectorAll("[data-fav]").forEach((btn) => {
      btn.onclick = () => toggleFavorite(btn.dataset.fav);
    });
  }

  function renderResults() {
    const list = getFiltered();
    const favs = getFavorites();
    const sorted = [...list].sort((a, b) => {
      const af = favs.includes(String(a.id)) ? 0 : 1;
      const bf = favs.includes(String(b.id)) ? 0 : 1;
      if (af !== bf) return af - bf;
      if (a.is_on_duty !== b.is_on_duty) return a.is_on_duty ? -1 : 1;
      return a.name.localeCompare(b.name, "fr");
    });

    els.count.textContent = `${sorted.length} pharmacie${sorted.length !== 1 ? "s" : ""}`;

    if (!sorted.length) {
      els.results.innerHTML =
        '<p class="empty-state">Aucune pharmacie ne correspond à votre recherche.</p>';
      return;
    }

    els.results.innerHTML = sorted.map((p) => renderCard(p)).join("");
    bindFavoriteButtons(els.results);
  }

  function render() {
    renderFavorites();
    renderResults();
  }

  function populateArrondissements() {
    const arr = [...new Set(allPharmacies.map((p) => p.arrondissement))].sort();
    els.filterArr.innerHTML =
      '<option value="">Tous les arrondissements</option>' +
      arr.map((a) => `<option value="${escapeHtml(a)}">${escapeHtml(a)}</option>`).join("");
  }

  function showSkeleton(show) {
    els.skeleton.hidden = !show;
    els.results.hidden = show;
  }

  async function init() {
    showSkeleton(true);
    try {
      allPharmacies = await window.KS.fetchPharmacies();
      const mode = window.KS.isSupabaseConfigured()
        ? "Données Supabase"
        : "Mode local (JSON)";
      els.status.textContent = mode;
      populateArrondissements();
      render();
    } catch (err) {
      els.results.innerHTML = `<p class="error-state">Erreur de chargement : ${escapeHtml(err.message)}</p>`;
      els.status.textContent = "Erreur";
    } finally {
      showSkeleton(false);
    }
  }

  els.search.addEventListener("input", (e) => {
    searchQuery = e.target.value;
    render();
  });

  els.filterDuty.addEventListener("click", () => {
    filterDutyOnly = !filterDutyOnly;
    els.filterDuty.classList.toggle("is-active", filterDutyOnly);
    els.filterDuty.setAttribute("aria-pressed", String(filterDutyOnly));
    render();
  });

  els.filterArr.addEventListener("change", (e) => {
    filterArrondissement = e.target.value;
    render();
  });

  init();
})();
