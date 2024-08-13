#update
apt-get -y update \
    && apt-get -qy full-upgrade

#func
apt-get install azure-functions-core-tools-4

#node
apt-get install -y \
    nodejs \
    npm

#azurite
npm install -g azurite