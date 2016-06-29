# docker-certs-manager
A simple key-csr-crt manager for Let's Encrypt, that uses the ACME protocol to generate the certificates. Internally uses the python script [acme-tiny](https://github.com/diafygi/acme-tiny).

### Why is useful?
It helps in container environments like CoreOS. Centralizes the creation, distribution and renewal of domain certificates. Also, with a cron or systemd-timer, you could configure auto-renewal certificates for your domains.

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
