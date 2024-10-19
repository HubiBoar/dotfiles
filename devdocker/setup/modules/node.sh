install() {
    
    echo "\n --> Installing Node package... \n"

    apt-get update && apt-get install nodejs -y 
    apt-get update && apt-get install npm -y
    npm cache clean -f
    npm install -g n
    n 22.9.0

    touch /installed/node
}

echo "\n --> Running Node module... \n"
test -f /installed/node || install
