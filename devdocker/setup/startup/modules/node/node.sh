install() {
    
    echo "\n --> Installing Node module... \n"

    apt-get update && apt-get install nodejs -y 
    apt-get update && apt-get install npm -y
    npm cache clean -f
    npm install -g n
    n 22.9.0

    touch /installed/node
}

test -f /installed/node || install
echo " --> Node module installed"
