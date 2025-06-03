events = LOAD '/data/eventos_filtrados.csv'
    USING PigStorage(',')
    AS (evento_id:chararray, tipo:chararray, subtipo:chararray, calle:chararray, lat:chararray, lon:chararray,
        timestamp:chararray, fecha_evento:chararray, hora_evento:chararray, fuente:chararray, procesado:chararray);

-- 1. Conteo por tipo de evento
by_type = GROUP events BY tipo;
count_by_type = FOREACH by_type GENERATE group AS tipo, COUNT(events) AS cantidad;
STORE count_by_type INTO '/data/reporte_tipos.csv' USING PigStorage(',');

-- 2. Conteo por calles
by_calle = GROUP events BY calle;
count_by_calle = FOREACH by_calle GENERATE group AS calle, COUNT(events) AS cantidad;
STORE count_by_calle INTO '/data/reporte_calles.csv' USING PigStorage(',');

-- 3. Conteo por dia
by_fecha = GROUP events BY fecha_evento;
count_by_fecha = FOREACH by_fecha GENERATE group AS fecha, COUNT(events) AS cantidad;
STORE count_by_fecha INTO '/data/reporte_fechas.csv' USING PigStorage(',');
