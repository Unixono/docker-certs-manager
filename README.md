# docker-certs-manager
A simple key-csr-crt manager for Let's Encrypt. That doesn't depend on the Certbot.

###How to use it?

  - Pull the image from the hub:

    ```sh
    $ docker pull facundovictor/docker-certs-manager

    ```

  - Run the container specifying the main volume to use:

    ```sh
    $ docker run -dit --name certs-manager -v ~/letsencript/:/var/letsencript/ facundovictor/docker-certs-manager
    ```

To be continued...
