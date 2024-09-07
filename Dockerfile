ARG rendererWorkDir=/renderer
ARG rendererDownloadDir=${rendererWorkDir}/downloads
ARG rendererOutputDir=${rendererWorkDir}/database
ARG rendererDatadumpDir=${rendererWorkDir}/datadump
ARG rendererSourceFile=sqlite-latest.sqlite.bz2
ARG rendererSourceURL=https://www.fuzzwork.co.uk/dump/
ARG frontendWorkDir=/frontend/

FROM nikolaik/python-nodejs:python3.12-nodejs22 as base
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y \
    graphviz \
    graphviz-dev \
    sqlite3 \
    build-essential

FROM base as renderer_build
ARG rendererWorkDir
# Set up the python app
RUN mkdir ${rendererWorkDir}
WORKDIR ${rendererWorkDir}
RUN git clone https://github.com/tunelessly/EVESVGRenderer.git .
RUN poetry install
# Grab dependencies
ARG rendererDownloadDir
ARG rendererOutputDir
ARG rendererSourceFile
ARG rendererSourceURL
RUN mkdir ${rendererDownloadDir}
RUN mkdir ${rendererOutputDir}
WORKDIR ${rendererDownloadDir}
RUN wget --no-verbose --show-progress --progress=dot:giga ${rendererSourceURL}${rendererSourceFile}
RUN bzip2 -d ${rendererSourceFile}
# Transform the database
ARG rendererDatadumpDir
WORKDIR ${rendererDatadumpDir}
RUN chmod +x run.sh
RUN ./run.sh ${rendererDownloadDir}/sqlite-latest.sqlite
RUN mv ./database_transformed.sqlite3 ${rendererOutputDir}/
# Render the database contents to SVG
WORKDIR ${rendererWorkDir}
ENV PYTHONUNBUFFERED=1
RUN poetry run start ${rendererOutputDir}/database_transformed.sqlite3

FROM renderer_build as frontend_build
ARG frontendWorkDir
RUN corepack enable
WORKDIR ${frontendWorkDir}
RUN git clone https://github.com/tunelessly/eve-map-companion.git .
RUN yarn install
RUN yarn build
ARG rendererWorkDir
COPY --from=renderer_build ${rendererWorkDir}/output/ ${frontendWorkDir}/dist
RUN rm dist/.gitkeep
RUN ls -lah ${frontendWorkDir}/dist