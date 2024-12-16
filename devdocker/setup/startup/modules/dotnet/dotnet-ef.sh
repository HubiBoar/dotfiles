install() {
    
    echo "\n --> Installing Dotnet EntityFramework module... \n"

    dotnet tool install --global dotnet-ef --version 8.0.2 \
        && dotnet tool restore

    touch /installed/dotnet-ef
}

test -f /installed/dotnet-ef || install
echo " --> Dotnet EntityFramework module installed"
