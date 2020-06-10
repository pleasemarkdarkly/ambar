FROM land007/ubuntu-node:latest

MAINTAINER Jia Yiqiu <yiqiujia@hotmail.com>

RUN echo $(date "+%Y-%m-%d_%H:%M:%S") >> /.image_times && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") > /.image_time && \
	echo "land007/node-http-proxy" >> /.image_names && \
	echo "land007/node-http-proxy" > /.image_name

ADD proxy.js /node_/server.js
RUN . $HOME/.nvm/nvm.sh && cd / && npm install basic-auth

ENV username=admin \
	password=fcea920f7412b5da7be0cf42b8c93759 \
	http_proxy_paths="/api/ /" \
	http_proxy_hosts="192.168.1.218 192.168.1.218" \
	http_proxy_ports="8080 3000" \
	ws_proxy_paths="/api/" \
	ws_proxy_hosts="192.168.1.218" \
	ws_proxy_ports="8080"

ADD node/start.sh /node_/
CMD /check.sh /node && /node/start.sh

# docker build -t land007/node-http-proxy:latest .
# docker rm -f node-http-proxy ; sudo rm -rf ~/docker/node-http-proxy ; docker run -it --privileged --restart=always -v ~/docker/node-http-proxy:/node -p 10080:80 --name node-http-proxy land007/node-http-proxy:latest
