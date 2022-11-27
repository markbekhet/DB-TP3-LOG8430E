## About the `script.sh`:
The `script.sh` can be used to benchmark redis, Mongo and Cassandra databases. For each database the script creates an environment of 4 nodes.

## Environment setup:
The ideal setup to use the script is:
- 8GB of RAM
- 2+ vCPUs
- Debian (preferably Ubuntu)

If not available, one can use an AWS instance of type t2.large or bigger. A machine with less capacity can hang due to the load. 

## How to use the benchmark:
Make sure to install `docker` and `docker-compose` on your machine and to add your user to the docker group. 

```shell
sudo apt install docker.io
sudo usermod -aG docker $USER
sudo apt install docker-compose
```
After adding the user, one will need to log out and log back-in or reboot the machine.

After installations, run the script with `./script.sh`
Do **NOT** run the script with sudo

## About the script:
- The script will start by installing the required dependencies like maven and java and then it creates a virtual environment with python2.
- For every database, six workloads will be run using the tool in: https://github.com/brianfrankcooper/YCSB.git
- The script writes the benchmarks in .txt files in the corresponding directories to the tested database.