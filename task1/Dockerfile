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

# Replace add to copy 
COPY ./object.tar.gz $VENV_DIR

RUN groupadd -r ${USER_NAME} -g ${GROUP_ID} && useradd -u ${USER_ID} -r -g ${GROUP_ID} ${USER_NAME}
# Switch user must be after adding 
USER ${USER_NAME}
RUN apt update && apt upgrade -y
# Edit tabs
RUN python3 -m venv $VENV_DIR && \
    chown -R $USER_ID:$GROUP_ID $VENV_DIR 
RUN apt-get clean && rm -rf / var/cache/apt/archives
# Replace unzip to tar
RUN tar -xzvf $VENV_DIR/object.tar.gz
 
WORKDIR $VENV_DIR
EXPOSE 8080
 
ENTRYPOINT ./bin/python3 run.py --port 8080 --json-logging --access-log
