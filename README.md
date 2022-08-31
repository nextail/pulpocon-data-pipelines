## Pulpocon22 Data Pipelines

Repositorio con el contenido del taller "Construyendo pipelines de datos a escala" impartido en la conferencia [Pulpocon 2022](https://pulpocon.es/#home).

### Descripción del taller

En el escenario actual, tanto tecnológico como económico, la toma de decisiones basadas en el análisis e interpretación de datos es una pieza fundamental para cualquier organización. No son pocos los retos que esto supone: desde la complejidad propia de la información o las grandes volumetrías que se suelen manejar, hasta la correcta gestión del ciclo de vida del dato, el control de su calidad o la construcción de pipelines robustas, observables y fácilmente escalables.

En los últimos años han aparecido una serie de soluciones que surgen de distintos proyectos open source y buscan dar respuesta a cada uno de estos problemas, lo que comúnmente se conoce como el modern data stack. Muchas de las arquitecturas construidas sobre esta base tecnológica utilizan dbt, una librería de gestión y transformación de datos basada en SQL, como una pieza central que permite la colaboración eficiente entre equipos de ingenieros y data scientists; además de acercar al contexto de los datos las buenas prácticas más comunes del mundo del desarrollo de software: observabilidad, testing o automatización.

En este taller discutiremos cómo **dbt** y un data warehouse de nueva generación como **Snowflake** nos permiten diseñar una solución para el análisis de datos que haga énfasis no solo en el rendimiento, sino también en aplicar una serie de estrategias recomendadas para alcanzar una gestión simple, escalable y sostenible de la información.


### Estructura del repositorio

- `doc`: contenidos teóricos y prácticos que iremos discutiendo a lo largo del taller.
- `dbt`: proyecto [dbt](https://www.getdbt.com/) que nos servirá como ejemplo práctico de todo lo discutido. No se requiere tener instalado el cliente dbt en el equipo.
- `config`: configuración de credenciales necesaria para la ejecución de los casos prácticos a lo largo del taller.
- `docker`: definición de contenedores auxiliares sobre los que desarrollaremos.
- `Makefile`: ditintas tareas para simplificar el uso del repositorio.

**NOTA:** El contenido de las carpetas `doc` y `dbt`, que ahora están vacías, será publicado el mismo día del taller.

### ¿Cuál es el formato del taller?
Taller meramente práctico, trabajaremos sobre un caso de uso real (aunque simplificado) construyendo modelos de datos que ejecutaremos contra Snowflake.

### ¿Qué requisitos son necesarios?
Lo único necesario será un PC con [docker](https://docs.docker.com/get-docker/) y un cliente de git instalado, además del editor de texto que prefieras.

### ¿Por dónde comienzo?
Puedes empezar por abrir un terminal en tu equipo, situarte en la carpeta en la que hayas clonado este repositorio y ejecutar un comando `make shell`. Eso te generará un contenedor docker con toda la configuración necesaria para seguir el taller y con ello habrás probado el correcto funcionamiento de todas las dependencias necesarias.


<!-- footer -->
<p>&nbsp;</p>
<p>&nbsp;</p>
<hr/>
<div style="font-size: 0.8em; letter-spacing: 0.1em;"> 
  <p align="right"><strong>Pulpocon · 2022</strong><br/>Construyendo pipelines de datos a escala</p>
  <p align="right"><code>rosa@nextail.co</code><br/><code>david.macia@nextail.co</code></p>
</div>