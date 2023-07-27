# Curso teórico práctico introductorio al modelo de Levantamiento Catastral 1.2
Aprenda los fundamentos del modelo LADM-COL para Levantamiento Catastral versión 1.2 así como realizar su el cargue de información de forma puntual así como masiva contemplando la información alfanumérica como geográfica.

### **Nota**: Este curso es posible gracias al continuo apoyo del Proyecto SwissTierras Colombia

## Qué aprenderás

- ¿Cuáles son los fundamentos del modelo LADM-COL para Levantamiento Catastral?
- ¿Cómo realizar el cargue puntual de información alfanumérica y geográfica?
- ¿Cómo realizar el cargue masivo de información alfanumérica y geográfica?
- ¿Cómo generar un archivo XTF válido?

## Objetivo general

Brindar a los participantes las herramientas necesarias para realizar la migración masiva de información al modelo LADM-COL de forma eficiente usando herramientas open source.

## Objetivos específicos

- Comprender el flujo de trabajo del modelo LADM-COL para Levantamiento Catastral 1.2.
- Aprender a estructurar correctamente la información catastral bajo el estándar LADM-COL para Levantamiento Catastral 1.2.

## Destinatarios

Este curso está dirigido a todos aquellos interesados que tengan competencias en la gestión de datos territoriales. En general en este curso pueden asistir personal que desee tener conocimiento en el manejo de herramientas para la captura y gestión catastral. Se sugiere que los profesionales que atiendan este curso tengan conocimientos en:

- Manejo de bases de datos (PostgreSQL)
- Manejo de software GIS (QGIS)
- Manejo de información catastral

## Requerimientos de software

Los requerimientos de software que deben ser descargados por los asistentes para el desarrollo del taller son:

**Software base**:

- QGIS v3.28 LTR (https://qgis.org/es/site/forusers/download.html).
- Java v1.8 (https://www.oracle.com/co/java/technologies/javase/javase8-archive-downloads.html)
- PostgreSQL 9.5 o superior (funciona con PostgreSQL 10, 11 ó 12). (https://www.postgresql.org/download/)
- PostGIS 2.4 o superior

Adicionalmente se sugiere instalar:

- Visual Studio Code (https://code.visualstudio.com/Download)
- DBeaver (https://dbeaver.io/download/)

**Nota**: La versión del software a descargar depende del sistema operativo que estén utilizando.

## Contenido programático

- **Talleres**:
  - [Taller del Asistente LADM-COL](https://netorgft12112500-my.sharepoint.com/:p:/g/personal/contacto_ceicol_com/EZ_pziJ1yxdMiwLaJKeXd0YBbbC3YrFQ5mk5wBigrO1wEA?e=L8hrJj)
  - Cargue de información al modelo de Levantamiento Catastral 1.0 de forma puntual y masiva
    - Usando el Asistente LADM-COL
    - Usando el modelador gráfico de QGIS
    - Usando SQL
- **Tematicas**:
  - **Estruturación de datos**: 
      - ***Ejercicio 1***: ¿Cómo calcular los linderos y puntos linderos a partir de los polígonos de terrenos?
    - ***Ejercicio 4***:  ¿Cómo eliminar predios en cascada en la base de datos?
    - ***Ejercicio 5***: Recomendaciones para generar un archivo XTF valido
      - ¿Cómo importar multiples archivos XTF en una misma base de datos?
      - ¿Cómo exportar un archivo XTF valido?

  - **Reglas de calidad**:
      - ***Ejercicio 3***: Diseño e implementación de reglas de calidad temáticas y topológicas
      - ***Ejercicio 6***: Comparación de los predios registrados en la base de datos de Levantamiento Catastral y las novedades del número predial asociadas
      - ***Ejercicio 7***: ¿Cómo ejecutar las reglas de calidad asociadas a puntos directamente sobre el motor de base de datos PostgreSQL?
  
  - **Explotación de datos:**
    - ***Ejercicio 2***: ¿Cómo realizar consultas personalizadas del modelo de levantamiento catastral y visualizarlas en QGIS?

## Autores:

- Leo Cardona @lacardonap
- Sergio Ramírez @seralra96
- Camilo Rodriguez@camilo42715
- Juan Martinez @JuanMartinezM