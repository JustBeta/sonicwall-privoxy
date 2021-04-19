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
COPY nxBender/nxBender.sh /nxBender.sh
RUN chmod u+x /nxBender.sh
RUN /nxBender.sh && rm /nxBender.sh

# Proxy Privoxy
COPY privoxy/privoxy.sh /privoxy.sh
# COPY privoxy/config /etc/privoxy/config
RUN chmod u+x /privoxy.sh
RUN /privoxy.sh  && rm /privoxy.sh

# Add Additionnal route
# ADD add-route.sh /usr/sbin/
# RUN chmod u+x /usr/sbin/add-route.sh

# Simple health Check
# HEALTHCHECK CMD netstat -an | grep 8118 > /dev/null; if [ 0 != $? ]; then exit 1; fi;
# HEALTHCHECK --interval=1m --timeout=10s \
#   CMD if [[ $( curl -x localhost:8118 https://api.nordvpn.com/vpn/check/full | jq -r '.["status"]' ) = "Protected" ]] ; then exit 0; else exit 1; fi

# Proxy Squid
# COPY squid/squid.sh /squid.sh
# ADD squid/squid.conf /etc/squid3/squid.conf
# RUN chmod u+x /squid.sh
# RUN /squid.sh

# Main Docker
RUN apk add --no-cache tini
ADD start.sh /usr/sbin/
RUN chmod u+x /usr/sbin/start.sh

WORKDIR /
VOLUME /config
EXPOSE 8118

ENTRYPOINT ["/sbin/tini", "/usr/sbin/start.sh"]
