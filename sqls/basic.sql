DROP TABLE IF EXISTS t1;

CREATE TABLE IF NOT EXISTS t1 (v vector);

INSERT INTO t1 VALUES
    ('[1.1, 2.7, 3.141592653589793238]'),
    ('[9.34, 0.0, -6.923]'),
    ('[-2.01, 5, -25.8]'),
    ('[-8.2, -5, -1013.6]'),
    ('[7.3]'),
    ('[2.9]'),
    ('[1, 2, 3, 4, 5]');

COMMIT;

SELECT * FROM t1;