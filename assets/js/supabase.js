/**
 * Client Supabase partagé — Kilomètre-Santé
 */
(function () {
  const cfg = window.KS_CONFIG || {};
  const url = (cfg.SUPABASE_URL || "").trim();
  const key = (cfg.SUPABASE_ANON_KEY || "").trim();

  window.KS = window.KS || {};

  window.KS.isSupabaseConfigured = function () {
    return (
      url.length > 0 &&
      key.length > 0 &&
      !url.includes("votre-projet") &&
      !key.includes("votre_cle")
    );
  };

  window.KS.getClient = function () {
    if (!window.KS.isSupabaseConfigured()) return null;
    if (!window.supabase) {
      console.warn("Supabase JS SDK non chargé");
      return null;
    }
    if (!window.KS._client) {
      window.KS._client = window.supabase.createClient(url, key);
    }
    return window.KS._client;
  };

  const CACHE_KEY = "ks_pharmacies_cache";
  const CACHE_TTL_MS = 5 * 60 * 1000;

  window.KS.getCachedPharmacies = function () {
    try {
      const raw = sessionStorage.getItem(CACHE_KEY);
      if (!raw) return null;
      const parsed = JSON.parse(raw);
      if (Date.now() - parsed.ts > CACHE_TTL_MS) {
        sessionStorage.removeItem(CACHE_KEY);
        return null;
      }
      return parsed.data;
    } catch {
      return null;
    }
  };

  window.KS.setCachedPharmacies = function (data) {
    try {
      sessionStorage.setItem(
        CACHE_KEY,
        JSON.stringify({ ts: Date.now(), data })
      );
    } catch {
      /* quota */
    }
  };

  window.KS.fetchPharmacies = async function () {
    const cached = window.KS.getCachedPharmacies();
    if (cached) return cached;

    const client = window.KS.getClient();
    if (client) {
      const { data, error } = await client
        .from("pharmacies")
        .select("*, products(*)")
        .order("name");
      if (error) throw error;
      const normalized = (data || []).map(normalizePharmacy);
      window.KS.setCachedPharmacies(normalized);
      return normalized;
    }

    const base = window.KS.getBasePath();
    const res = await fetch(`${base}data/seed-pharmacies.json`);
    if (!res.ok) throw new Error("Impossible de charger les données locales");
    const json = await res.json();
    const list = (json.pharmacies || []).map(normalizePharmacy);
    window.KS.setCachedPharmacies(list);
    return list;
  };

  window.KS.getBasePath = function () {
    const path = window.location.pathname;
    if (path.endsWith("/")) return path;
    const last = path.split("/").pop() || "";
    if (last.includes(".")) {
      return path.slice(0, path.lastIndexOf("/") + 1);
    }
    return path.endsWith("/") ? path : path + "/";
  };

  function normalizePharmacy(row) {
    const products = (row.products || []).map((p) => ({
      id: p.id,
      name: p.name,
      price_fcfa: p.price_fcfa,
      category: p.category,
      image_url: p.image_url,
      in_stock: p.in_stock !== false,
    }));
    return {
      id: row.id || row.legacy_id,
      legacy_id: row.legacy_id,
      name: row.name,
      arrondissement: row.arrondissement,
      quartier: row.quartier,
      phone: row.phone,
      hours: row.hours,
      is_on_duty: !!row.is_on_duty,
      image_url: row.image_url || "",
      products,
    };
  }
})();
