# [[file:../doc/docker.org::*Build docker image][Build docker image:2]]
FROM ubuntu:bionic as build

RUN apt update
RUN apt install shellcheck

FROM build as base

RUN mkdir /opt/sh.wrap

ENTRYPOINT ["bash", "/opt/sh.wrap/test/tests.sh"]
CMD ["src", "test"]
# Build docker image:2 ends here

FROM base as test

COPY ./ /opt/sh.wrap/
