FROM node:16

RUN apt-get update && \
    apt install -y zip mc

