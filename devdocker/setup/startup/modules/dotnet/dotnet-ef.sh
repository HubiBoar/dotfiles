install() {
    
    echo "\n --> Installing Dotnet EntityFramework module... \n"

    grep -qxF 'export PATH="$PATH:/root/.dotnet/tools"' ~/.zshrc || echo 'export PATH="$PATH:/root/.dotnet/tools"' >> ~/.zshrc
    dotnet tool install --global dotnet-ef --version 8.0.2 \
        && dotnet tool restore

    touch /installed/dotnet-ef
}

test -f /installed/dotnet-ef || install
echo " --> Dotnet EntityFramework module installed"
