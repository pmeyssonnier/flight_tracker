# Flight Tracker — Live & Historique

Application web monofichier (HTML/JS + Leaflet) pour suivre un avion en direct et consulter ses vols des 30 derniers jours.

## Fichier

- `flight_tracker_v3.html` — l'application complète (aucune dépendance à installer, ouvrir directement dans un navigateur).

## Fonctionnalités

- Résolution d'une immatriculation (ex : `OO-ABC`) vers son code ICAO24 via **ADSBdb**.
- Suivi live (position, altitude, vitesse, cap) via **OpenSky Network** `/states/all`, rafraîchi toutes les 10 s.
- Historique des vols sur 29 jours via `/flights/aircraft` et tracé GPS d'un vol via `/tracks/all`.
- Panneau ⚙️ pour renseigner les identifiants OAuth2 OpenSky (Client ID / Secret), un Bearer Token manuel ou un proxy CORS.
- Paramètres persistés dans `localStorage`.

## Sources de données

- https://api.adsbdb.com
- https://opensky-network.org/api (compte API Client requis pour l'historique et les tracés)
