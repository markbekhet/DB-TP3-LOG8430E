About the script.sh:
The script.sh can be used to benchmark rdis, Mongo and Cassandra databases. For each database the script creates an environment of 4 nodes  

Environment SetUp:
The ideal setup to use the script is to have a machine with more than 8 GB of RAM and with 2+ vCPUs. If not available, one can use an AWS instance of type t2.large or bigger. A machine with less capacity can hang due to the load. The script assumes using a Debian distribution, preferably ubuntu. 

How to use the benchmark:
Make sure to install docker and docker compose on your machine and to add your user to the docker group. After adding the user, one will need to log out and log back-in or reboot the machine.
To install docker: sudo apt install docker.io
To add the user to docker group: sudo usermod -aG docker $USER
To install docker compose: sudo apt install docker-compose

After installation and to run the script use: ./script.sh
Don't run the script with sudo

About the script:
The script will start by installing the required dependencies like maven and java and then it creates a virtual environment with python2.
For every database, six workloads will be run using the tool in: https://github.com/brianfrankcooper/YCSB.git
The script writes the benchmarks in .txt files in the corresponding directories to the tested database.