events = LOAD '/data/eventos_filtrados_comuna.csv'
    USING PigStorage(',')
    AS (evento_id:chararray, tipo:chararray, subtipo:chararray, calle:chararray, lat:chararray, lon:chararray,
        timestamp:chararray, fecha_evento:chararray, hora_evento:chararray, fuente:chararray, procesado:chararray, comuna:chararray);

-- Conteo por comuna
by_comuna = GROUP events BY comuna;
count_by_comuna = FOREACH by_comuna GENERATE group AS comuna, COUNT(events) AS cantidad;
STORE count_by_comuna INTO '/data/reporte_comunas.csv' USING PigStorage(',');

-- Conteo por tipo de evento
by_tipo = GROUP events BY tipo;
count_by_tipo = FOREACH by_tipo GENERATE group AS tipo, COUNT(events) AS cantidad;
STORE count_by_tipo INTO '/data/reporte_tipos.csv' USING PigStorage(',');

-- Conteo por subtipo
by_subtipo = GROUP events BY subtipo;
count_by_subtipo = FOREACH by_subtipo GENERATE group AS subtipo, COUNT(events) AS cantidad;
STORE count_by_subtipo INTO '/data/reporte_subtipos.csv' USING PigStorage(',');

-- Conteo por calle
by_calle = GROUP events BY calle;
count_by_calle = FOREACH by_calle GENERATE group AS calle, COUNT(events) AS cantidad;
STORE count_by_calle INTO '/data/reporte_calles.csv' USING PigStorage(',');

-- Conteo por hora 
events_hora = FOREACH events GENERATE *, 
    (int)SUBSTRING(hora_evento, 0, 2) AS hora_num,
    CONCAT('[', SUBSTRING(hora_evento,0,2), ':00 - ', SUBSTRING(hora_evento,0,2), ':59]') AS hora_intervalo;

by_hora = GROUP events_hora BY hora_intervalo;
count_by_hora = FOREACH by_hora GENERATE group AS horario, COUNT(events_hora) AS cantidad;
STORE count_by_hora INTO '/data/reporte_horarios.csv' USING PigStorage(',');

-- Conteo por combinación tipo de evento, calle
by_tipo_calle = GROUP events BY (tipo, calle);
count_by_tipo_calle = FOREACH by_tipo_calle GENERATE 
    group.$0 AS tipo, group.$1 AS calle, COUNT(events) AS cantidad;
STORE count_by_tipo_calle INTO '/data/reporte_tipo_calle.csv' USING PigStorage(',');

-- Conteo por combinación tipo de evento, comuna
by_tipo_comuna = GROUP events BY (tipo, comuna);
count_by_tipo_comuna = FOREACH by_tipo_comuna GENERATE 
    group.$0 AS tipo, group.$1 AS comuna, COUNT(events) AS cantidad;
STORE count_by_tipo_comuna INTO '/data/reporte_tipo_comuna.csv' USING PigStorage(',');

-- Conteo por combinación calle, comuna
by_calle_comuna = GROUP events BY (calle, comuna);
count_by_calle_comuna = FOREACH by_calle_comuna GENERATE 
    group.$0 AS calle, group.$1 AS comuna, COUNT(events) AS cantidad;
STORE count_by_calle_comuna INTO '/data/reporte_calle_comuna.csv' USING PigStorage(',');

-- Conteo por combinación Tipo, Hora y calle
by_tipo_hora_calle = GROUP events_hora BY (tipo, hora_intervalo, calle);
count_by_tipo_hora_calle = FOREACH by_tipo_hora_calle GENERATE
    group.$0 AS tipo,
    group.$1 AS horario,
    group.$2 AS calle,
    COUNT(events_hora) AS cantidad;
STORE count_by_tipo_hora_calle INTO '/data/reporte_tipo_horario_calle.csv' USING PigStorage(',');
