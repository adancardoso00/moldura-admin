#!/bin/sh
# Gera /usr/share/nginx/html/config.js APENAS com a anon key (publishable)
# SERVICE_ROLE_KEY nunca deve ser exposta no frontend
cat > /usr/share/nginx/html/config.js << JSEOF
window.APP_CONFIG = {
  SB_URL: "${SUPABASE_URL}",
  SB_ANON: "${SUPABASE_ANON_KEY}"
};
JSEOF
echo "✓ config.js gerado (sem service_role)"
exec nginx -g "daemon off;"
