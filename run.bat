@echo off
REM Define key environment variables
set COMPOSE_PROJECT_NAME=mainnet
set DATA_PATH=./solo-mining-data

docker compose --profile mainnet up -d
