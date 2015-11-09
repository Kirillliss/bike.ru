echo 'Crearing backup snapshot ...'
heroku pgbackups:capture --expire
echo 'Done!'
echo 'Downloading ...'
wget -O `pwd`/db/production.dump `heroku pgbackups:url`
echo 'Done!'
echo 'Loading to dev db ...'
pg_restore --verbose --clean --no-acl --no-owner -U deppkind -d newskibike_development `pwd`/db/production.dump
echo 'Done!'
