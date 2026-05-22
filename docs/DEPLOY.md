# Déploiement Kilomètre-Santé

## GitHub Pages

1. Pousser le dépôt sur GitHub (`main`)
2. **Settings** → **Pages** → Source : **GitHub Actions**
3. Le workflow `pages.yml` publie automatiquement à chaque push sur `main`
4. URL : `https://<username>.github.io/kilometre-sante/`

### Configuration Supabase en production

La clé **anon** est publique par design ; la sécurité repose sur les **RLS**.

1. Copier `Project URL` et `anon key` depuis Supabase → Settings → API
2. Créer `assets/js/config.js` localement (non versionné) **ou** modifier le workflow pour injecter les secrets au déploiement
3. Pour un déploiement simple : committer temporairement les clés anon dans `config.js` (acceptable si RLS est actif) — **jamais** la clé `service_role`

## Supabase — checklist

- [ ] Exécuter `supabase/migrations/001_schema.sql`
- [ ] Exécuter `supabase/seed.sql`
- [ ] Vérifier buckets `pharmacy-images` et `product-images`
- [ ] Créer utilisateur admin (Auth → Users → Add user)
- [ ] Tester lecture publique depuis `index.html`
- [ ] Tester CRUD depuis `admin.html`

## Test mobile

Ouvrir l'URL GitHub Pages sur smartphone 4G/3G et vérifier :

- Temps de chargement < 3 s
- Recherche et filtres réactifs
- Images en lazy loading
- Favoris persistants après fermeture de l'onglet
