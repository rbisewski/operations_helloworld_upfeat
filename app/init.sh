#!/bin/bash

# start backend server for Vue routes
cd /app
yarn server server/app.js & disown

# start frontend server for login page
#service nginx start
nginx -g "daemon off;"

# do nothing
sleep infinity
