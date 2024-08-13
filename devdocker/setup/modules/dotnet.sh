#wget
wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb

#dotnet 8.0
rm /etc/apt/sources.list.d/microsoft-prod.list
apt-get install -y dotnet-sdk-8.0

#dotnet ef
echo 'export PATH="$PATH:/root/.dotnet/tools" ' >> ~/.zshrc
dotnet tool install --global dotnet-ef --version 8.0.2 \
    && dotnet tool restore