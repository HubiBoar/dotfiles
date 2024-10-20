dotnet.sh

install() {
    
    echo "\n --> Installing Functions module... \n"

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

test -f /installed/functions || install
echo " --> Functions module installed"

