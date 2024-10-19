install() {
    
    echo "\n --> Installing Yarn package... \n"

    npm install -g yarn
    npm install -g eslint
    npm install -g prettier
    npm install -g eslint-plugin-formatjs

    touch /installed/yarn
}

echo "\n --> Running Yarn module... \n"
test -f /installed/yarn || install
