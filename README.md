## Pulpocon22 Data Pipelines

Repositorio con el contenido del taller "Construyendo pipelines de datos a escala" impartido en la conferencia [Pulpocon 2022](https://pulpocon.es/#home).


### Estructura del repositorio

- `doc`: contenidos teóricos y prácticos que iremos discutiendo a lo largo del taller.
- `dbt`: proyecto [dbt](https://www.getdbt.com/) que nos servirá como ejemplo práctico de todo lo discutido. No se requiere tener instalado el cliente dbt en el equipo.
- `config`: configuración de credenciales necesaria para la ejecución de los casos prácticos a lo largo del taller.
- `docker`: definición de contenedores auxiliares sobre los que desarrollaremos.
- `Makefile`: ditintas tareas para simplificar el uso del repositorio.


### ¿Cuál es el formato del taller?
Taller meramente práctico, trabajaremos sobre un caso de uso real (aunque simplificado) construyendo modelos de datos que ejecutaremos contra Snowflake.
### ¿Qué requisitos son necesarios?
Lo único necesario será un PC con [docker](https://docs.docker.com/get-docker/) y un cliente de git instalado, además del editor de texto que prefieras.

### ¿Por dónde comienzo?
La [sección principal de la documentación](doc/README.md) te servirá de introducción al taller y te irá llevando por las distintas secciones, tanto teóricas como prácticas.


<!-- footer -->
<p>&nbsp;</p>
<p>&nbsp;</p>
<hr/>
<div style="font-size: 0.8em; letter-spacing: 0.1em;"> 
  <p align="right"><strong>Pulpocon · 2022</strong><br/>Construyendo pipelines de datos a escala</p>
  <p align="right"><code>rosa@nextail.co</code><br/><code>david.macia@nextail.co</code></p>
</div>