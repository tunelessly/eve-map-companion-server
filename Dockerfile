ARG rendererWorkDir=/renderer
ARG frontendWorkDir=/frontend

FROM nikolaik/python-nodejs:python3.12-nodejs22 as base
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
RUN apt update
RUN apt install -y \
    graphviz \
    graphviz-dev \
    sqlite3 \
    build-essential
ARG rendererWorkDir
ARG frontendWorkDir
RUN corepack enable
RUN mkdir ${rendererWorkDir} \
    mkdir ${frontendWorkDir} 
ENV rendererWorkDir=${rendererWorkDir}
ENV frontendWorkDir=${frontendWorkDir}
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
ENV UID=${UID}
ENV GID=${GID}
ENTRYPOINT [ "sh", "-c", \
    "echo UID:GID $UID:$GID; \ 
     git clone --depth 1 https://github.com/tunelessly/EVESVGRenderer.git /temp && mv /temp/* ${rendererWorkDir} && \
     git clone --depth 1 https://github.com/tunelessly/eve-map-companion.git ${frontendWorkDir} && \
     cd ${rendererWorkDir} && chmod +x run.sh && poetry install && ./run.sh && \
     cd ${frontendWorkDir} && yarn install --non-interactive && yarn build && \
     cd / && \
     cp -r ${rendererWorkDir}/output/*.svg final/ && \
     cp -r ${frontendWorkDir}/dist/* final/ && \
     chown -R $UID:$GID final/; \
" ]