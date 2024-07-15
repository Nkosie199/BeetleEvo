--1. 
SELECT cr.record_id, cr.timestamp
FROM catalog_record cr
WHERE cr.catalog_id = 'saeon' ORDER BY cr.timestamp DESC;

--2. 
SELECT 
    r.id AS record_id,
    GREATEST(
        r.timestamp,
        s.timestamp,
        rt_max.timestamp, 
        ts_max.timestamp
    ) AS max_timestamp
FROM record r
JOIN schema s ON r.schema_id = s.id
LEFT JOIN (
    SELECT rt.record_id, MAX(rt.timestamp) AS timestamp
    FROM record_tag rt
    GROUP BY rt.record_id
) rt_max ON r.id = rt_max.record_id
LEFT JOIN (
    SELECT rt2.record_id, MAX(s.timestamp) AS timestamp
    FROM record_tag rt2
    JOIN tag t ON rt2.tag_id = t.id
    JOIN schema s ON t.schema_id = s.id
    GROUP BY rt2.record_id
) ts_max ON r.id = ts_max.record_id;

--3. 
WITH evaluated_records AS (
    SELECT cr.record_id, cr.timestamp AS last_evaluated_timestamp
    FROM catalog_record cr
    WHERE cr.catalog_id = 'saeon'
),
max_timestamps AS (
    SELECT r.id AS record_id,
        GREATEST(
            r.timestamp,
            s.timestamp,
            rt_max.timestamp, 
            ts_max.timestamp
        ) AS max_timestamp
    FROM record r
    JOIN schema s ON r.schema_id = s.id
    LEFT JOIN (
        SELECT record_id, MAX(timestamp) AS timestamp
        FROM record_tag rt
        GROUP BY record_id
    ) rt_max ON r.id = rt_max.record_id
    LEFT JOIN (
        SELECT rt2.record_id, MAX(s.timestamp) AS timestamp
        FROM record_tag rt2
        JOIN tag t ON rt2.tag_id = t.id
        JOIN schema s ON t.schema_id = s.id
        GROUP BY rt2.record_id
    ) ts_max ON r.id = ts_max.record_id
)
SELECT mt.record_id, mt.max_timestamp
FROM max_timestamps mt
LEFT JOIN evaluated_records er ON mt.record_id = er.record_id
WHERE er.record_id IS NULL 
OR mt.max_timestamp > er.last_evaluated_timestamp;

--4. 
SELECT rt.record_id, rt.tag_id,
    CASE
        WHEN rt.tag_id = 'qc' THEN rt.data->>'pass_'
        WHEN rt.tag_id = 'sdg' THEN rt.data->>'sdg'
        ELSE NULL
    END AS value
FROM record_tag rt;

--5. 
SELECT r.id AS record_id,
    MAX(CASE WHEN rt.tag_id = 'qc' THEN rt.data->>'pass_' ELSE NULL END) AS qc,
    MAX(CASE WHEN rt.tag_id = 'sdg' THEN rt.data->>'sdg' ELSE NULL END) AS sdg1,
    MAX(CASE WHEN rt.tag_id = 'sdg2' THEN rt.data->>'sdg2' ELSE NULL END) AS sdg2
FROM record r
LEFT JOIN record_tag rt ON r.id = rt.record_id
GROUP BY r.id;
