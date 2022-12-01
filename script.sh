#install Pre-requirements
sudo apt-get install git -y
sudo apt-get install python2 -y
sudo apt-get install python3-virtualenv -y
sudo apt-get install default-jre -y
sudo apt-get install maven -y
sudo apt-get -y install python2-pip-whl
sudo apt-get -y install python2-setuptools-whl

# create virtual environment and activate the virtual environment
virtualenv -p /usr/bin/python2 venv
source venv/bin/activate

# clone the repo for benchmarking
git clone http://github.com/brianfrankcooper/YCSB.git
cd YCSB
mvn -pl site.ycsb:redis-binding -am clean package

cd ..

## Run the container for redis DB and run the tests
printf "\nRunning Benchmarks on redis DB, results can be found in the redis folder \n\n"
docker-compose -f redis/docker-compose.yml up --scale redis-master=1 --scale redis-replica=3 -d
cd YCSB
for i in {1..3}
do
printf "Loading data worload A try $i \n" >> ../redis/outputLoadRedis.csv 
./bin/ycsb load redis -s -P workloads/workloada -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> ../redis/outputLoadRedis.csv
printf "Running test workoad A try $i\n" > ../redis/outputRunRedis.csv
./bin/ycsb run redis -s -P workloads/workloada -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> ../redis/outputRunRedis.csv

printf "\n##################################################################################\n" >> ../redis/outputLoadRedis.csv 
printf " Loading data worload B try $i \n" >> ../redis/outputLoadRedis.csv 
./bin/ycsb load redis -s -P workloads/workloadb -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> ../redis/outputLoadRedis.csv
printf "\n##################################################################################\n" >> ../redis/outputRunRedis.csv
printf "Running test workoad B try $i\n" >> ../redis/outputRunRedis.csv
./bin/ycsb run redis -s -P workloads/workloadb -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> ../redis/outputRunRedis.csv

printf "\n##################################################################################\n" >> ../redis/outputLoadRedis.csv 
printf "Loading data worload C try $i\n" >> ../redis/outputLoadRedis.csv 
./bin/ycsb load redis -s -P workloads/workloadc -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> ../redis/outputLoadRedis.csv
printf "\n##################################################################################\n" >> ../redis/outputRunRedis.csv
printf "Running test workoad C try $i\n" >> ../redis/outputRunRedis.csv
./bin/ycsb run redis -s -P workloads/workloadc -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> ../redis/outputRunRedis.csv

printf "\n##################################################################################\n" >> ../redis/outputLoadRedis.csv 
printf "Loading data worload D  try $i\n" >> ../redis/outputLoadRedis.csv 
./bin/ycsb load redis -s -P workloads/workloadd -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> ../redis/outputLoadRedis.csv
printf "\n##################################################################################\n" >> ../redis/outputRunRedis.csv
printf "Running test workoad D try $i\n" >> ../redis/outputRunRedis.csv
./bin/ycsb run redis -s -P workloads/workloadd -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> ../redis/outputRunRedis.csv

printf "\n##################################################################################\n" >> ../redis/outputLoadRedis.csv
printf "Loading data worload E try $i\n" >> ../redis/outputLoadRedis.csv 
./bin/ycsb load redis -s -P workloads/workloade -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> ../redis/outputLoadRedis.csv
printf "\n##################################################################################\n" >> ../redis/outputRunRedis.csv
printf "Running test workoad E try $i\n" >> ../redis/outputRunRedis.csv
./bin/ycsb run redis -s -P workloads/workloade -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> ../redis/outputRunRedis.csv

printf "\n##################################################################################\n" >> ../redis/outputLoadRedis.csv
printf "Loading data worload F try $i\n" >> ../redis/outputLoadRedis.csv 
./bin/ycsb load redis -s -P workloads/workloadf -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> ../redis/outputLoadRedis.csv
printf "\n##################################################################################\n" >> ../redis/outputRunRedis.csv
printf "Running test workoad F try $i\n" >> ../redis/outputRunRedis.csv
./bin/ycsb run redis -s -P workloads/workloadf -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" >> ../redis/outputRunRedis.csv
done
cd ..
docker-compose -f redis/docker-compose.yml down -v
printf "\nFinished benchmarking redis DB \n\n"


