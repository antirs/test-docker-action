FROM ubuntu:latest as build

RUN apt update
RUN apt install --yes golang bash git

FROM build as hugo-build

COPY "./docker"/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]
CMD ["/github/workspace", "./doc/hugo-build.sh", "./"]
