#!/usr/bin/bash
###############################################################################
# @author: facundovictor: facundovt@gmail.com
###############################################################################
# The volume for the challenge directory should be served in:
#   http://<domain>/.well-known/acme-challenge/
#
# REMEMBER: you can't use your account private key as your domain private key!!
###############################################################################
# Directories where you will store your files. A unique volume should be
# created for each Directory.
KEY_DIR=./key
CSR_DIR=./csr
CRT_DIR=./crt
###############################################################################
# Binaries
ACME_TINY=./acme-tiny/acme_tiny.py
OPENSSL=/usr/bin/openssl
PYTHON=/usr/bin/python
###############################################################################
# EXIT codes
SUCCESS=0
EMPTY_PARAM=1
OPENSSL_ERROR=2
ACME_ERROR=2
###############################################################################

helpme(){
    echo -e ">> Certificate manager \n"
    echo -e "Usage: $0 { generate_key { account | domain <domain-value> } } | \
generate_csr <domain-value> | generate_crt <domain-value> <challenge-dir> }\n"
    echo "NOTE: you can't use your account private key as your domain private \
key!"
}

generate_private_key(){
    if [ -z "$1" ] ; then
        echo -e "ERROR: empty account | domain name"
        exit $EMPTY_PARAM
    fi
    mkdir -p $KEY_DIR
    $OPENSSL genrsa 4096 > "${KEY_DIR}/${1}.key"
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
	    echo -e "ERROR: Openssl error: $RESULT"
		exit $OPENSSL_ERROR
	fi
}

generate_certificate_signing_request(){
    if [ -z "$1" ] ; then
        echo -e "ERROR: empty domain"
        exit $EMPTY_PARAM
    fi
    mkdir -p $CSR_DIR
    $OPENSSL req \
			-new -sha256 \
			-key "${KEY_DIR}/${1}.key" \
			-subj "/CN=${1}" > "${CSR_DIR}/${1}.csr"
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
	    echo -e "ERROR: Openssl error: $RESULT"
		exit $OPENSSL_ERROR
	fi
}

generate_certificate(){
    if [ -z "$1" ] ; then
        echo -e "ERROR: empty domain"
        exit $EMPTY_PARAM
    fi
    mkdir -p $CRT_DIR
	if [ -z "$2" ] ; then
        echo -e "ERROR: empty challenge dir"
        exit $EMPTY_PARAM
	fi
	ACME_CHALLENGE_DIR="$2"
	$PYTHON $ACME_TINY \
		--account-key "${KEY_DIR}/account.key" \
		--csr "${CSR_DIR}/${1}.csr" \
		--acme-dir $ACME_CHALLENGE_DIR > "${CRT_DIR}/${1}.crt"

	RESULT=$?
	if [ $RESULT -ne 0 ]; then
	    echo -e "ERROR: ACME error: $RESULT"
		exit $ACME_ERROR
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
        generate_certificate "$2" "$3"
        ;;
    *)
        helpme
        ;;
esac
