# DB-TP3-LOG8430E

# On docker-compose files
To run docker compose files with mprimary-secondary setup you can use the following template:
    docker-compose up --scale <PRIMARY_SERVICE>=1 --scale <SECONDARY_SERVICE>=3

To run in detach mode: doesn't show logs and returns terminal add: --detach flag to the command

To stop and remove containers:
    docker-compose down
