installDotnet() {
    
    echo "\n --> Installing Dotnet package... \n"

    #get packages
    wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
        && dpkg -i packages-microsoft-prod.deb \
        && rm packages-microsoft-prod.deb

    #dotnet 8.0
    rm /etc/apt/sources.list.d/microsoft-prod.list
    apt-get install -y dotnet-sdk-8.0

    #dotnet ef
    grep -qxF 'export PATH="$PATH:/root/.dotnet/tools"' ~/.zshrc || echo 'export PATH="$PATH:/root/.dotnet/tools"' >> ~/.zshrc
    dotnet tool install --global dotnet-ef --version 8.0.2 \
        && dotnet tool restore

    touch /installed/dotnet.txt
}

echo "\n --> Running Dotnet module... \n"
test -f /installed/dotnet.txt || installDotnet