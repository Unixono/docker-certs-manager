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
After generating the domain key, and certificate signing request file, you are searching for generating the domain certificate. For this, you must prove you own the domains you want a certificate for. So, Let's Encrypt requires you host some challenge files on them (Particularly under `http://<domain>/.well-known/acme-challenge/`).

But, how do you get those challente files? Don't worry, the script [acme-tiny](https://github.com/diafygi/acme-tiny) will write them for you, connect to Let's encrypt to validate you own the domain, and finally will generate your domain certificate. NOTE: Let's Encrypt will perform a plain HTTP request to port 80 on your server, so you must serve the challenge files via HTTP (a redirect to HTTPS is fine too).

### How to use it?

  - Pull the image from the hub:

    ```sh
    $ docker pull facundovictor/docker-certs-manager

    ```

  - Run the container specifying the main volume to use:

    ```sh
    $ docker run -dit --name certs-manager -v ~/letsencrypt/:/var/letsencrypt/ facundovictor/docker-certs-manager
    ```

To be continued...
