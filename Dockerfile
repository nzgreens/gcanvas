FROM nginx:latest

RUN mkdir /app

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y unzip wget
WORKDIR /tmp
RUN wget http://storage.googleapis.com/dart-archive/channels/dev/release/latest/sdk/dartsdk-linux-x64-release.zip -O dartsdk-linux-x64-release.zip

RUN mkdir -p /opt
RUN unzip -d /opt/ dartsdk-linux-x64-release.zip
RUN rm dartsdk-linux-x64-release.zip

ENV PATH /opt/dart-sdk/bin:$PATH

COPY nginx/static.conf /etc/nginx/conf.d/

RUN rm /etc/nginx/conf.d/default.conf

RUN service nginx start

WORKDIR /app

COPY . /app

RUN pub install && pub build

