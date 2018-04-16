FROM centos/systemd

MAINTAINER Jorge Useche <juusechec@gmail.com>
USER root
# Based on https://github.com/AgenciaImplementacion/Postgres-LADM_COL/blob/master/Dockerfile

#WORKDIR /sql
ADD ./scripts/ /scripts
RUN chmod 0755 /scripts/*.sh
RUN /scripts/01-set_permisive.sh
RUN /scripts/02-install_utilities.sh
RUN /scripts/03-install_postgresql_postgis.sh
RUN /scripts/04-install_symfony.sh
RUN /scripts/05-install_composer.sh
RUN /scripts/06-install_apache.sh
RUN /scripts/07-install_varnish.sh
# others scripts are executed in entrypoint

# Remove unnecesary
RUN yum clean all
RUN rm -rf /var/cache/yum

#EXPOSE 5432
#EXPOSE 8080
#EXPOSE 80

RUN groupadd -g 1000 appuser && \
    useradd -r -u 1000 -g appuser appuser
#USER appuser

CMD ["sh", "/scripts/docker-entrypoint.sh"]
