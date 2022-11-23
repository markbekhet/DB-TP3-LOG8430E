docker build -t tp3-charlie .
docker run -dit --privileged --name tp3-charlie tp3-charlie:latest


docker cp cassandra/. tp3-charlie:/root/cassandra/.
docker cp Mongo/. tp3-charlie:/root/Mongo/.
docker cp redis/. tp3-charlie:/root/redis/.
docker cp script.sh tp3-charlie:/root/script.sh


docker exec -it tp3-charlie /bin/bash
