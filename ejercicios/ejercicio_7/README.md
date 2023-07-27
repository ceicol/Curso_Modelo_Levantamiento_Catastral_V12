# ¿Cómo ejecutar consultas temáticas asociadas al modelo LADM-COL de levantamiento catastral sobre sobre el motor de base de datos PostgreSQL? 


## Objetivo

Enseñar al estudiante ejecutar diferentes consultas SQL que les permita validar temáticamente la información  registrada en el modelo LADM-COL para levantamiento catastral.

## Datos

XTF con las UIT (Unidad de intervención Territorial):
	- Beril
	- Campohermoso
	- Pomarroso

datos --> datos/LADM_BERLIN_CAMPOHERMOSO_POMARROSO.zip


## Ejercicio

**Llenar relación col_puntoccl**

Diligenciar la tabla de col_puntoccl usando una consulta SQL:

```sql
-- Llenado de la tabla puntoccl
INSERT INTO integracion.col_puntoccl
(t_ili_tid, punto_lc_puntolindero, ccl)
select
	uuid_generate_v4() as t_ili_tid,
	lp.t_id id_punto,
	ll.t_id id_lindero
from integracion.lc_puntolindero lp 
left join lateral (
	select l.t_id, l.geometria 
	from integracion.lc_lindero l
	where ST_Intersects(lp.geometria, l.geometria)
) AS ll on true
where ll.t_id is not null and lp.t_id is not null;
```

**Generar capa geográfica con los predios formales e informales**

- Consultas para identificar informales

```sql
-- Número predial con valor 2 en la posición 22
select * 
from consultas.lc_predio lp 
where substring(lp.numero_predial, 22, 1) = '2';

-- Tipo de derecho del predio sea 'Ocupacion' o 'Posesion'
select
	lp.numero_predial,
	(select dispname from consultas.lc_prediotipo where t_id = lp.tipo) tipo_predio,
	(select dispname from consultas.lc_derechotipo where t_id = ld.tipo) tipo_derecho,
	lt.geometria
into predios_informales
from consultas.lc_predio lp 
join consultas.lc_derecho ld on lp.t_id = ld.unidad 
join consultas.col_uebaunit cu on lp.t_id = cu.baunit 
join consultas.lc_terreno lt on lt.t_id = cu.ue_lc_terreno 
where ld.tipo in (
	select t_id 
	from consultas.lc_derechotipo ld 
	where ilicode in ('Ocupacion', 'Posesion')
) and substring(lp.numero_predial, 22, 1) = '2';
```

- Consultas para identificar formales

```sql
-- Predios formales
select
	lp.numero_predial,
	(select dispname from consultas.lc_prediotipo where t_id = lp.tipo) tipo_predio,
	(select dispname from consultas.lc_derechotipo where t_id = ld.tipo) tipo_derecho,
	lt.geometria
into predios_formales
from consultas.lc_predio lp 
join consultas.lc_derecho ld on lp.t_id = ld.unidad 
join consultas.col_uebaunit cu on lp.t_id = cu.baunit 
join consultas.lc_terreno lt on lt.t_id = cu.ue_lc_terreno 
where ld.tipo not in (
	select t_id 
	from consultas.lc_derechotipo ld 
	where ilicode in ('Ocupacion', 'Posesion')
) and substring(lp.numero_predial, 22, 1) not in ('2');
```



- Validaciones temáticas

Validamos que los predios no tengan más de un terreno asociado

```sql
-- Predios tengan cero o un terreno
select baunit, count(*) 
from consultas.col_uebaunit cu 
where cu.ue_lc_terreno is not null
group by baunit 
having count(*) > 1;
```

Validamos que todos predios tengan solo un derecho asociado

```sql
-- Predios tienen un derecho
select unidad, count(*)
from consultas.lc_derecho
group by unidad 
having count(*) > 1;
```

