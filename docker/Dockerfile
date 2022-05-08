# [[file:../doc/docker.org::*Build docker image][Build docker image:2]]
FROM ubuntu:bionic as build

RUN apt update
RUN apt install shellcheck

FROM build as base

RUN mkdir /opt/sh.wrap

COPY entrypoint.sh entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
CMD ["/opt/sh.wrap/", "test/tests.sh"]
