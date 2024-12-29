install() {
    
    echo "\n[Dev-Docker] Installing Go module... \n"

    cd /root/installers/
    curl -OL https://golang.org/dl/go1.23.4.linux-amd64.tar.gz
    tar -C /usr/local -xvf go1.23.4.linux-amd64.tar.gz

    #ENV PATH="/usr/local/go/bin:${PATH}"
    grep -qxF 'export PATH="$PATH:/usr/local/go/bin"' ~/.zshrc || echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.zshrc

    touch /installed/go
}

test -f /installed/go || install

echo "\n [Dev-Docker] Go module installed"
