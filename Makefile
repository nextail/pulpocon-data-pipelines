.PHONY = help deps shell start-dev stop-dev clean clean-all test
MAKEFLAGS += --warn-undefined-variables

# Dev environment parameters
SERVICE_NAME := pulpocon22-data-pipelines

# Shell to use for running scripts
SHELL := $(shell which bash)

# Export local user & group
UNAME := $(shell id -un)
UID := $(shell id -u)
GID := $(shell id -g)

# Get docker path or an empty string
DOCKER := $(shell command -v docker)
# Get docker-compose path
DOCKER_COMPOSE := $(shell command -v docker-compose)
ifeq (${DOCKER_COMPOSE}, )
	DOCKER_COMPOSE := ${DOCKER} compose
endif


# Setup msg colors
NOFORMAT := \033[0m
RED := \033[0;31m
GREEN := \033[0;32m
ORANGE := \033[0;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
YELLOW := \033[1;33m

# Shell banner
define SHELL_BANNER
echo    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣤⣶⣶⣶⣶⣤⣾⣿⣿⣄⠀⠀⠀⠀⠀
echo    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠀⠀
echo    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀
echo    ⢀⣀⣀⣀⣀⠀⠀⣀⣀⠀⠀⢀⣀⣀⢀⣀⣀⠀⠀⠀⢀⣀⣀⣀⣀⠀⠀⠀⠀⣀⣀⣀⠀⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
echo    ⣸⣿⡟⠛⣿⣿⠀⣿⣿⠀⠀⣸⣿⣿⢸⣿⣿⠀⠀⠀⢸⣿⣿⠛⢿⣿⡄⣴⣿⠟⠛⣻⣿⣿⠀⠀⠀⠀⠀⠀⠀⢀⣠⣿⣿⣿⣿⣿⣿⣿⡿⠛⠁⣀⣤⠀⠀⠀⣀⠀⠀⠙⢿⣿⣿⣿⣿⣿⡿⠁
echo    ⣸⣿⣷⣶⣿⡿⠀⣿⣿⠀⠀⣸⣿⣿⢸⣿⣿⠀⠀⠀⢸⣿⣿⣶⣿⣿⠁⣿⣿⣠⡾⠁⣿⣿⠇⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⣀⣴⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠈⠙⠛⠉⠁⠀⠀
echo    ⣸⣿⡇⠀⠀⠀⠀⠻⣿⣷⣶⣿⣿⠁⢸⣿⣿⣶⣶⣶⢈⣿⣿⠀⠀⠀⠀⣿⣿⣿⣶⣾⣿⠛⠀⠀⠀⠀⠀⠀⢈⣿⣿⣿⣿⣿⣿⠁⠀⢿⣿⣿⣿⠿⠛⠛⠛⠛⣿⣿⣿⣿⣿⠂⠀⠀⠀⠀⠀⠀
echo    ⠈⠈⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠈⠈⠈⠈⠈⠀⠈⠈⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⠁⠀⢠⣿⣿⠟⠀⠀⣤⠀⠀⠀⠀⠻⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀
echo    ⢀⣤⣶⣶⣤⢀⣤⣤⣤⣴⠀⣤⡀⠀⣤⡄⠀⠀⣠⣤⣶⣶⣶⣦⣄⠀⠀⣤⣴⣶⣶⣶⣦⣀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⠀⠸⣿⣿⣿⠀⠀⣿⣿⣷⣤⣴⠀⠀⣿⣿⣿⣿⡗⠀⠀⠀⠀⠀
echo    ⣿⣿⠀⠀⠀⣿⡏⣴⠋⣿⠄⣿⢿⣦⣿⠅⠀⠀⠙⠟⠉⠉⢻⣿⣿⠀⠀⠙⠛⠉⠉⣻⣿⣿⠀⠀⠀⠀⠀⢀⣽⣿⣿⣿⣿⣿⠀⠀⢙⣿⣿⠀⠀⠉⠻⢿⠿⠛⠀⠀⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀
echo    ⠀⠛⠿⠟⠛⠨⠟⠿⠟⠋⠸⠿⠀⠙⣿⠁⠀⠀⠀⣠⣴⣿⡿⠛⠁⠀⠀⠀⣤⣶⣿⡿⠛⠁⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣄⠀⠙⠛⣿⣿⣶⣤⣀⣀⠀⠀⠀⣾⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀
echo    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣶⣶⣶⣶⡀⢠⣿⣿⣿⣶⣶⣶⣶⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣦⠀⠀⠙⠛⠙⢿⠛⠛⢀⣤⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀
echo    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠉⠀⠈⠉⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣷⣦⣤⣤⣤⣶⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀
echo    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
echo    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⣿⡿⠛⠛⠛⠛⠛⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
echo
echo "Construyendo pipelines de datos a escala"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo
echo -e "Contenedor con ${BLUE}cliente dbt${NOFORMAT} listo para ser utilizado durante el taller."
echo -e "Ejecuta ${CYAN}'exit'${NOFORMAT} para salir y eliminar el contenedor en cualquier momento."
echo
echo "Proyecto dbt 'orders_analytics':"
echo -e " · ${BLUE}src${NOFORMAT}: pipeline de transformación de datos"
echo -e " · ${BLUE}test${NOFORMAT}: tests unitarios"
echo

echo
echo
endef

## 
## -------------------------------------------------------------------------
## This Makefile has been created to ease the interaction with the "Building 
## Data Pipelines at Scale" Pulpocon 2022 workshop
## -------------------------------------------------------------------------
## 

## help       	: show this help
help: 
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)


## deps		: test if the dependencies we need to run this Makefile are installed
deps:
ifndef DOCKER
	@echo -e "${RED}Docker is not available${NOFORMAT}. Please install docker"
	@exit 1
endif

## start-dev	: start the full local dev environment
start-dev: deps
	@${DOCKER_COMPOSE} --project-directory docker/dev up -d

## stop-dev	: stop the full local dev environment
stop-dev: deps
	@${DOCKER_COMPOSE} --project-directory docker/dev down

## shell		: starts a shell ready to interact with the dbt project
shell:
	@echo \
	&& ${DOCKER} network create dev_pulpocon2022-data-pipelines-net || true \
	&& DOCKER_BUILDKIT=1 ${DOCKER} build --target dev \
		--build-arg USER_NAME=${UNAME} \
		--build-arg USER_ID=${UID} \
		--build-arg GROUP_ID=${GID} \
		-t pulpocon2022/${SERVICE_NAME}:dev -f docker/Dockerfile . \
	&& clear \
	&& ${SHELL_BANNER} \
	&& ${DOCKER} run --rm -it \
		--user ${UID}:${GID} \
		--hostname dev-shell \
		--network=dev_pulpocon2022-data-pipelines-net \
		-p 8080:8080 \
		-v "${PWD}/config/dbt":/opt/dbt/config \
		-v "${PWD}/dbt/orders_analytics":/opt/pulpo22/orders_analytics \
		--env SNOWFLAKE_ACCOUNT \
    	--env SNOWFLAKE_USER \
		--env SNOWFLAKE_PASSWORD \
		--env SNOWFLAKE_DATABASE \
		-w /opt/pulpo22/orders_analytics \
		--entrypoint /bin/bash \
    	pulpocon2022/${SERVICE_NAME}:dev

## test		: runs the full set of unit tests
test: start-dev
	@echo \
	&& DOCKER_BUILDKIT=1 ${DOCKER} build --target test -t pulpocon2022/${SERVICE_NAME}:test -f docker/Dockerfile . \
	&& ${DOCKER} run --rm \
		--network=dev_pulpocon2022-data-pipelines-net \
		--env SNOWFLAKE_ACCOUNT \
    	--env SNOWFLAKE_USER \
		--env SNOWFLAKE_PASSWORD \
		--env SNOWFLAKE_DATABASE \
		pulpocon2022/${SERVICE_NAME}:test \
		/opt/pulpo22/scripts/run_dbt_test.sh --clean --target local

## clean	    	: clean all the created containers
clean: deps 
	@${DOCKER_COMPOSE} --project-directory docker/dev down --rmi local \
	&& dbt/scripts/clean_environment.sh

## clean-full 	: clean all the created containers and their data
clean-full: deps
	@${DOCKER_COMPOSE} --project-directory docker/dev down --rmi local -v \
	&& dbt/scripts/clean_environment.sh
## 
##
