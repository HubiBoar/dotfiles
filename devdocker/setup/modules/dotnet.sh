install() {
    
    echo "\n --> Installing Dotnet package... \n"

    apt-get update && apt-get install -y dotnet-sdk-8.0
    apt-get update && apt-get install -y dotnet-runtime-8.0

    touch /installed/dotnet
}

echo "\n --> Running Dotnet module... \n"
test -f /installed/dotnet || install
