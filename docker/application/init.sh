#!/bin/bash

# if container already initialized, just skip next operations
if [ -s $HOME/docker_init_success ]; then
    echo "Initialization: Container already initialized"
else
    echo "Initialization: clear NPM cache"
    rm /tmp/* -R -f

    echo "Initialization: clear NPM modules"
    cd /usr/src/app && rm node_modules -R -f

    # create flag that tell this container already was initialized
    echo "true" > $HOME/docker_init_success
fi

echo "Initialization: installing node modules"
cd /usr/src/app && npm install -g gulp migrate-mongoose && npm install gulp && npm install

echo "Initialization: apply migrations to database"
cd /usr/src/app && migrate up --es6 --autosync --dbConnectionUri $database__uri

echo "Initialization: starting the server"
if [ "$NODE_ENV" == "production" ]; then
    cd /usr/src/app && npm run start
else
    cd /usr/src/app && npm run start:dev
fi

