install() {
    
    echo "\n --> Installing Az CLI Module... \n"

    curl -sSL https://aka.ms/InstallAzureCLIDeb | bash

    touch /installed/azcli
}

test -f /installed/azcli || install

echo " --> Az CLI Module instaled"
