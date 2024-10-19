install() {
    
    echo "\n --> Installing Dotnet EntityFramework package... \n"

    grep -qxF 'export PATH="$PATH:/root/.dotnet/tools"' ~/.zshrc || echo 'export PATH="$PATH:/root/.dotnet/tools"' >> ~/.zshrc
    dotnet tool install --global dotnet-ef --version 8.0.2 \
        && dotnet tool restore

    touch /installed/dotnet-ef
}

echo "\n --> Running Dotnet EntityFramework module... \n"
test -f /installed/dotnet-ef || install
