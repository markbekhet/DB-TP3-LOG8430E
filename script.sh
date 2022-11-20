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

# Run the container for redis DB and run the tests
printf "\nRunning Benchmarks on redis DB, results can be found in the redis folder \n\n"
docker-compose -f redis/docker-compose.yml up --scale redis-master=1 --scale redis-replica=3 -d
cd YCSB
./bin/ycsb load redis -s -P workloads/workloada -p "redis.host=127.0.0.1" -p "redis.port=6379" > ../redis/outputLoad.txt
./bin/ycsb run redis -s -P workloads/workloada -p "redis.host=127.0.0.1" -p "redis.port=6379" > ../redis/outputRun.txt
cd ..
docker-compose -f redis/docker-compose.yml down
printf "\nFinished benchmarking redis DB \n"

# Cleaning up everything
deactivate
rm -rf YCSB
rm -rf venv