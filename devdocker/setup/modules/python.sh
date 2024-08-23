install() {
    
    echo "\n --> Installing Python package... \n"

    apt-get install pip -y

    touch /installed/python.txt
}

echo "\n --> Running Python module... \n"
test -f /installed/python.txt || install