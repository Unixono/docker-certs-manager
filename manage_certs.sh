#!/usr/bin/bash
# REMEMBER: you can't use your account private key as your domain private key!!


# Directories where you will store your files
KEY_DIR=./key
CSR_DIR=./csr
CRT_DIR=./crt

# Binaries
ACME_TINY=./acme-tiny/acme_tiny.py
OPENSSL=/usr/bin/openssl
PYTHON=/usr/bin/python
###############################################################################
# EXIT codes

SUCCESS=0
EMPTY_PARAM=1
OPENSSL_ERROR=2

###############################################################################

helpme(){
    echo -e ">> Certificate manager \n"
    echo -e "Usage: $0 { generate_key { account | domain [domain-value] } } | generate_csr [domain-value] | generate_crt }\n"
    echo "NOTE: you can't use your account private key as your domain private key!"
}

generate_private_key(){
    if [ -z "$1" ] ; then
        echo -e "ERROR: empty account | domain name"
        exit 1
    fi
    mkdir -p $KEY_DIR
    $OPENSSL genrsa 4096 > "${KEY_DIR}/${1}.key"
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
	    echo -e "ERROR: Openssl error: $RESULT"
		echo $OPENSSL_ERROR
	fi
}

generate_certificate_signing_request(){
    if [ -z "$1" ] ; then
        echo -e "ERROR: empty domain"
        exit 1
    fi
    mkdir -p $CSR_DIR
    $OPENSSL req -new -sha256 -key "${KEY_DIR}/${1}.key" -subj "/CN=${1}" > "${CSR_DIR}/${1}.csr"
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
	    echo -e "ERROR: Openssl error: $RESULT"
		echo $OPENSSL_ERROR
	fi
}

case "$1" in
    generate_key)
        case "$2" in
            account)
                generate_private_key "account"
                ;;
            domain)
                generate_private_key "$3"
                ;;
            *)
                helpme
                ;;
        esac
        ;;
    generate_csr)
        generate_certificate_signing_request "$2"
        ;;
    generate_crt)
        echo "CRT"
        ;;
    *)
        helpme
        ;;
esac
