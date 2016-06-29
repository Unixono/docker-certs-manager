# docker-certs-manager
A simple key-csr-crt manager for Let's Encrypt, that uses the ACME protocol to generate the certificates. Internally uses the python script [acme-tiny](https://github.com/diafygi/acme-tiny).

### Why is useful?
It helps in container environments like CoreOS. Centralizes the creation, distribution and renewal of domain certificates. Also, with a cron or systemd-timer, you could configure auto-renewal certificates for your domains.

### How it distributes the files?
All files will be stored in a main directory of your choise (for this tutorial, we'll use `/data/letsencript`), and categorized in the subfolders:

  - `/data/letsencript/key/<domain>/<domain>.key`   --> For storing keys.
  - `/data/letsencript/csr/<domain>/<domain>.csr`   --> For storing certificate signing requests.
  - `/data/letsencript/crt/<domain>/<domain>.crt`   --> For storing certificates.
  - `/data/letsencript/challenges/<domain>/`        --> For storing challenges directories.

For example, for the domain `example.com`, you'll have:

    /data/letsencript/key/example.com/example.com.key
    /data/letsencript/csr/example.com/example.com.csr
    /data/letsencript/crt/example.com/example.com.crt
    /data/letsencript/challenges/example.com/

### How to use it?

  - Pull the image from the hub:

    ```sh
    $ docker pull facundovictor/docker-certs-manager

    ```

  - Run the container specifying the main volume to use:

    ```sh
    $ docker run -dit --name certs-manager -v ~/letsencript/:/var/letsencript/ facundovictor/docker-certs-manager
    ```

To be continued...
