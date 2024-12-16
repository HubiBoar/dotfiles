install() {
    
    echo "\n [Dev-Docker] Installing Dotnet module... \n"

    cd /root/installers/
    wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb

    apt update
    apt install -y dotnet-sdk-8.0=8.0.404-1

    touch /installed/dotnet
}

test -f /installed/dotnet || install
echo "\n [Dev-Docker] Dotnet module installed"
