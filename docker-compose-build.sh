# https://transfersh.pleasemarkdarkly.com/deK5M/docker-compose-build.sh
cd FrontEnd

[[ ! -x "$(command -v nvm)" ]] && (echo "nvm not found, setting it up" && wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.30.2/install.sh | bash && return) || echo "nvm found...setting up 8.10"
. ~/.nvm/nvm.sh && . ~/.profile && . ~/.bashrc && nvm install 8.10
echo "8.10" > .nvmrc
nvm use 8.10

npm install
npm run compile
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

# ZSH doesn't like this syntax
# unset ${!DOCKER_*}
unset DOCKER_TLS_VERIFY
unset DOCKER_CERT_PATH
unset DOCKER_MACHINE_NAME
unset DOCKER_HOST

docker-compose down
docker-compose up -d
