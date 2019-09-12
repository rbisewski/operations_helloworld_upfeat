#
# nginx proxy template for upfeat.ibiscybernetics.com
#
server {
        listen   80;
        server_name upfeat.ibiscybernetics.com;

        location / { rewrite ^/(.*) https://upfeat.ibiscybernetics.com permanent; }
}

server {
        client_max_body_size 0;
        listen 443;
        server_name upfeat.ibiscybernetics.com;

        ssl on;
        ssl_certificate /etc/letsencrypt/live/upfeat.ibiscybernetics.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/upfeat.ibiscybernetics.com/privkey.pem;

        ssl_session_timeout 5m;

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers "HIGH:!aNULL:!MD5 or HIGH:!aNULL:!MD5:!3DES";
        ssl_prefer_server_ciphers on;

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
