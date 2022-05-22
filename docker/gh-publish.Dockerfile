FROM ubuntu:latest as build

RUN apt update
RUN apt install --yes ca-certificates
RUN apt install --yes bash
RUN apt install --yes git
RUN mkdir /go
COPY "${GH_BIN}" "${GH_BIN_DEST}"

FROM build as gh-publish

COPY "${DOCKERFILES_PATH}"/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]
CMD ["${WORK_DIR}", "${SCRIPT}", "${GH_BIN_DEST}", "${DOCS_DIR}"]
