#!/usr/bin/env bash
# Génère config.local.js (lu par index.html) à partir du fichier .env
# Usage : ./scripts/make_config.sh [chemin/.env]
set -euo pipefail
ENV_FILE="${1:-.env}"
OUT="config.local.js"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Fichier $ENV_FILE introuvable. Copie .env.example vers .env et remplis-le." >&2
  exit 1
fi

declare -A ENVV
# Lecture ligne à ligne (pas de "source") : les valeurs peuvent contenir $, ", ' ou \ sans risque
while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%$'\r'}"
  [[ -z "${line// }" || "${line:0:1}" == "#" ]] && continue
  [[ "$line" != *=* ]] && continue
  key="${line%%=*}"; val="${line#*=}"
  key="${key#"${key%%[![:space:]]*}"}"; key="${key%"${key##*[![:space:]]}"}"
  key="${key#export }"
  val="${val#"${val%%[![:space:]]*}"}"; val="${val%"${val##*[![:space:]]}"}"
  # Retire une paire de guillemets englobants éventuelle
  if [[ ${#val} -ge 2 && ( ( "${val:0:1}" == '"' && "${val: -1}" == '"' ) || ( "${val:0:1}" == "'" && "${val: -1}" == "'" ) ) ]]; then
    val="${val:1:${#val}-2}"
  fi
  ENVV["$key"]="$val"
done < "$ENV_FILE"

json_str() { printf '%s' "${1:-}" | sed 's/\\/\\\\/g; s/"/\\"/g'; }
get() { printf '%s' "${ENVV[$1]:-}"; }

cat > "$OUT" <<JS
// Généré par scripts/make_config.sh — NE PAS COMMITER (contient des secrets)
window.FLIGHT_TRACKER_CONFIG = {
  clientId: "$(json_str "$(get OPENSKY_CLIENT_ID)")",
  clientSecret: "$(json_str "$(get OPENSKY_CLIENT_SECRET)")",
  token: "$(json_str "$(get OPENSKY_TOKEN)")",
  proxyUrl: "$(json_str "$(get OPENSKY_PROXY_URL)")",
  reg: "$(json_str "$(get AIRCRAFT_REG)")",
  icao24: "$(json_str "$(get AIRCRAFT_ICAO24)")"
};
JS
echo "✅ $OUT généré depuis $ENV_FILE"
