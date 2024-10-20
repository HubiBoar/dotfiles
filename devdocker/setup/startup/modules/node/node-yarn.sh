install() {
    
    echo "\n --> Installing Node Yarn module... \n"

    npm install -g yarn
    npm install -g eslint
    npm install -g prettier
    npm install -g eslint-plugin-formatjs

    touch /installed/yarn
}

test -f /installed/yarn || install
echo " --> Node Yarn module installed"
