# ycsb-docker
Wrapper around [YCSB](https://github.com/brianfrankcooper/YCSB)

## Motivation
Docker image with pre-downloaded YCSB and set jdk.  

## Build
```shell
docker build -t ycsb-docker .
```

## Run
```shell
docker run --rm --network=<network> ycsb-docker:latest load redis -s -P workloads/workloada -p "redis.host=host" -p "redis.port=6379" > outputLoad.txt

# or using host network
docker run --rm --network=host ycsb-docker:latest load redis -s -P workloads/workloada -p "redis.host=localhost" -p "redis.port=6379" > outputLoad.txt
```

