# Flight Tracker — Live & Historique

Application **mobile-first en un seul fichier HTML/JS** (Leaflet + API OpenSky Network) : suivi d'un avion en direct, tracé de sa trajectoire sur carte, et récupération de ses vols passés (30 jours) avec rendu GPS.

## Fichier

- `flight_tracker_v3.html` — l'application complète. Aucune dépendance à installer : ouvre le fichier directement dans un navigateur (Leaflet est chargé depuis un CDN).

## Points d'architecture à connaître

- **OpenSky Network** est l'API gratuite la plus adaptée. Le suivi live basique (`/states/all`) fonctionne sans clé, avec une limite d'environ 400 requêtes/jour en anonyme.
- **Depuis mars 2026, l'authentification login/mot de passe est supprimée.** Il faut un client **OAuth2** (`client_id` / `client_secret`), gratuit, à créer sur opensky-network.org → *My flights* → onglet **API Client**. Ces identifiants sont nécessaires pour l'historique des vols (`/flights/aircraft`) et les trajectoires passées (`/tracks/all`). Sans eux, seul le suivi live fonctionne.
- **Limite structurelle** : contrairement à des comptes comme @elonjet ou @aviondebernard qui tournent 24/7 sur un serveur, cette page ne suit l'avion que **pendant qu'elle est ouverte** dans le navigateur. Les paramètres (immatriculation, ICAO24, identifiants, token) sont conservés en `localStorage` entre les sessions, mais rien ne tourne si l'onglet est fermé. Pour un tracking permanent, il faut un petit script Python en cron sur un VPS qui logge dans un fichier JSON/CSV que cette page viendrait lire.
- **Recherche par immatriculation** (ex. `OO-ABC`, `F-GXYZ`) via l'API gratuite **ADSBdb**, pour retrouver le hex ICAO24 sans le connaître par cœur.

## Utilisation

1. Ouvre `flight_tracker_v3.html` dans un navigateur.
2. Trouve l'ICAO24 hex de l'appareil :
   - soit via le champ immatriculation + bouton **🔍 ADSBdb** (recherche automatique),
   - soit manuellement (FlightRadar24, opensky-network.org/aircraft-database) dans le champ **ICAO (hex)**.
3. Pour l'historique et les tracés passés, ouvre le panneau **⚙️** et colle ton **Client ID** / **Client Secret** OpenSky, puis **Enregistrer les paramètres**.
   - Si le navigateur bloque l'appel OAuth2 (CORS), utilise le bouton **📋 Commande curl** : lance la commande dans un terminal, puis colle l'`access_token` obtenu dans le champ *Bearer Token*.
   - Un proxy CORS personnalisé (ex. Cloudflare Worker) peut aussi être renseigné.
4. Clique **▶ Suivre** pour le live (position, altitude, vitesse, cap, rafraîchi toutes les 10 s).
5. Clique **📅 30j** pour lister les vols des 30 derniers jours, puis **Tracer** sur un vol pour afficher sa trajectoire GPS avec les pastilles départ / arrivée.
6. **🧹 Traces** efface toutes les traces et marqueurs de la carte.

## Sources de données

- https://api.adsbdb.com — résolution immatriculation → ICAO24 et modèle.
- https://opensky-network.org/api — positions live, historique des vols, trajectoires.
