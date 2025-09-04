#!/usr/bin/env bash

## COLORS
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

IMAGE_NAME="searxng"

if [[ $UID -ne 0 ]]; then
   echo "Run as root!"
   exit
fi

## FRESCURA
echo "Searxng installer - by github.com/joaostack"
echo

## Check if docker is installed
[[ $(type -P docker) ]] || { echo "[!] Please, install docker!" ; exit 155 ; }

## Check if container exists and install it
if docker inspect "$IMAGE_NAME" &>/dev/null; then
	echo -e "${GREEN}[+] Searxng container is installed!${NC}"
	echo -e "${YELLOW}[*] Starting container...${NC}"
	if ! docker ps --filter "name=$IMAGE_NAME" &>/dev/null; then
		echo -e "${RED}[!] Docker is already running!${NC}"
		exit 0;
	else
		docker start searxng
	fi
else
	echo -e "${RED}[!] Searxng container isn't installed! Creating...${NC}"
	docker create --name $IMAGE_NAME \
		-p 8888:8080 \
		-v "./config/:/etc/searxng/" \
		-v "./data/:/var/cache/searxng/" \
		searxng/searxng
	echo -e "${GREEN}[+] Container created! Start it with: docker start $IMAGE_NAME${NC}"
fi
