install() {
    
    echo "\n --> Installing Python module... \n"

    apt-get install pip -y

    touch /installed/python
}

test -f /installed/python || install
echo " --> Python module installed"
