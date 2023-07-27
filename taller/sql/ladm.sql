/***************************************************************************
              Cargue de información masiva al modelo LADM_COL LC 1.2
            ----------------------------------------------------------
        begin           : 2023-05-12
        git sha         : :%H$
        copyright       : (C) 2023 by Leo Cardona (CEICOL SAS)
        email           : contacto@ceicol.com
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License v3.0 as          *
 *   published by the Free Software Foundation.                            *
 *                                                                         *
 ***************************************************************************/

-- Establecer los esquemas de trabajo
SET search_path TO 
	ladm, -- schema levantamiento catastral 1.2
	public;

--================================================================================
-- Registramos los punto lindero
--================================================================================
INSERT INTO lc_puntolindero(
    t_ili_tid,
    id_punto_lindero,
    puntotipo,
    acuerdo,
    exactitud_horizontal,
    metodoproduccion,
    geometria,
    comienzo_vida_util_version,
    espacio_de_nombres,
    local_id)
SELECT
    uuid_generate_v4() as t_ili_tid,
    concat('punto ', id_punto) as id_punto_lindero,
    (select t_id from col_puntotipo where ilicode = punto_tipo) as puntotipo,
    (select t_id from lc_acuerdotipo where ilicode = acuerdo) as acuerdo,
    1 as exactitud_horizontal,
    (select t_id from col_metodoproducciontipo where ilicode = 'Metodo_Directo') as metodoproduccion,
    st_force3d(st_transform(st_setsrid(geom, 3116), 9377), 0) as geometria,
    now() as comienzo_vida_util_version,
    'LC_PUNTOLINDERO' as espacio_de_nombres,
    row_number() over() as local_id
FROM topo_puntolindero;

--================================================================================
-- Registramos los puntos levantamiento
--================================================================================
insert into lc_puntolevantamiento(
	t_ili_tid,
	id_punto_levantamiento,
	puntotipo,
	tipo_punto_levantamiento,
	exactitud_horizontal,
	metodoproduccion,
	geometria,
	comienzo_vida_util_version,
	espacio_de_nombres,
	local_id
)
select
	uuid_generate_v4() as t_ili_tid,
	concat('punto ', id) as id_punto_levantamiento,
	(select t_id from col_puntotipo where ilicode = 'Catastro.Construccion'),
	(select t_id from lc_puntolevtipo where ilicode = 'Construccion') as tipo_punto_levantamiento,
	1 as exactitud_horizontal,
	(select t_id from col_metodoproducciontipo where ilicode = 'Metodo_Directo') as metodoproduccion,
	st_force3d(st_transform(st_setsrid(geom, 3116), 9377), 0)  as geometria,
    now() as comienzo_vida_util_version,
    'LC_PUNTOLEVANTAMIENTO' as espacio_de_nombres,
    row_number() over() as local_id
FROM topo_puntolevantamiento;



--================================================================================
-- Registramos los linderos
--================================================================================
INSERT INTO lc_lindero(
    t_ili_tid,
    longitud,
    geometria,
    comienzo_vida_util_version,
    espacio_de_nombres,
    local_id
)
select 
    uuid_generate_v4() as t_ili_tid,
    st_length(st_transform(geom, 9377)) as longitud,
    st_force3d(st_transform(st_setsrid(geom, 3116), 9377), 0) as geometria,
    now() as comienzo_vida_util_version,
    'LC_LINDERO' as espacio_de_nombres,
    row_number() over() as local_id
from topo_lindero;

--================================================================================
-- Registramos los terrenos
--================================================================================
-- Usamos el algoritmo native:polygonize

INSERT INTO lc_terreno(
    t_ili_tid,
	area_terreno,
	geometria,
	comienzo_vida_util_version,
	espacio_de_nombres,
	local_id)
select
	uuid_generate_v4() as t_ili_tid,
	st_area(st_transform(geom, 9377)),
	st_multi(st_force3d(st_transform(geom, 9377), 0)) as geometria,
    now() as comienzo_vida_util_version,
    'LC_TERRENO' as espacio_de_nombres,
    row_number() over() as local_id
from poligonizada;

--================================================================================
-- Registramos las construcciones
--================================================================================
INSERT INTO lc_construccion(
	identificador,
	numero_pisos,
	area_construccion,
	geometria,
	comienzo_vida_util_version,
	espacio_de_nombres,
	local_id)
