FROM python:3.9-alpine
LABEL MAINTAINER Joseph Barone <jbarone@free.fr>

# Usage:
#
# Create:
#
# docker volume create config
# docker build -t sonicwall-privoxy .
# docker run --restart always --detach --privileged -p 8118:8118 --name sonicwall-privoxy -v config:/config sonicwall-privoxy
#
# Delete:
#
# docker stop sonicwall-privoxy
# docker rm sonicwall-privoxy
# docker rmi sonicwall-privoxy
# docker volume rm config

# VPN nxBender (Sonicwall)
# COPY nxBender/nxBender.sh /nxBender.sh
RUN wget https://github.com/JustBeta/sonicwall-privoxy/blob/main/nxBender/nxBender.sh -O /nxBender.sh
RUN chmod u+x /nxBender.sh
RUN /nxBender.sh && rm /nxBender.sh

# Proxy Privoxy
#COPY privoxy/privoxy.sh /privoxy.sh
RUN wget https://github.com/JustBeta/sonicwall-privoxy/blob/main/privoxy/privoxy.sh -O /privoxy.sh
RUN chmod u+x /privoxy.sh
RUN /privoxy.sh  && rm /privoxy.sh

# Main Docker
RUN apk add --no-cache tini
# ADD start.sh /usr/sbin/
RUN wget https://github.com/JustBeta/sonicwall-privoxy/blob/main/start.sh -O /usr/sbin/
RUN chmod u+x /usr/sbin/start.sh

WORKDIR /
VOLUME /config
EXPOSE 8118

ENTRYPOINT ["/sbin/tini", "/usr/sbin/start.sh"]
