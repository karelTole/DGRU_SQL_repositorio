
CREATE TABLE public.despensas 

(
id serial primary key,
producto varchar(30),
precio_x_kilo float4,
consumo_mensual_kilos float4,
gasto_mensual_aproximado float4,
lugar_compra varchar(100),
acaldia varchar(30), 
registrado_por varchar(20) DEFAULT "current_user"(),
fecha_registro timestamp(6) DEFAULT now()
);

CREATE TABLE public.busca_barato 
(
id serial primary key,
id_despensas int4,
producto varchar(30),
precio_x_kilo float4,
lugar varchar(100),
fecha_consulta timestamp(6)
);

CREATE TABLE public.audit_despensas (
id serial primary key,
product varchar(30),
precio_x_kilo_history float[],
alcaldia_history text[],
fecha_history timestamp[]
);

--Hacer un trigger que actualice el campo gasto_mensual_aproximado
--Hacer un trigger que inserte en la tabla busca_barato el valor mínimo de precio 
--
