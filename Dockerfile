FROM nginx:1.9
MAINTAINER Samuel Taylor "samtaylor.uk@gmail.com"

# Install wget and install/updates certificates
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && apt-get update \
  && apt-get install -y -q --no-install-recommends \
    ca-certificates \
    wget \
  && apt-get clean \
  && rm -r /var/lib/apt/lists/*

# Install Forego
RUN wget -P /usr/local/bin https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego \
  && chmod u+x /usr/local/bin/forego

ENV DOCKER_GEN_VERSION 0.6.0

RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
  && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
  && rm /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

COPY Procfile virtualhosts.tmpl /app/
COPY nginx.conf /etc/nginx/nginx.conf
WORKDIR /app/

ENV DOCKER_HOST unix:///tmp/docker.sock

VOLUME ["/etc/nginx/certs"]

CMD ["forego", "start", "-r"]
