install() {
    
    echo "\n[Dev-Docker] Installing SqlCmd module... \n"

    cd /root/installers/
    curl -OL https://github.com/microsoft/go-sqlcmd/releases/download/v1.8.0/sqlcmd-linux-amd64.tar.bz2
    tar -C /usr/local/bin -xvf sqlcmd-linux-amd64.tar.bz2

    grep -qxF 'export PATH="$PATH:/usr/local/go/bin"' ~/.zshrc || echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.zshrc

    touch /installed/sqlcmd
}

test -f /installed/sqlcmd || install

echo "\n [Dev-Docker] SqlCmd module installed"
