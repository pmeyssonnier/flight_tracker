# ✈️ Flight Tracker

Application web mono-fichier (HTML/JS vanilla + Leaflet) pour suivre un avion spécifique en direct
et visualiser son historique de vols via l'API OpenSky Network.

🌐 **Site en ligne : https://pmeyssonnier.github.io/flight_tracker/**

## Fonctionnalités

- Suivi en direct (position, altitude, vitesse, cap) via `opensky-network.org/api`
- Trajectoire tracée sur carte (Leaflet / OpenStreetMap)
- Recherche du code ICAO24 par immatriculation (API ADSBdb), avec bouton de sélection rapide 🏎 PH-DTF (Falcon 900EX de Max Verstappen)
- Historique des vols des 30 derniers jours (nécessite un client OAuth2 OpenSky)
- Export CSV de l'historique de positions
- Persistance locale (`localStorage`) entre les sessions, par appareil/navigateur
- Thème sombre / clair (bouton dans le panneau ⚙️), fond de carte assorti

## Prérequis

- Un compte gratuit sur [opensky-network.org](https://opensky-network.org) → onglet **API Client**
  pour générer un `client_id` / `client_secret` (nécessaire pour l'historique des vols)

## Configuration des secrets (`.env`)

Les identifiants peuvent être saisis dans le panneau **⚙️** de la page (stockés en `localStorage`),
ou fournis via un fichier `.env` **jamais commité** :

```bash
cp .env.example .env        # puis remplir OPENSKY_CLIENT_ID, OPENSKY_CLIENT_SECRET, OPENSKY_TOKEN…
./scripts/make_config.sh    # génère config.local.js, lu automatiquement par index.html
```

- `.env` et `config.local.js` sont ignorés par git (voir `.gitignore`).
- Une page HTML statique ne peut pas lire un `.env` directement : `config.local.js` sert de pont.
- Les valeurs saisies dans le panneau ⚙️ priment sur celles du `.env`.
- ⚠️ Ne déploie pas `config.local.js` sur un site public : le Client Secret serait lisible par tous.
  Sur un hébergement public, préfère la saisie dans ⚙️ ou un token seul (durée de vie limitée).

## Utilisation

1. Ouvrir `index.html` dans un navigateur (ou via l'URL déployée)
2. Renseigner le code ICAO24 (ou une immatriculation) de l'avion à suivre
3. Cliquer sur **▶ Suivre**
4. (Optionnel) Renseigner les identifiants OAuth pour charger l'historique des vols

## Limitations connues

- Le suivi live n'accumule de l'historique que pendant que l'onglet est ouvert
  (pas de collecte en arrière-plan)
- L'API anonyme OpenSky est limitée en fréquence (~400 requêtes/jour)
- Les trajectoires détaillées de vols passés (`/tracks/all`) ne sont pas garanties
  au-delà de quelques jours

## Déploiement

Le projet est un fichier statique : n'importe quel hébergeur de fichiers statiques convient.

### GitHub Pages

Le workflow `.github/workflows/pages.yml` publie `index.html` seul (jamais `.env` ni `config.local.js`).

1. Sur GitHub : **Settings → Pages → Build and deployment → Source : GitHub Actions**
2. Onglet **Actions → Deploy to GitHub Pages → Run workflow**, choisir la branche, lancer
3. Le site est publié sur `https://<utilisateur>.github.io/flight_tracker/`

Ensuite, chaque push sur `main` redéploie automatiquement.

Sur cette version publique, les identifiants OpenSky se saisissent dans le panneau **⚙️**
(ils restent dans le `localStorage` de ton navigateur).

### Serveur perso (nginx)

Copier `index.html` dans le répertoire servi par nginx, par exemple :

```bash
scp index.html user@vps:/var/www/flight_tracker/index.html
```

Aucune configuration particulière n'est nécessaire (pas de backend, pas de build).

## Licence

Usage personnel — données via OpenSky Network (CC-BY 4.0) et ADSBdb.
