# docker-centos-symfony-postgis

## Used software
- POSTGRES 9.5 + POSTGIS 2.95
- Apache
- PHP 71
- Composer
- Symfony command
- Varnish

## Construct and upload
```
$ docker build -t juusechec/centos-symfony-postgis:latest . -f Dockerfile
$ docker login
$ docker push juusechec/centos-symfony-postgis:latest
```

## Init
```
docker-compose up
# get command shell
docker-compose exec app bash
```
