FROM ubuntu:latest as build

RUN apt update
RUN apt install --yes pandoc
RUN mkdir /go
COPY "${HUGO_BIN}" "${HUGO_BIN_DEST}"

FROM build as hugo-site

COPY "${DOCKERFILES_PATH}"/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]
CMD ["${WORK_DIR}", "${SCRIPT}", "${HUGO_BIN_DEST}", "${DOCS_DIR}"]
