.DEFAULT_GOAL = help

.PHONY: help
help: ## Show this.
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-24s\033[0m %s\n", $$1, $$2}'

.PHONY: sh
sh: start ## Get a terminal with Bash.
	sudo docker compose -f ./docker-compose-workers.yml exec slackbot bash

.PHONY: start_langfuse
start_langfuse: ## spin up the container
	sudo docker compose -f ./docker-compose-langfuse.yml up -d

.PHONY: start_qdrant
start_qdrant: ## spin up the container
	sudo docker compose -f ./docker-compose-qdrant.yml up -d

.PHONY: start_workers
start_workers: ## spin up the container
	sudo docker compose -f ./docker-compose-workers.yml up -d

.PHONY: down_langfuse
down_langfuse: ## spin up the container
	sudo docker compose -f ./docker-compose-langfuse.yml down

.PHONY: down_qdrant
down_qdrant: ## spin up the container
	sudo docker compose -f ./docker-compose-qdrant.yml down

.PHONY: down_workers
down_workers: ## spin up the container
	sudo docker compose -f ./docker-compose-workers.yml down

.PHONY: logs_langfuse
logs_langfuse: ## spin up the container
	sudo docker compose -f ./docker-compose-langfuse.yml logs -f

.PHONY: logs_qdrant
logs_qdrant: ## spin up the container
	sudo docker compose -f ./docker-compose-qdrant.yml logs -f

.PHONY: logs_workers
logs_workers: ## spin up the container
	sudo docker compose -f ./docker-compose-workers.yml logs -f

.PHONY: start
.SILENT: start
start: # starts all containers
	make start_langfuse
	sleep 10
	make start_qdrant
	sleep 10
	make start_workers

.PHONY: down
.SILENT: down
stop: down_langfuse down_qdrant down_workers # shuts everything down

.PHONY: logs
.SILENT: logs
logs: # Gets logs from cluster
	read -p "Which cluster?\\n1: langfuse\n2: qdrant\n3: workers: " cluster; \
		[[ "$cluster" == "1" ]] && make logs_langfuse || ([[ "$cluster" == "2" ]] && make logs_qdrant || make logs_workers)