# Docker Image with PHP and Apache2

### Configutration

You can build every PHP version you want by passing it to build :
```shell
docker build --build-arg PHP_VERSION=7.1 -t my_image_name .
```
Also, you can configure the user you want to bind inside the container :
```shell
docker build --build-arg HOST_UID=$(id -u) --build-arg HOST_GID=$(id -g) -t my_image_name .
```
