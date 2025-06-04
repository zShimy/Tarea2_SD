events = LOAD '/data/eventos_filtrados.csv'
    USING PigStorage(',')
    AS (evento_id:chararray, tipo:chararray, subtipo:chararray, calle:chararray, lat:chararray, lon:chararray,
        timestamp:chararray, fecha_evento:chararray, hora_evento:chararray, fuente:chararray, procesado:chararray);

-- Conteo por tipo de evento
by_type = GROUP events BY tipo;
count_by_type = FOREACH by_type GENERATE group AS tipo, COUNT(events) AS cantidad;
STORE count_by_type INTO '/data/reporte_tipos_process2.csv' USING PigStorage(',');

-- Conteo por subtipo
by_subtipo = GROUP events BY subtipo;
count_by_subtipo = FOREACH by_subtipo GENERATE group AS subtipo, COUNT(events) AS cantidad;
STORE count_by_subtipo INTO '/data/reporte_subtipos_process2.csv' USING PigStorage(',');

events_with_hour = FOREACH events GENERATE *, 
    (int)SUBSTRING(hora_evento, 0, 2) AS hour_group;

-- Agrupa por horario 
by_hour = GROUP events_with_hour BY hour_group;
count_by_hour = FOREACH by_hour GENERATE group AS hora, COUNT(events_with_hour) AS cantidad;
STORE count_by_hour INTO '/data/reporte_hora.csv' USING PigStorage(',');
