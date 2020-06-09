cd FrontEnd
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

unset ${!DOCKER_*}
docker-compose down
docker-compose up -d
