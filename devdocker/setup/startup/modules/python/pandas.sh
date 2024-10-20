python.sh

install() {
    
    echo "\n --> Installing Pandas module... \n"

    export PIP_BREAK_SYSTEM_PACKAGES=1

    pip install pandas
    pip install openpyxl

    touch /installed/pandas
}

test -f /installed/pandas || install
echo "--> Pandas module installed"
