# Diseño e implementación de reglas de calidad temáticas y topológicas 

## Objetivo

Abordar las diferentes reglas de calidad que deben contemplarsen para validar los datos de levantamiento catastral y enseñar al estudiante como realizar su validación.

## Datos
	- datos/LADM_BERLIN_CAMPOHERMOSO_POMARROSO.zip
	- datos/validaciones_interlis.zip

## Ejercicio

Para poder asegurar la calidad de la información catastral recolectada conforme al modelo LADM-COL para Levantamiento Catastral, se requieren ejecutar diferentes reglas de calidad para asegurar la integridad de la información. En este ejercicio el estudiante explorará algunos los diferentes tipos de validaciones que deben tenerse en cuenta para asegurar la calidad de la información recopilada.

#### Tipos de validaciones

- **Estructura**: Las reglas de estructura tiene como propósito asegurar que los datos recopilados cumplan con la estructura del modelo utilizado. Una forma de validar las reglas de estructura es poder exportar la base de datos a un archivo XTF válido. 

  Poder generar un archivo XTF válido no quiere decir que el conjunto de datos es válido, es simplemente un indicativo que nos permite saber que el conjunto de datos es válido.

- **Temáticas:** Este conjunto de reglas tienen como propósito asegurar que los datos en campo cumplan con las reglas de negocio definidas, en este orden de ideas, cada gestor catastral puede llegar a solicitar reglas temáticas para asegurar que los datos recopilados en campo cumplan con su lógica de negocio.

- **Topológicas**: Este conjunto de reglas tienen como propósito asegurar que los datos geográficos tengan consistencia espacial.
