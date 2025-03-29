# Vector DDL

You can have tables with different vector formats:
- more than one column of ```vector``` data type
- vector columns with different formats

## Example 

```
CREATE TABLE IF NOT EXISTS t5 (
    v1  VECTOR(3, float32),
    v2  VECTOR(2, float64),
    v3  VECTOR(1, int8),
    v4  VECTOR(1, *),
    v5  VECTOR(*, float32),
    v6  VECTOR(*, *),
    v7  VECTOR
);

ALTER TABLE t5 ADD v8 VECTOR(2, float32);

INSERT INTO t5 VALUES (
    '[1.1, 2.2, 3.3]',
    '[1.1, 2.2]',
    '[7]',
    '[9]',
    '[1.1, 2.2, 3.3, 4.4, 5.5]',
    '[1.1, 2.2]',
    '[1.1, 2.2, 3.3, 4.4, 5.5, 6.6]',
    '[5.5, 6.6]'
);

COMMIT;
```