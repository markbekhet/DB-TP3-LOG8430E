#install Pre-requirements
sudo apt-get install git
sudo apt-get install python2
sudo apt-get install python3-virtualenv

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
./bin/ycsb load redis -s -P workloads/workloada -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true" > ../redis/outputLoad.txt
./bin/ycsb run redis -s -P workloads/workloada -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.clustert=true"> ../redis/outputRun.txt
cd ..
docker-compose -f redis/docker-compose.yml down -v
printf "\nFinished benchmarking redis DB \n\n"


##========================================================================##

## Run the container for Mongo DB and run the tests
printf "\nRunning Benchmarks on Mongo DB, results can be found in the Mongo folder \n\n"
docker-compose -f Mongo/docker-compose.yml up -d
cd Mongo
docker exec -it primary mongosh --eval "rs.initiate({
 _id: \"myReplicaSet\",
 members: [
   {_id: 0, host: \"192.168.5.2:27017\"},
   {_id: 1, host: \"192.168.5.3:27017\"},
   {_id: 2, host: \"192.168.5.4:27017\"},
   {_id: 3, host: \"192.168.5.5:27017\"}
 ]
})"

cd ../YCSB
./bin/ycsb load mongodb-async -s -P workloads/workloada -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../Mongo/outputLoadAsync.txt
./bin/ycsb run mongodb-async -s -P workloads/workloada -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../Mongo/outputRunAsync.txt

./bin/ycsb load mongodb -s -P workloads/workloada -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../Mongo/outputLoad.txt
./bin/ycsb run mongodb -s -P workloads/workloada -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../Mongo/outputRun.txt
cd ..
docker-compose -f Mongo/docker-compose.yml down -v
printf "\nFinished benchmarking Mongo DB \n\n"

##========================================================================##

#Run the container for Cassandra DB and run the tests
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

./bin/ycsb load cassandra-cql -s -P workloads/workloada \
-p "hosts=192.168.5.2,192.168.5.3,192.168.5.4,192.168.5.5" \
-p "cassandra.password=cassandra" \
-p "cassandra.username=cassandra" > ../cassandra/outputLoad.txt

./bin/ycsb run cassandra-cql -s -P workloads/workloada \
-p "hosts=192.168.5.2,192.168.5.3,192.168.5.4,192.168.5.5" \
-p "cassandra.password=cassandra" \
-p "cassandra.username=cassandra" > ../cassandra/outputRun.txt

cd ..

docker-compose -f cassandra/docker-compose.yml down -v
printf "\nFinished benchmarking Cassandra DB \n\n"

# Cleaning up everything
deactivate
rm -rf YCSB
rm -rf venv