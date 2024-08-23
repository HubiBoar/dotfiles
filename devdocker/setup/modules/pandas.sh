python.sh

install() {
    
    echo "\n --> Installing Pandas package... \n"

    export PIP_BREAK_SYSTEM_PACKAGES=1

    pip install pandas
    pip install openpyxl

    touch /installed/pandas.txt
}

echo "\n --> Running Pandas module... \n"
test -f /installed/pandas.txt || install

