#!/bin/sh
# Gera /usr/share/nginx/html/config.js a partir das env vars
cat > /usr/share/nginx/html/config.js << JSEOF
window.APP_CONFIG = {
  SB_URL: "${SUPABASE_URL}",
  SB_ANON: "${SUPABASE_ANON_KEY}",
  SERVICE_KEY: "${SUPABASE_SERVICE_ROLE_KEY}"
};
JSEOF
echo "✓ config.js gerado"
exec nginx -g "daemon off;"
