FROM node:8.10

RUN apt-get update && apt-get install -y iptables && apt-get clean
# Set a timezone
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY . .
RUN yarn install
RUN yarn run build

ENV LANIP=172.18.0.1
ADD iptables.sh	/
RUN chmod +x /iptables.sh
#CMD node --max-old-space-size=8096 dist
CMD /iptables.sh ; node --max-old-space-size=8096 dist

HEALTHCHECK --interval=5s --timeout=30s --retries=50 \
  CMD curl -f localhost:8082/api/ || exit 1