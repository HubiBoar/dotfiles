install() {
    
    echo "\n --> Installing Dotnet module... \n"

    apt-get update && apt-get install -y dotnet-sdk-8.0
    apt-get update && apt-get install -y dotnet-runtime-8.0

    touch /installed/dotnet
}

test -f /installed/dotnet || install
echo " --> Dotnet module installed"
