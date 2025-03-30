select vector('[0, 0]');
select vector('[0, 5]', 2, float32);

SELECT TO_NUMBER(
    VECTOR_DISTANCE(
        VECTOR('[0, 0, 5]'),
        VECTOR('[10, 0, 8]'),
        EUCLIDEAN
    )
) as DISTANCE;

SELECT TO_NUMBER(
    VECTOR_DISTANCE(
        VECTOR('[0, 0, 5]'),
        VECTOR('[10, 0, 8]'),
        MANHATTAN
    )
) as DISTANCE;

SELECT TO_NUMBER(
    VECTOR_DISTANCE(
        VECTOR('[0, 0, 5]'),
        VECTOR('[10, 0, 8]'),
        HAMMING
    )
) as DISTANCE;