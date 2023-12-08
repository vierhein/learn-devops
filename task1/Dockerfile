# need version?
FROM python 
ARG VENV_DIR=/venv
# Edit tabs, delete slash
LABEL maintainer="Valera" \
      os='Debian'
 
ENV USER_ID=500 \ 
    GROUP_ID=1000 \
    USER_NAME=docker \
    VENV_DIR=${VENV_DIR}

# Replace add to copy? 
ADD ./object.tar.gz $VENV_DIR
 
USER ${USER_NAME}
# Compare layers using 1 run
RUN groupadd -r ${USER_NAME} -g ${GROUP_ID} && useradd -u ${USER_ID} -r -g ${GROUP_ID} ${USER_NAME} \
    && apt update && apt upgrade -y \
    && python3 -m venv $VENV_DIR \
    && chown -R $USER_ID:$GROUP_ID $VENV_DIR \
    && apt-get clean && rm -rf / var/cache/apt/archives \
    # Replace unzip to tar?
    && unzip $VENV_DIR/object.tar.gz
 
WORKDIR $VENV_DIR
EXPOSE 8080
 
ENTRYPOINT ./bin/python3 run.py --port 8080 --json-logging --access-log
