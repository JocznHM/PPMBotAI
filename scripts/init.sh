#!/bin/bash

# Obtener la ruta del directorio raíz del proyecto
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${PROJECT_ROOT}/.env"

if [ -f "$ENV_FILE" ]; then
  echo ".env ya existe en la raíz. No se sobrescribirá."
else
  cat <<EOF > "$ENV_FILE"
EVOLUTION_API_KEY=06E#76:Xq3)\\
NGROK_TOKEN=1uGlXRyPsbbnwO6hlr2WP3OVT6g_67EX3wcQ75zegxEm27Kqe
N8N_BASIC_AUTH_PASSWORD=72[%F>]V@8h+
EOF
  echo ".env creado correctamente en: $ENV_FILE"
fi

echo "Arrancando contenedores desde: $PROJECT_ROOT"
cd "$PROJECT_ROOT" && docker compose up -d

echo "Esperando 10 segundos para que ngrok se inicialice..."
sleep 10

echo "Obteniendo URL pública de ngrok..."
NGROK_URL=$(curl --silent http://localhost:4040/api/tunnels | grep -oP '(?<=public_url":")[^"]+')

if [ -n "$NGROK_URL" ]; then
  echo "✅ URL pública de ngrok: $NGROK_URL"
else
  echo "❌ No se pudo obtener la URL pública de ngrok."
fi
