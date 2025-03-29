# DML Operations on Vectors

Oracle Database 23ai has a new ```vector``` data type. The new data type was created in order to support vector search.

The ```vector``` data type definition includes:
- number of dimensions (optional)
- dimension format (optional)
    - BYNARY
    - INT8
    - FLOAT32
    - FLOAT64

Declaration formats:
- ```vector``` or ```vector(*, *)```
    - vectors can have arbitrary number of dimensions and formats
- ```vector(num_of_dims)``` or ```vector(num_of_dims, *)```
    - vectors must have the specified number of dimensions (or an error is thrown)
    - every vector will have its dimension stored without format modification
- ```vector(*, dim_format)```
    - vectors can have an arbitrary number of dimensions
    - every vector will be converted to the specified format

## Vector Data Type Example

```
CREATE TABLE IF NOT EXISTS t2 (
    id          NUMBER,
    embedding   VECTOR(768, INT8)
);
```
