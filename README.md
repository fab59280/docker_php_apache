# Docker Image with PHP and Apache2

### Configuration

You can build every PHP version you want by passing it to build arguments:
```shell
docker build --build-arg PHP_VERSION=7.1 -t my_image_name .
```
Also, you can configure the user you want to bind inside the container :
```shell
docker build --build-arg HOST_UID=(id -u) --build-arg HOST_GID=(id -g) -t my_image_name .
```

### List of the available 'ARG' params
* ```PHP_VERSION=7.1```
* ```HOST_UID=1000```
* ```HOST_GID=1000```
* ```NODE_VERSION=0```
* ```WITH_SYMFONY=0```

You can specify which version of PHP you want to install, your user and group id (in case of volumes bind mounting)
and if you want to install Node (in a certain specified version) and symfony binaries in its latest version.
### Features
This image is built with **composer** and **symfony 5** binaries
