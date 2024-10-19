dotnet.sh

install() {
    
    echo "\n --> Installing Functions package... \n"

    #func
    apt-get install azure-functions-core-tools-4

    #node
    apt-get install -y \
        nodejs \
        npm

    #azurite
    npm install -g azurite

    touch /installed/functions
}

echo "\n --> Running Functions module... \n"
test -f /installed/functions || install

