FROM centos:7.4.1708

MAINTAINER Jorge Useche <juusechec@gmail.com>
USER root

#WORKDIR /sql
ADD ./scripts/ /scripts
RUN chmod 0755 /scripts/*.sh
RUN /scripts/01-set_permisive.sh
RUN /scripts/02-install_utilities.sh
RUN /scripts/03-install_postgresql_postgis.sh
RUN /scripts/05-install_symfony.sh
RUN /scripts/06-install_composer.sh
RUN /scripts/07-install_apache.sh
RUN /scripts/09-install_varnish.sh

# Remove unnecesary
RUN yum clean all
RUN rm -rf /var/cache/yum

EXPOSE 80
EXPOSE 5432
CMD ["sh", "/scripts/docker-entrypoint.sh"]
