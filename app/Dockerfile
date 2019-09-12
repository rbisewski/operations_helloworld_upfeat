FROM archlinux/base:latest
ARG DEPLOYMENT
RUN pacman -Syyuv --noconfirm && pacman --noconfirm -S wget procps nginx make gcc sqlcipher nodejs yarn npm python2 python grep
RUN mkdir /app
ADD . /app/
RUN sed -i 's/ENCRYPTION_KEY/77916DDD37EA00AAE49BF86097E73BD347D7C032D5089F949D463A2690525541/g' /app/server/db.js
RUN if [ "$DEPLOYMENT" = "production" ]; then sed -i 's/const isProduction = false/const isProduction = true/g' /app/src/main.js; fi
RUN cd /app/ && yarn
RUN cd /app/ && yarn build
RUN rm -rf /usr/share/nginx/html
RUN ln -s /app/dist /usr/share/nginx/html
RUN mv /app/nginx.conf /etc/nginx/nginx.conf
ENTRYPOINT ["/bin/bash","/app/init.sh"]
