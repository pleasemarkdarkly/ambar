# https://transfersh.pleasemarkdarkly.com/deK5M/docker-compose-build.sh

FRONTEND_FILE="./FrontEnd/dist/browserconfig.xml"

# elaticsearch
function setup_system() {
  # System settings Elaticsearch
  sysctl -w vm.max_map_count=262144
  sysctl -w net.ipv4.ip_local_port_range="15000 61000"
  sysctl -w net.ipv4.tcp_fin_timeout=30
  sysctl -w net.core.somaxconn=1024
  sysctl -w net.core.netdev_max_backlog=2000
  sysctl -w net.ipv4.tcp_max_syn_backlog=2048
  sysctl -w vm.overcommit_memory=1

  echo "Add above settings to your `/etc/sysctl.conf` file."
}

function setup_front_end() {
[[ ! -x "$(command -v nvm)" ]] && \
  (echo "nvm not found, setting it up" && \
  wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.30.2/install.sh | bash && \
  return) \
  || \
  (echo "nvm found...setting up 8.10" && \
  . ~/.nvm/nvm.sh && \
  . ~/.profile && \
  . ~/.bashrc && \
  nvm install 8.10)

  echo "8.10" > .nvmrc
  nvm use 8.10
  npm install
  npm run compile
}

# setup_system

cd FrontEnd
[[ -f "$FRONTEND_FILE" ]] && (echo "FrontEnd dist folder and files were not detected, building..." && setup_front_end) || echo "FrontEnd has been built"
docker build . -t land007/ambar-frontend:2.1
cd ../Pipeline
docker build . -t land007/ambar-pipeline:2.1
cd ../LocalCrawler
docker build . -t land007/ambar-local-crawler:2.1
cd ../MongoDB
docker build . -t land007/ambar-mongodb:2.1
cd ../ElasticSearch
docker build . -t land007/ambar-es:2.1
cd ../Rabbit
docker build . -t land007/ambar-rabbit:2.1
cd ../Redis
docker build . -t land007/ambar-redis:2.1
cd ../ServiceApi
docker build . -t land007/ambar-serviceapi:2.1
cd ../WebApi
docker build . -t land007/ambar-webapi:2.1
cd ../node-http-proxy
docker build . -t land007/node-http-proxy:2.1

[[ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]] && unset ${!DOCKER_*} || echo "Skipping unset DOCKER_* env variable, shell is not BASH"
[[ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]] && (unset DOCKER_TLS_VERIFY && unset DOCKER_CERT_PATH && unset DOCKER_MACHINE_NAME && unset DOCKER_HOST) \
 || \
 echo "Skipping manual unset DOCKER_ env variables, shell is not ZSH"

docker-compose down
docker-compose up -d

sleep 10

echo "Testing installation"
curl http://localhost:20080 -u admin:1234567
