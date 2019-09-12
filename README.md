# Upfeat Sysadmin / Devops Test - Operations Hello World

This is for the "Operations Hello World" task, which has been deployed at
the following website:

https://upfeat.ibiscybernetics.com

More information about the exact implementation of the design can be found
under the "Features" section below. Be sure to also read the "Cavets and
limitations" section as well since this was intended to be developed quickly.

This relies on sqlite3 with sqlcipher for the database storage and encryption,
specifically the latest sqlcipher v4 with ver good encryption support. To
decrypt the database, use the following commands:

```bash
sqlcipher database/users.sqlcipher
[This then opens the sqlite3 database console]
PRAGMA key = "x'77916DDD37EA00AAE49BF86097E73BD347D7C032D5089F949D463A2690525541'";
```

### Building the docker development images and using them locally

To build the development docker images and then run them, do the following:

```bash
git clone https://github.com/rbisewski/operations_helloworld_upfeat
cd operations_helloworld_upfeat
docker build -t upfeat-devops-app:latest ./app
docker-compose up -d
```

### Deploying the images to a given host server

Included in this repo is an ansible playbook to allow easy deployment to a
given ansible host, and so thus requires ansible installed:

```bash
ansible-playbook -K ansible/deploy-operations-hello-world.yml
```

### Features

* Very simple login and logoff webapp implementing using yarn and Vue.js (frontend) and Vue-router (backend routes).
    * Uses Vue-notifications for pop-up messages
    * Basic form validation

* Frontend web app and backend server fully contained in a single docker image
    * Utilizes an Arch Linux docker image to ensure the latest stable yarn, nodejs, sqlite3, and sqlcipher

* Includes a simple ansible playbook that deploys (and redeploys) the docker instance via docker-compose

* The ansible playbook also sets up a cron job to do hourly backups of the database to Git
    * Note that this occurs if changes to the database have been detected via Git diffs
    * Hourly backups are handled by GitHub Deployment keys; i.e. ssh keys limited to a single repo
    * The playbook is generic enough it could be very easily adapted to any Cloud Linux VM (AWS, GCP, etc)

* Fairly easy to produce both development and production docker images
    * Makes development images by default
    * To make a production image, use `--build-arg DEPLOYMENT="production"` with docker build

* Deploys to a Debian instance of a GCP Cloud VM (free tier) at upfeat.ibiscybernetics.com
    * SSH server on VM requires keys to login
    * Uses GCP Firewall rules to restrict traffic to only the following:
        * 80 (http)
        * 443 (https)
        * 51337 (ssh, deliberately chosen since random internet bots tend to scan 22 a lot)

* CloudFlare (free tier) for DNS protection and CDN with full-page caching.

* Let's Encrypt (free certs) for HTTPS / TLS with nginx proxy (see the nginx folder for templates used)

* SQLCipher v4+ to encrypt the users database with the latest and strongest possible ciphers

### Cavets and limitations (and future ideas)

* Required a small amount of manual work to prepare the Linux distro on my GCP VM
    * In the future could be automated to adjust nginx templates and install certbot and request certs for a given host

* Not entirely kosher with ansible-lint since there are a couple of simplistic `command` tasks that are ran

* In the future, consider CAPTCHA or other means to discourage potential bot traffic on login / registry pages

* In a real production setting, it is not a good idea to store keys in GitHub repos, but for this assignment it is convenient

* When logged in, refreshing the page can sometimes log you out

* Since this as developed quickly, there are likely other glitches or bugs

# Author

This project was created by Robert Bisewski at Ibis Cybernetics. For more
information, contact:

* Website -> www.ibiscybernetics.com

* Email -> rbisewski@ibiscybernetics.com
