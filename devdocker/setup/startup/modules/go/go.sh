install() {
    
    echo "\n[Dev-Docker] Installing Go module... \n"

    cd /root/installers/
    curl -OL https://golang.org/dl/go1.23.4.linux-amd64.tar.gz
    tar -C /usr/local -xvf go1.23.4.linux-amd64.tar.gz

    grep -qxF 'export PATH="$PATH:/usr/local/go/bin"' ~/.zshrc || echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.zshrc
    #rm -rf /usr/local/go && tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz

    touch /installed/go
}

test -f /installed/go || install

echo "[Dev-Docker] Go module installed"
