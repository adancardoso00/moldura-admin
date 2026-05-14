#!/bin/sh
# Gera /usr/share/nginx/html/config.js APENAS com a anon key (publishable)
# SERVICE_ROLE_KEY nunca deve ser exposta no frontend
# SB_URL = /sb (proxy reverso interno) pra evitar CORS + bloqueio de extensões privacy
cat > /usr/share/nginx/html/config.js << JSEOF
window.APP_CONFIG = {
  SB_URL: "/sb",
  SB_ANON: "${SUPABASE_ANON_KEY}"
};
JSEOF
echo "✓ config.js gerado (sem service_role, SB_URL=/sb)"

# Injeta o host real do Supabase no nginx.conf (proxy reverso)
SB_HOST=$(echo "${SUPABASE_URL}" | sed -e 's|https\?://||' -e 's|/.*||')
sed -i "s|__SUPABASE_HOST__|${SB_HOST}|g" /etc/nginx/conf.d/default.conf
echo "✓ nginx proxy /sb/ → ${SB_HOST}"

exec nginx -g "daemon off;"
