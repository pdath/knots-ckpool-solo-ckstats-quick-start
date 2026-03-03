# Quick start guide to solo mine Bitcoin on your own pool with ckpool on Windows in 2026

This is intended to be a quick start Docker Compose environment that deploys
Bitcoin Knots, ckpool (solo) and ckstats (a web gui) on Windows.  This can then be used by solo miners like a Bitaxe.

It should run on Linux and Mac, but it was specifically created for Windows users.  If you are on Linux or Mac, create a run.sh file (chmod +x) with the contents:
```
#!/usr/bin/env bash
=======

export COMPOSE_PROJECT_NAME="mainnet"
export DATA_PATH="./solo-mining-data"

docker compose --profile mainnet up -d
```

Simply install Docker, download the repository (you can download it as a zip file from the green "Code" button in the top right, then extract the zip file), and double click "run.bat".