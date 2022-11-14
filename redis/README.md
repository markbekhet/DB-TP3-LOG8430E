# On docker-compose files
To run docker compose file with primary-secondary setup you can use the following template:
    docker-compose up --scale redis-master=1 --scale redis-replica=3

To run in detach mode: doesn't show logs and returns terminal add: --detach flag to the command

To stop and remove containers:
    docker-compose down