##========================================================================##

## Run the container for Mongo DB and run the tests
printf "\nRunning Benchmarks on Mongo DB, results can be found in the Mongo folder \n\n"
docker-compose -f Mongo/docker-compose.yml up -d
docker exec -it primary mongosh --eval "rs.initiate({
 _id: \"myReplicaSet\",
 members: [
   {_id: 0, host: \"192.168.5.2:27017\"},
   {_id: 1, host: \"192.168.5.3:27017\"},
   {_id: 2, host: \"192.168.5.4:27017\"},
   {_id: 3, host: \"192.168.5.5:27017\"}
 ]
})"

cd YCSB
for i in (1..3)
do
printf "\n##################################################################################\n" > ../Mongo/outputLoadAsyncMongo.csv
printf "Loading workoad A try $i\n" >> ../Mongo/outputLoadAsyncMongo.csv
./bin/ycsb load mongodb-async -s -P workloads/workloada -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 >> ../Mongo/outputLoadAsyncMongo.csv
printf "\n##################################################################################\n" > ../Mongo/outputRunAsyncMongo.csv
printf "Running test workoad A try $i\n" > ../Mongo/outputRunAsyncMongo.csv
./bin/ycsb run mongodb-async -s -P workloads/workloada -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 >> ../Mongo/outputRunAsyncMongo.csv

printf "\n##################################################################################\n" >> ../Mongo/outputLoadAsyncMongo.csv
printf "Loading workoad B try $i\n" >> ../Mongo/outputLoadAsyncMongo.csv
./bin/ycsb load mongodb-async -s -P workloads/workloadb -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 >> ../Mongo/outputLoadAsyncMongo.csv
printf "\n##################################################################################\n" >> ../Mongo/outputRunAsyncMongo.csv
printf "Running test workoad B try $i\n" >> ../Mongo/outputRunAsyncMongo.csv
./bin/ycsb run mongodb-async -s -P workloads/workloadb -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 >> ../Mongo/outputRunAsyncMongo.csv

printf "\n##################################################################################\n" >> ../Mongo/outputLoadAsyncMongo.csv
printf "Loading workoad C try $i\n" >> ../Mongo/outputLoadAsyncMongo.csv
./bin/ycsb load mongodb-async -s -P workloads/workloadc -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 >> ../Mongo/outputLoadAsyncMongo.csv
printf "\n##################################################################################\n" >> ../Mongo/outputRunAsyncMongo.csv
printf "Running test workoad C try $i\n" >> ../Mongo/outputRunAsyncMongo.csv
./bin/ycsb run mongodb-async -s -P workloads/workloadc -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 >> ../Mongo/outputRunAsyncMongo.csv

printf "\n##################################################################################\n" >> ../Mongo/outputLoadAsyncMongo.csv
printf "Loading workoad D try $i\n" >> ../Mongo/outputLoadAsyncMongo.csv
./bin/ycsb load mongodb-async -s -P workloads/workloadd -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 >> ../Mongo/outputLoadAsyncMongo.csv
printf "\n##################################################################################\n" >> ../Mongo/outputRunAsyncMongo.csv
printf "Running test workoad D try $i\n" >> ../Mongo/outputRunAsyncMongo.csv
./bin/ycsb run mongodb-async -s -P workloads/workloadd -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 >> ../Mongo/outputRunAsyncMongo.csv

printf "\n##################################################################################\n" >> ../Mongo/outputLoadAsyncMongo.csv
printf "Loading workoad E try $i\n" >> ../Mongo/outputLoadAsyncMongo.csv
./bin/ycsb load mongodb-async -s -P workloads/workloade -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 >> ../Mongo/outputLoadAsyncMongo.csv
printf "\n##################################################################################\n" >> ../Mongo/outputRunAsyncMongo.csv
printf "Running test workoad E try $i\n" >> ../Mongo/outputRunAsyncMongo.csv
./bin/ycsb run mongodb-async -s -P workloads/workloade -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 >> ../Mongo/outputRunAsyncMongo.csv

printf "\n##################################################################################\n" >> ../Mongo/outputLoadAsyncMongo.csv
printf "Loading workoad F try $i\n" >> ../Mongo/outputLoadAsyncMongo.csv
./bin/ycsb load mongodb-async -s -P workloads/workloadf -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 >> ../Mongo/outputLoadAsyncMongo.csv
printf "\n##################################################################################\n" >> ../Mongo/outputRunAsyncMongo.csv
printf "Running test workoad F try $i\n" >> ../Mongo/outputRunAsyncMongo.csv
./bin/ycsb run mongodb-async -s -P workloads/workloadf -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 >> ../Mongo/outputRunAsyncMongo.csv
done
cd ..
docker-compose -f Mongo/docker-compose.yml down -v
printf "\nFinished benchmarking Mongo DB \n\n"
#
####========================================================================##
##
####Run the container for Cassandra DB and run the tests
printf "\nRunning Benchmarks on Cassandra DB, results can be found in the cassandra folder \n\n"
docker-compose -f cassandra/docker-compose.yml up -d &
#Sleep for a minute to make sure the nodes have communicated together
sleep 120
# Make sure that all nodes are in the cluster 4 nodes in total
docker exec -it cassandra1 nodetool status
cd YCSB

docker exec -it cassandra1 cqlsh 192.168.5.2 -u cassandra -p cassandra -e "create keyspace ycsb WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor':3}"

docker exec -it cassandra1 cqlsh 192.168.5.2 -u cassandra -p cassandra -e "create table ycsb.usertable (
    y_id varchar primary key,
    field0 varchar,
    field1 varchar,
    field2 varchar,
    field3 varchar,
    field4 varchar,
    field5 varchar,
    field6 varchar,
    field7 varchar,
    field8 varchar,
    field9 varchar);"

for i in {1..3}
do
printf "\n##################################################################################\n" > ../cassandra/outputLoadCassandra.csv
printf "Loading workoad A try $i \n" >> ../cassandra/outputLoadCassandra.csv
./bin/ycsb load cassandra-cql -s -P workloads/workloada \
-p "hosts=192.168.5.2,192.168.5.3,192.168.5.4,192.168.5.5" \
-p "cassandra.password=cassandra" \
-p "cassandra.username=cassandra" >> ../cassandra/outputLoadCassandra.csv

printf "\n##################################################################################\n" > ../cassandra/outputRunCassandra.csv
printf "Running tests workoad A try $i\n" >> ../cassandra/outputRunCassandra.csv
./bin/ycsb run cassandra-cql -s -P workloads/workloada \
-p "hosts=192.168.5.2,192.168.5.3,192.168.5.4,192.168.5.5" \
-p "cassandra.password=cassandra" \
-p "cassandra.username=cassandra" >> ../cassandra/outputRunCassandra.csv

printf "\n##################################################################################\n" >> ../cassandra/outputLoadCassandra.csv
printf "Loading workoad B try $i\n" >> ../cassandra/outputLoadCassandra.csv
./bin/ycsb load cassandra-cql -s -P workloads/workloadb \
-p "hosts=192.168.5.2,192.168.5.3,192.168.5.4,192.168.5.5" \
-p "cassandra.password=cassandra" \
-p "cassandra.username=cassandra" >> ../cassandra/outputLoadCassandra.csv

printf "\n##################################################################################\n" >> ../cassandra/outputRunCassandra.csv
printf "Running tests workoad B try $i\n" >> ../cassandra/outputRunCassandra.csv
./bin/ycsb run cassandra-cql -s -P workloads/workloadb \
-p "hosts=192.168.5.2,192.168.5.3,192.168.5.4,192.168.5.5" \
-p "cassandra.password=cassandra" \
-p "cassandra.username=cassandra" >> ../cassandra/outputRunCassandra.csv

printf "\n##################################################################################\n" >> ../cassandra/outputLoadCassandra.csv
printf "Loading workoad C try $i\n" >> ../cassandra/outputLoadCassandra.csv
./bin/ycsb load cassandra-cql -s -P workloads/workloadc \
-p "hosts=192.168.5.2,192.168.5.3,192.168.5.4,192.168.5.5" \
-p "cassandra.password=cassandra" \
-p "cassandra.username=cassandra" >> ../cassandra/outputLoadCassandra.csv

printf "\n##################################################################################\n" >> ../cassandra/outputRunCassandra.csv
printf "Running tests workoad C try $i\n" >> ../cassandra/outputRunCassandra.csv
./bin/ycsb run cassandra-cql -s -P workloads/workloadc \
-p "hosts=192.168.5.2,192.168.5.3,192.168.5.4,192.168.5.5" \
-p "cassandra.password=cassandra" \
-p "cassandra.username=cassandra" >> ../cassandra/outputRunCassandra.csv

printf "\n##################################################################################\n" >> ../cassandra/outputLoadCassandra.csv
printf "Loading workoad D try $i\n" >> ../cassandra/outputLoadCassandra.csv
./bin/ycsb load cassandra-cql -s -P workloads/workloadd \
-p "hosts=192.168.5.2,192.168.5.3,192.168.5.4,192.168.5.5" \
-p "cassandra.password=cassandra" \
-p "cassandra.username=cassandra" >> ../cassandra/outputLoadCassandra.csv

printf "\n##################################################################################\n" >> ../cassandra/outputRunCassandra.csv
printf "Running tests workoad D try $i\n" >> ../cassandra/outputRunCassandra.csv
./bin/ycsb run cassandra-cql -s -P workloads/workloadd \
-p "hosts=192.168.5.2,192.168.5.3,192.168.5.4,192.168.5.5" \
-p "cassandra.password=cassandra" \
-p "cassandra.username=cassandra" >> ../cassandra/outputRunCassandra.csv

printf "\n##################################################################################\n" >> ../cassandra/outputLoadCassandra.csv
printf "Loading workoad E try $i\n" >> ../cassandra/outputLoadCassandra.csv
./bin/ycsb load cassandra-cql -s -P workloads/workloade \
-p "hosts=192.168.5.2,192.168.5.3,192.168.5.4,192.168.5.5" \
-p "cassandra.password=cassandra" \
-p "cassandra.username=cassandra" >> ../cassandra/outputLoadCassandra.csv

printf "\n##################################################################################\n" >> ../cassandra/outputRunCassandra.csv
printf "Running tests workoad E try $i\n" >> ../cassandra/outputRunCassandra.csv
./bin/ycsb run cassandra-cql -s -P workloads/workloade \
-p "hosts=192.168.5.2,192.168.5.3,192.168.5.4,192.168.5.5" \
-p "cassandra.password=cassandra" \
-p "cassandra.username=cassandra" >> ../cassandra/outputRunCassandra.csv

printf "\n##################################################################################\n" >> ../cassandra/outputLoadCassandra.csv
printf "Loading workoad F try $i\n" >> ../cassandra/outputLoadCassandra.csv
./bin/ycsb load cassandra-cql -s -P workloads/workloadf \
-p "hosts=192.168.5.2,192.168.5.3,192.168.5.4,192.168.5.5" \
-p "cassandra.password=cassandra" \
-p "cassandra.username=cassandra" >> ../cassandra/outputLoadCassandra.csv

printf "\n##################################################################################\n" >> ../cassandra/outputRunCassandra.csv
printf "Running tests workoad F try $i\n" >> ../cassandra/outputRunCassandra.csv
./bin/ycsb run cassandra-cql -s -P workloads/workloadf \
-p "hosts=192.168.5.2,192.168.5.3,192.168.5.4,192.168.5.5" \
-p "cassandra.password=cassandra" \
-p "cassandra.username=cassandra" >> ../cassandra/outputRunCassandra.csv
done


cd ..

docker-compose -f cassandra/docker-compose.yml down -v
printf "\nFinished benchmarking Cassandra DB \n\n"

## Cleaning up everything
deactivate
rm -rf YCSB
rm -rf venv