install() {
    
    echo "\n --> Installing Az CLI package... \n"

    curl -sSL https://aka.ms/InstallAzureCLIDeb | bash

    touch /installed/azcli
}

echo "\n --> Running Az CLI module... \n"
test -f /installed/azcli || install
