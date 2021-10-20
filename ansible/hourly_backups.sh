#!/bin/bash
echo "Attempting backup on: $(date)"
cd /git/operations_helloworld_upfeat
git pull
git config --global user.email "contact@ibiscybernetics.com"
git config --global user.name "Robert Bisewski"
cp /database/users.sqlcipher /git/operations_helloworld_upfeat/app/database/
cd /git/operations_helloworld_upfeat
git add *
git commit -m "hourly database backup"
git push

if [ $? -eq 0 ]
then
    echo "Backup was successful."
else
    echo "Backup failed."
fi
