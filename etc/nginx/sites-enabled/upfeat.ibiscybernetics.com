#
# nginx proxy template for upfeat.ibiscybernetics.com
#
server {
        listen   80;
        server_name upfeat.ibiscybernetics.com;

        location / { rewrite ^/(.*) https://upfeat.ibiscybernetics.com permanent; }
}

server {
        listen 443 ssl http2;
        server_name upfeat.ibiscybernetics.com;
        client_max_body_size 0;

        ssl_certificate /etc/letsencrypt/live/upfeat.ibiscybernetics.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/upfeat.ibiscybernetics.com/privkey.pem;

        ssl_session_timeout 5m;

        #
        # Recommendations from nginx documentations about PCI DSS:
        #
        # https://www.nginx.com/blog/pci-dss-best-practices-with-nginx-plus/
        #
        ssl_protocols TLSv1.2;
        ssl_ciphers ECDHE-ECDSA-CHACHA20-POLY1305:ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:!AES256-GCM-SHA256:!AES256-GCM-SHA128:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;
        proxy_ssl_protocols TLSv1.2;
        proxy_ssl_ciphers   HIGH:!aNULL:!MD5;
        server_tokens off;

        #
        # Recommendations from Mozilla Observatory tool
        #
        # https://github.com/mozilla/observatory-cli
        #
        add_header X-Frame-Options SAMEORIGIN;
        add_header X-Content-Type-Options nosniff always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Strict-Transport-Security max-age=31536000 always;
        add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; connect-src 'self' https://upfeat-backend.ibiscybernetics.com; font-src 'self'; object-src 'none'; media-src 'self'; form-action 'self'; frame-ancestors 'self';" always;

        #
        # Enable ModSecurity as a WAF for PCI DSS compliance
        #
        modsecurity on;
        modsecurity_rules_file /etc/nginx/modsec/main.conf;

        proxy_connect_timeout 7d;
        proxy_read_timeout 7d;
        proxy_send_timeout 7d;

        location / {
            proxy_http_version 1.1;

            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            proxy_pass http://10.128.0.2:8080;
        }
}
