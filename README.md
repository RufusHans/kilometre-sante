# Kilomètre-Santé

Application web **mobile-first** permettant aux habitants de **Pointe-Noire** (République du Congo) de trouver rapidement les pharmacies **de garde**, de filtrer par arrondissement ou quartier, et de consulter les produits disponibles.

Projet académique — MOA : M. Webster L'architecte | MOE : binômes développeurs.

## Fonctionnalités

- Annuaire de **18 pharmacies** réelles de Pointe-Noire
- **Code couleur** : vert = De garde, gris = Fermée
- **Recherche** dynamique par nom ou quartier
- Filtre **« De garde uniquement »** et par **arrondissement**
- **Favoris** persistants (`localStorage`)
- **Images** des pharmacies et **catalogue produits** avec miniatures
- **Panneau admin** (Supabase Auth) : CRUD pharmacies, toggle garde, gestion produits, upload images
- **Mode hors-ligne données** : fonctionne avec `data/seed-pharmacies.json` sans Supabase

## Technologies

- HTML5, CSS3, JavaScript (ES6+, vanilla — sans React/Angular)
- [Supabase](https://supabase.com) (PostgreSQL, Auth, Storage) — optionnel
- GitHub Pages pour l'hébergement statique

## Démarrage local (le plus simple)

**Double-cliquez sur `DEMARRER.bat`** dans le dossier du projet, puis ouvrez dans le navigateur :

**http://localhost:8080**

> Ne double-cliquez pas sur `index.html` seul : sans serveur, les données ne se chargent pas.

Alternative PowerShell :

```powershell
cd C:\Users\hansr\kilometre-sante
powershell -File scripts\serve.ps1
```

## Site en ligne

**https://rufushans.github.io/kilometre-sante/**

Sans configuration Supabase, l'application charge automatiquement les données depuis `data/seed-pharmacies.json`.

### Configuration Supabase (recommandé)

1. Créer un projet Supabase « Kilomètre-Santé »
2. Exécuter [`supabase/migrations/001_schema.sql`](supabase/migrations/001_schema.sql) puis [`supabase/seed.sql`](supabase/seed.sql)
3. Créer un utilisateur admin dans **Authentication** (ex. `admin@kilometresante.cg`)
4. Copier `assets/js/config.example.js` vers `assets/js/config.js` et renseigner :

```js
window.KS_CONFIG = {
  SUPABASE_URL: "https://xxxx.supabase.co",
  SUPABASE_ANON_KEY: "eyJhbG..."
};
```

Voir [docs/DEPLOY.md](docs/DEPLOY.md) pour GitHub Pages et Supabase.

## Administration

- URL : `/admin.html`
- Compte à créer dans le dashboard Supabase (ne pas committer de mot de passe)
- Email suggéré : `admin@kilometresante.cg`

## Déploiement GitHub Pages

URL publique (après activation) :

`https://VOTRE_UTILISATEUR.github.io/kilometre-sante/`

Le workflow `.github/workflows/pages.yml` déploie automatiquement la branche `main`.

## Livrables MOA

| Livrable | Emplacement |
|----------|-------------|
| Code source | Racine du dépôt |
| README | Ce fichier |
| Maquette | [`docs/maquette.svg`](docs/maquette.svg) — exporter en PNG via navigateur (Ctrl+S) |
| Vidéo publicité | À publier sur YouTube — ajouter le lien ici : **TODO** |
| Historique commits | ≥ 10 commits nommés en français |

## Structure

```
index.html          # Annuaire public
admin.html          # Panneau admin
assets/css/         # Styles mobile-first
assets/js/          # Logique applicative
data/               # Données locales de secours
supabase/           # Migrations SQL
docs/               # Documentation et maquette
```

## Licence

Projet éducatif — usage pédagogique.
