@echo off

SET SERVICE_NAME=pulpocon22-data-pipelines

IF /I "%1"=="deps" GOTO deps

IF /I "%1"=="help" GOTO help
IF /I "%1"=="start-dev" GOTO start-dev
IF /I "%1"=="stop-dev" GOTO stop-dev
IF /I "%1"=="shell" GOTO shell
IF /I "%1"=="test" GOTO test
IF /I "%1"=="clean" GOTO clean
IF /I "%1"=="clean-full" GOTO clean-full
GOTO error


:deps
	SET DOCKER_CMD=docker
	SET DOCKER_COMPOSE_CMD=docker-compose
	
	where /Q %DOCKER_CMD%
	IF NOT 0==%errorlevel% (
		echo Docker is not available. Please install docker
		EXIT /b 1
	)
		
	where /Q %DOCKER_COMPOSE_CMD%
	IF NOT 0==%errorlevel% (
		SET DOCKER_COMPOSE_CMD=%DOCKER_CMD% compose
	)
	GOTO :EOF

:enable-utf8
	chcp 65001
	GOTO :EOF
	
:print-banner
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
	echo:
	echo:
	echo Construyendo pipelines de datos a escala
	echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	echo:
	echo Contenedor con cliente dbt listo para ser utilizado durante el taller.
	echo Ejecuta 'exit' para salir y eliminar el contenedor en cualquier momento.
	echo:
	echo Proyecto dbt 'orders_analytics':
	echo - src: pipeline de transformación de datos
	echo - test: tests unitarios
	echo:
	echo:
	GOTO :EOF

:help
	echo -------------------------------------------------------------------------
	echo This Makefile has been created to ease the interaction with the "Building
	echo Data Pipelines at Scale" Pulpocon 2022 workshop
	echo -------------------------------------------------------------------------
	echo: 
	echo help            : show this help
	echo deps            : test if the dependencies we need to run this Makefile are installed
	echo start-dev       : start the full local dev environment
	echo stop-dev        : stop the full local dev environment
	echo shell           : starts a shell ready to interact with the dbt project
	echo test            : runs the full set of unit tests
	echo clean           : clean all the created containers
	echo clean-full      : clean all the created containers and their data
	GOTO :EOF

:start-dev
	CALL :deps
	%DOCKER_COMPOSE_CMD% --project-directory docker/dev up -d
	GOTO :EOF

:stop-dev
	CALL :deps
	%DOCKER_COMPOSE_CMD% --project-directory docker/dev down
	GOTO :EOF

:shell
	CALL :deps
	CALL :enable-utf8
	%DOCKER_CMD% network create dev_pulpocon2022-data-pipelines-net || echo: && SET DOCKER_BUILDKIT=1&& %DOCKER_CMD% build --target dev ^
	-t pulpocon2022/%SERVICE_NAME%:dev ^
	-f docker/Dockerfile .
	cls && CALL :print-banner
	%DOCKER_CMD% run --rm -it ^
	   --hostname dev-shell ^
	   --network=dev_pulpocon2022-data-pipelines-net ^
	   -p 8080:8080 ^
	   -v "%cd%/config/dbt":/opt/dbt/config ^
	   -v "%cd%/dbt/orders_analytics":/opt/pulpo22/orders_analytics ^
	   --env SNOWFLAKE_ACCOUNT ^
	   --env SNOWFLAKE_USER ^
	   --env SNOWFLAKE_PASSWORD ^
	   --env SNOWFLAKE_DATABASE ^
	   -w /opt/pulpo22/orders_analytics ^
	   --entrypoint /bin/bash pulpocon2022/%SERVICE_NAME%:dev
	GOTO :EOF

:test
	CALL :start-dev
	CALL :enable-utf8
	SET DOCKER_BUILDKIT=1&& %DOCKER_CMD% build --target test -t pulpocon2022/%SERVICE_NAME%:test -f docker/Dockerfile .
	%DOCKER_CMD% run --rm ^
		--network=dev_pulpocon2022-data-pipelines-net ^
		--env SNOWFLAKE_ACCOUNT ^
		--env SNOWFLAKE_USER ^
		--env SNOWFLAKE_PASSWORD ^
		--env SNOWFLAKE_DATABASE ^
		pulpocon2022/%SERVICE_NAME%:test ^
		/opt/pulpo22/scripts/run_dbt_test.sh --clean --target local
	GOTO :EOF

:clean
	CALL :deps
	%DOCKER_COMPOSE_CMD% --project-directory docker/dev down --rmi local
	GOTO :EOF

:clean-full
	CALL :deps
	%DOCKER_COMPOSE_CMD% --project-directory docker/dev down --rmi local -v
	GOTO :EOF

:error
    IF "%1"=="" (
        GOTO help
    ) ELSE (
        echo make: *** No rule to make target '%1%'. Stop.
    )
    GOTO :EOF
