FROM ubuntu:bionic as build

RUN apt update
RUN apt install --yes bash shellcheck

FROM build

COPY "./docker"/entrypoint.sh entrypoint.sh
COPY test/tests.sh tests.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]
CMD ["/github/workspace", "/tests.sh", "./test"]