select 
	'A' as identificador,
	num_pisos as numero_pisos,
	st_area(st_transform(geom, 9377)) area_construccion,
	st_multi(st_force3d(st_transform(geom, 9377), 0)) as geometria,
    now() as comienzo_vida_util_version,
    'LC_CONSTRUCCION' as espacio_de_nombres,
    row_number() over() as local_id
from topo_construccion;

--==============================================================================================
-- La unidad de construcción y la características de construcción las creamos manualmente
--==============================================================================================  


--================================================================================
-- Registramos los predios
--================================================================================

INSERT INTO lc_predio(
    t_ili_tid,
    departamento,
    municipio,
    id_operacion,
    numero_predial,
    tiene_fmi,
    interrelacionado,
    codigo_homologado_fmi,
    tipo,
    condicion_predio,
    destinacion_economica,
    clase_suelo,
    comienzo_vida_util_version,
    espacio_de_nombres,
    local_id)    
select 
	uuid_generate_v4() as t_ili_tid,
    '25' as departamento,
    '175' as municipio,
    '1234' as id_operacion,
    '251750000000000000000500000002' as numero_predial,
    false as tiene_fmi,
    false as interrelacionado,
    false as codigo_homologado_fmi,
    (select t_id from col_unidadadministrativabasicatipo where ilicode = 'Predio.Privado') as tipo,
    (select t_id from lc_condicionprediotipo where ilicode = 'NPH') as condicion_predio,
    (select t_id from lc_destinacioneconomicatipo where ilicode = 'Habitacional') as destinacion_economica,
    (select t_id from lc_clasesuelotipo where ilicode = 'Urbano') as clase_suelo,
    now() as comienzo_vida_util_version,
    'LC_PREDIO' as espacio_de_nombres,
    row_number() over() as local_id;

--================================================================================
-- Relacionamos el predio y las unidades espaciales
--================================================================================
select t_id 
from lc_predio 
where numero_predial = '251750000000000000000500000002';

select t_id 
from lc_terreno 
where etiqueta = '251750000000000000000500000002';

select t_id 
from lc_construccion 
where etiqueta = '251750000000000000000500000002';

select t_id 
from lc_unidadconstruccion
where etiqueta = '251750000000000000000500000002';

-- Relación Terreno - Predio
INSERT INTO col_uebaunit(
    ue_lc_terreno,
    baunit
)
select 
	(select t_id from lc_terreno where etiqueta = '251750000000000000000500000002') as id_terreno, 
	(select t_id from lc_predio where numero_predial = '251750000000000000000500000002') id_predio;
	

-- Relación Construccion - Predio
INSERT INTO col_uebaunit(
    ue_lc_construccion,
    baunit
)
select 
	(select t_id from lc_construccion where etiqueta = '251750000000000000000500000002') as id_construccion, 
	(select t_id from lc_predio where numero_predial = '251750000000000000000500000002') id_predio;
	
-- Relación Unidad construccion - Predio
INSERT INTO col_uebaunit(
    ue_lc_unidadconstruccion,
    baunit
)
select 
	(select t_id from lc_unidadconstruccion where etiqueta = '251750000000000000000500000002') as id_uconstruccion, 
	(select t_id from lc_predio where numero_predial = '251750000000000000000500000002') id_predio;

--================================================================================
-- Dirección del predio
--================================================================================

INSERT INTO extdireccion(
    t_ili_tid,
    tipo_direccion,
    es_direccion_principal,
    complemento,
    lc_predio_direccion)
select
	uuid_generate_v4() as t_ili_tid,
	(select t_id from extdireccion_tipo_direccion where ilicode = 'No_Estructurada') as tipo_direccion,
    false as es_direccion_principal,
    'AV 3 # 22 d 1' as complemento,	
	t_id as lc_predio_direccion 
from lc_predio 
where numero_predial = '251750000000000000000500000002';

--================================================================================
-- Creamos los interesados
--================================================================================

INSERT INTO lc_interesado(
    t_ili_tid,
    tipo,
    tipo_documento,
    documento_identidad,
    primer_nombre,
    segundo_nombre,
    primer_apellido,
    segundo_apellido,
    sexo,
    grupo_etnico,
    estado_civil,
    comienzo_vida_util_version,
    espacio_de_nombres,
    local_id)
