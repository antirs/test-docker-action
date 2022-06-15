FROM ubuntu:latest as build

RUN apt update
RUN apt install --yes bash
RUN apt install --yes git
RUN apt install --yes golang
RUN apt install --yes make

FROM build as hugo-build

COPY "${DOCKERFILES_PATH}"/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]
CMD ["${WORK_DIR}", "${SCRIPT}", "${GIT_PATH}", "${GIT_REPO}"]
