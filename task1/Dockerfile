# Add version
FROM python:3.9 
ARG VENV_DIR=/venv
# Edit tabs
LABEL maintainer="Valera" \
      os='Debian'
 
ENV USER_ID=500 \ 
    GROUP_ID=1000 \
    USER_NAME=docker \
    VENV_DIR=${VENV_DIR}
# workdir moved
WORKDIR $VENV_DIR
# Replace add to copy 
COPY ./object.tar.gz $VENV_DIR

RUN groupadd -r ${USER_NAME} -g ${GROUP_ID} && useradd -u ${USER_ID} -r -g ${GROUP_ID} ${USER_NAME}

# Delete space in path and compare
RUN apt-get update && apt upgrade -y && \
    apt-get clean && rm -rf /var/cache/apt/archives
# Edit tabs
RUN python3 -m venv $VENV_DIR && \
    chown -R $USER_ID:$GROUP_ID $VENV_DIR
# Switch user must be after adding user, and commands which need root permission 
USER ${USER_NAME}
# Replace unzip to tar
RUN tar -xzvf $VENV_DIR/object.tar.gz

EXPOSE 8080
 
ENTRYPOINT ./bin/python3 run.py --port 8080 --json-logging --access-log
