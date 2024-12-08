install() {
    
    echo "\n --> Installing Dotnet module... \n"

    apt update && apt install -y dotnet-sdk-8.0=8.0.404-1

    touch /installed/dotnet
}

test -f /installed/dotnet || install
echo " --> Dotnet module installed"
