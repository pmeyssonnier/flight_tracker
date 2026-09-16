# ✈️ Flight Tracker

Application web mono-fichier (HTML/JS vanilla + Leaflet) pour suivre un avion spécifique en direct
et visualiser son historique de vols via l'API OpenSky Network.

## Fonctionnalités

- Suivi en direct (position, altitude, vitesse, cap) via `opensky-network.org/api`
- Trajectoire tracée sur carte (Leaflet / OpenStreetMap)
- Recherche du code ICAO24 par immatriculation (API ADSBdb)
- Historique des vols des 30 derniers jours (nécessite un client OAuth2 OpenSky)
- Export CSV de l'historique de positions
- Persistance locale (`localStorage`) entre les sessions, par appareil/navigateur

## Prérequis

- Un compte gratuit sur [opensky-network.org](https://opensky-network.org) → onglet **API Client**
  pour générer un `client_id` / `client_secret` (nécessaire pour l'historique des vols)

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

1. Sur GitHub, ouvrir **Settings → Pages**
2. Source : **Deploy from a branch**, branche `main`, dossier `/ (root)`
3. Le site est publié sur `https://<utilisateur>.github.io/flight_tracker/`

### Serveur perso (nginx)

Copier `index.html` dans le répertoire servi par nginx, par exemple :

```bash
scp index.html user@vps:/var/www/flight_tracker/index.html
```

Aucune configuration particulière n'est nécessaire (pas de backend, pas de build).

## Licence

Usage personnel — données via OpenSky Network (CC-BY 4.0) et ADSBdb.
