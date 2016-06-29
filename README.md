# docker-certs-manager
A simple key-csr-crt manager for Let's Encrypt, that uses the ACME protocol to generate the certificates. Internally uses the python script [acme-tiny](https://github.com/diafygi/acme-tiny).

### Why is useful?
It helps in container environments like CoreOS. Centralizes the creation, distribution and renewal of domain certificates. Also, with a cron or systemd-timer, you could configure auto-renewal certificates for your domains.

### How it distributes the files?
All files will be stored in a main directory of your choise (for this tutorial, we'll use `/data/letsencrypt`), and categorized in the subfolders:

  - `/data/letsencrypt/key/account.key`             --> This is fixed and it will store the Let's encrypt account key.
  - `/data/letsencrypt/key/<domain>/<domain>.key`   --> For storing keys.
  - `/data/letsencrypt/csr/<domain>/<domain>.csr`   --> For storing certificate signing requests.
  - `/data/letsencrypt/crt/<domain>/<domain>.crt`   --> For storing certificates.
  - `/data/letsencrypt/challenges/<domain>/`        --> For storing challenges directories.

For example, for the domain `example.com`, you'll have:

    /data/letsencrypt/key/account.key
    /data/letsencrypt/key/example.com/example.com.key
    /data/letsencrypt/csr/example.com/example.com.csr
    /data/letsencrypt/crt/example.com/example.com.crt
    /data/letsencrypt/challenges/example.com/

### How it works, and what's the "challenges" directory?
After generating the domain key, and certificate signing request file, you are searching for generating the domain certificate, but first, you must prove you own the domain you want a certificate for. Let's Encrypt requires you host some challenge files on them (Particularly under `http://<domain>/.well-known/acme-challenge/`).

But, how do you get those challente files? Don't worry, the script [acme-tiny](https://github.com/diafygi/acme-tiny) will write them for you, connect to Let's encrypt to validate you own the domain, and finally will generate your certificate. Let's Encrypt will perform a plain HTTP request to port 80 on your server, so you must serve the challenge files via HTTP (a redirect to HTTPS is fine too).

### How to use it?

1. Pull the image from the hub:

    ```sh
    $ docker pull facundovictor/docker-certs-manager

    ```

2. Create the folder where you'll store the files (this will be mapped to `/var/letsencrypt/` folder inside the container):

    ```sh
    mkdir -p /data/letsencrypt/
    ```

3. Generate your **Let's encrypt** account key:

    ```sh
    docker run --rm -v /data/letsencrypt/:/var/letsencrypt/ facundovictor/docker-certs-manager ./manage_certs.sh generate_key account
    ```

4. Generate your domain private key (For the sake of explain it, we'll continue using the domain `example.com`):

    ```sh
    docker run --rm -v /data/letsencrypt/:/var/letsencrypt/ facundovictor/docker-certs-manager ./manage_certs.sh generate_key domain example.com
    ```

5. Generate your domain CSR (certificate signing request): The ACME protocol (what Let's Encrypt uses) requires a CSR file to be submitted to it, even for renewals. You can use the same CSR for multiple renewals. NOTE: you can't use your account private key as your domain private key!

    ```sh
    docker run --rm -v /data/letsencrypt/:/var/letsencrypt/ facundovictor/docker-certs-manager ./manage_certs.sh generate_csr domain example.com
    ```

6. Make your website host challenge files: You must prove you own the domains you want a certificate for, so Let's Encrypt will perform a plain HTTP request to port 80 on your server, and will ask for the challenge files. This script will generate and write those files, so all you need to do is make sure that the `/data/letsencrypt/challenges/<your-domain>/` folder is served under the `/.well-known/acme-challenge/` url path.


    #make some challenge folder (modify to suit your needs)
    mkdir -p /var/www/challenges/
    #example for nginx
    server {
        listen 80;
        server_name yoursite.com www.yoursite.com;

        location /.well-known/acme-challenge/ {
            alias /var/www/challenges/;
            try_files $uri =404;
        }

        ...the rest of your config
    }


  **NOTE:** Let's Encrypt will perform a plain HTTP request to port 80 on your server, so you must serve the challenge files via HTTP (a redirect to HTTPS is fine too).

7. Generate your domain certificate:

    ```sh
    docker run --rm -v /data/letsencrypt/:/var/letsencrypt/ facundovictor/docker-certs-manager ./manage_certs.sh generate_crt domain example.com
    ```

To be continued...
