curl -OL https://golang.org/dl/go1.23.4.linux-amd64.tar.gz
tar -C /usr/local -xvf go1.23.4.linux-amd64.tar.gz

grep -qxF 'export PATH="$PATH:/usr/local/go/bin"' ~/.zshrc || echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.zshrc