select
    uuid_generate_v4() as t_ili_tid,
    (select t_id from lc_interesadotipo where ilicode = 'Persona_Natural') as tipo,
    (select t_id from lc_interesadodocumentotipo where ilicode = 'Tarjeta_Identidad') as tipo_documento,
    '1042477540' as documento_identidad,
    'Camila' as primer_nombre,
    null as segundo_nombre,
    'Cardenas' as primer_apellido,
    null as segundo_apellido,
    (select t_id from lc_sexotipo where ilicode = 'Femenino') as sexo,
    (select t_id from lc_grupoetnicotipo where ilicode = 'Ninguno') as grupo_etnico,
    (select t_id from lc_estadociviltipo where ilicode = 'Soltero') as estado_civil,
    now() as comienzo_vida_util_version,
    'LC_INTERESADO' as espacio_de_nombres,
    row_number() over() as local_id;

--================================================================================
-- Creamos la fuente administrativa
--================================================================================
insert into lc_fuenteadministrativa(
	t_ili_tid,
	tipo,
	estado_disponibilidad,
	observacion,
	espacio_de_nombres,
	local_id
)
select
	uuid_generate_v4() as t_ili_tid,
	(select t_id from col_fuenteadministrativatipo where ilicode = 'Documento_Publico.Escritura_Publica')tipo,
	(select t_id from col_estadodisponibilidadtipo where ilicode = 'Disponible') as estado_disponibilidad,
	'Soporte Predio 251750000000000000000000000001' as observacion,
    'LC_ADMINISTRATIVA' as espacio_de_nombres,
    row_number() over() as local_id;
    
INSERT INTO extarchivo(
    t_ili_tid,
    datos,
    espacio_de_nombres,
    local_id,
    lc_fuenteadministrtiva_ext_archivo_id
)
select
	uuid_generate_v4() as t_ili_tid,
	'C:\Users\AI\Desktop\DATOS\SOPORTES\escritura_01.jpg' as datos,
    'EXTARCHIVO' as espacio_de_nombres,
    row_number() over() as local_id,
	t_id as id_fuenteadministrativa
from lc_fuenteadministrativa 
where observacion = 'Soporte Predio 251750000000000000000000000001'; 

--================================================================================
-- Creamos los derechos
--================================================================================
-- Predio
select t_id from lc_predio where numero_predial = '251750000000000000000500000001';

-- Interesado
select t_id from lc_interesado where primer_nombre = 'Carlos';

insert into lc_derecho (
    t_ili_tid,
    tipo,
    fraccion_derecho,
    unidad,
    interesado_lc_interesado,
    descripcion,
    comienzo_vida_util_version,
    espacio_de_nombres,
    local_id
)
select 
	uuid_generate_v4() as t_ili_tid,
	(select t_id from lc_derechotipo where ilicode = 'Dominio') as tipo,
    1 as fraccion_derecho,
    (select t_id from lc_predio where numero_predial = '251750000000000000000500000001') as unidad,
    (select t_id from lc_interesado where primer_nombre = 'Carlos') as interesado_lc_interesado,
    '251750000000000000000500000001' as descripcion,
    now() as comienzo_vida_util_version,
    'LC_DERECHO' as espacio_de_nombres,
    row_number() over() as local_id;

-- Asociamos el derecho con su fuente administrativa
select t_id from lc_derecho where descripcion = '251750000000000000000500000001';

select t_id from lc_fuenteadministrativa where  observacion = 'Soporte Predio 251750000000000000000000000001';

insert into col_rrrfuente(
	fuente_administrativa,
	rrr_lc_derecho)
select 
	(select t_id from lc_fuenteadministrativa where  observacion = 'Soporte Predio 251750000000000000000000000001') id_fuente,
	(select t_id from lc_derecho where descripcion = '251750000000000000000500000001') id_derecho;


-- Regla de calidad
INSERT INTO col_puntoccl
(punto_lc_puntolindero, ccl)
select
	lp.t_id id_punto,
	ll.t_id id_lindero
from lc_puntolindero lp 
left join lateral (
	select l.t_id, l.geometria 
	from lc_lindero l
--	where ST_Intersects(lp.geometria, l.geometria)
	where ST_Intersects(ST_Snap(lp.geometria, l.geometria, 0.0001), l.geometria)
) AS ll on true
where ll.t_id is not null and lp.t_id is not null;