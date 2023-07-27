--Fijar esquema ladm
set schema 'ladm';

---Vertices duplicados en la capa terreno

update lc_terreno  
set geometria  =  public.ST_RemoveRepeatedPoints(geometria , 0.001)
where true =true;

--Agrupaciones de interesados con un único interesado o sin interesados asociado

--Identificacion de grupo de interesados con un solo interesado
select * from lc_agrupacioninteresados where t_id in 
	(
	select 
		agrupacion 
	from col_miembros cm  group by agrupacion
	having(count(agrupacion))=1
	);

--Borrado del registro vinculado a la agrupacion en la tabla miembros
delete from col_miembros where t_id  in 
	(
	select 
		cm2.t_id 
	from col_miembros cm2 
	where cm2.agrupacion in 
		(
		select 
			agrupacion 
		from col_miembros cm  group by agrupacion
		having(count(agrupacion))=1
		)
	);
	
--Borrado del registro en la agrupacion de interesados
delete from lc_agrupacioninteresados where t_id in	
	(
	select 
		la.t_id  
	from lc_agrupacioninteresados la 
	left join col_miembros cm  on la.t_id =cm.agrupacion 
	where cm.agrupacion  is null
	);


--Derechos sin fuentes administrativas asociadas

--Identificación de derechos que no estan vinculados con una fuenta administrativa
select 
	de.* 
from lc_derecho de 
left join col_rrrfuente cr 
on de.t_id = cr.rrr_lc_derecho 
where cr.rrr_lc_derecho is null; 
--Borrado de los derechos que no tienen fuentas administrativas asociadas
delete from lc_derecho 
where t_id in 
	(
	select 
		de.t_id  
	from lc_derecho de 
	left join col_rrrfuente cr 
	on de.t_id = cr.rrr_lc_derecho 
	where cr.rrr_lc_derecho is null
	);

--Un predio solo debe tener una asociación en la tabla de datos adicionales 
--Identificacion de predios que poseen mas de un registro
select 
	ld.lc_predio Predio,
	count(ld.lc_predio) Numero_datos
from lc_datosadicionaleslevantamientocatastral ld 
group by ld.lc_predio 
having count (ld.lc_predio) > 1;

--Borrado de los registros adicionales de de levantamiento catastral
delete  from lc_datosadicionaleslevantamientocatastral ld2 
where ld2.t_id in ( 
	select  ld.t_id from
		(
		select 
			ld.t_id,
			row_number() over (partition by ld.lc_predio) as numerofila
		from lc_datosadicionaleslevantamientocatastral ld ) as ld where ld.numerofila >1
		);


--Una  características de la unidad de construcción  no debe tener más de una calificación por tipologías asociadas
--Identificacion de la características de la unidad de construcción con mas de una calificación  por tipologías 
select 
	lt.lc_unidad_construccion caracteristica_unidad_construccion,
	count(lt.lc_unidad_construccion) numero_datos
from  lc_tipologiaconstruccion lt 
group by lt.lc_unidad_construccion
having count(lt.lc_unidad_construccion)>1;

--Borrado de los registros adicionales de calificación por tipologías asociadas
delete  from lc_tipologiaconstruccion lt2 
where lt2.t_id in(
	select lt.t_id
	from
	(
	select 
		lt.t_id,
	row_number() over (partition by lt.lc_unidad_construccion) as numerofila
	from lc_tipologiaconstruccion lt) as lt where lt.numerofila >1
	);

--Una características de la unidad de construcción  no debe tener más  de una calificacion no convencional asociada

--Identificacion de la características de la unidad de construcción con mas de una calificación no convencional 
select 
	cnc.lc_unidad_construccion  caracteristica_unidad_construccion,
	count(cnc.lc_unidad_construccion) numero_datos
from  lc_calificacionnoconvencional cnc
group by cnc.lc_unidad_construccion 
having count(cnc.lc_unidad_construccion)>1;
--Borrado de los registros adicionales de calificación no convencional
delete  from lc_calificacionnoconvencional  cnc2
where cnc2.t_id in(
	select cnc.t_id
	from
	(
	select 
		cnc.t_id,
	row_number() over (partition by cnc.lc_unidad_construccion) as numerofila
	from lc_calificacionnoconvencional  cnc) as cnc where cnc.numerofila >1
	);

--Una características de la unidad de construcción no puede tener dos calificaciones de forma simultanea
--Unidad de construccion con mas de una calificacion
select  cu.* from lc_caracteristicasunidadconstruccion  cu
join lc_tipologiaconstruccion lt  on cu.t_id =  lt.lc_unidad_construccion 
join lc_calificacionnoconvencional cnc on cu.t_id = cnc.lc_unidad_construccion;

--Borrado de califacion no convencional 
delete from lc_calificacionnoconvencional lc2 
where lc2.lc_unidad_construccion  in
	(
	select  cu.t_id
	from lc_caracteristicasunidadconstruccion  cu
	join lc_tipologiaconstruccion lt  on cu.t_id =  lt.lc_unidad_construccion 
	join lc_calificacionnoconvencional cnc on cu.t_id = cnc.lc_unidad_construccion
	);

--No se deben tener col_miembros no debe tener un registro duplicado asociado al mismo interesado 
--y agrupación de interesados

--Identificacion de los miembros con doble registro, tanto de interesado como agrupacion
select * from col_miembros cm 
where agrupacion in ( 
	select agrupacion
	from col_miembros 
	group by interesado_lc_interesado, agrupacion 
	having count(*)>1) 
and interesado_lc_interesado in ( 
	select interesado_lc_interesado
	from col_miembros 
	group by interesado_lc_interesado, agrupacion 
	having count(*)>1 );


--Depuracion de uno de los registros en la tabla fraccion
	
--Borrado de la tabla miembros
delete from col_miembros cm2 where cm2.t_id in (
	select 
		t_id
	from 
	(
		select 
			t_id, 
			row_number () over (partition by agrupacion) 
			fila from col_miembros cm 
			where agrupacion in ( 
				select agrupacion
				from col_miembros 
				group by interesado_lc_interesado, agrupacion 
				having count(*)>1) 
			and interesado_lc_interesado in ( 
				select interesado_lc_interesado
				from col_miembros 
				group by interesado_lc_interesado, agrupacion 
				having count(*)>1 )
	) as 
		mi where mi.fila > 1) ;
	
--No se deben tener col_miembros un registro sin asociar a un interesado.
	
--Identificación de los registros que no tienen asociado un interesado
select * from  col_miembros cm 
where cm.interesado_lc_interesado  is null;
--Borrado de los registros

delete from col_miembros cm 
where cm.interesado_lc_interesado  is null;



--El fin de vida útil del terreno debe ser null
--Terrenos con fecha de finalizacion diferente de null
select * from lc_terreno lt 
where lt.fin_vida_util_version is not null;
--Actualizacion del valor a NULL 
update lc_terreno  lt 
set fin_vida_util_version = null 
where lt.fin_vida_util_version  is not null;

--El campo id_operacion de la tabla predio debe ser único
--Identificación de los predios con id_operacion repetido.
select * from lc_predio lp where lp.id_operacion in
	(
	select 
		lp.id_operacion  
	from lc_predio lp 
	group by lp.id_operacion 
	having count(lp.id_operacion)>1
	);
--Actializacion del id_operación
update lc_predio lp2
set id_operacion = round(10000000*random()) where lp2.t_id in
	(select 
		t_id 
	from 
		(select 
			t_id,
			row_number() over (partition by id_operacion) as numero_fila
		from  lc_predio ) 
	as lp where numero_fila >1);