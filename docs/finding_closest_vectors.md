# Finding the Closest Vectors

The **similarity search** allows you to calculate the query vector distance to all other vectors.  What is important is the **result set of your top closest vectors** not the distance between them. This comparison is done using a particular distance metric (e.g. Euclidean).

## Exact Similarity Search

- Also called *Flat Search* or *Exact Search*
- Most accurate results
- Perfect search quality
- Potentially significant search times

*In this example here, we have a vector query and we're trying to locate the three nearest neighbors. After calculating all of the distances of all of the vectors, the search returns the nearest k of those as the nearest match. This is called the **k nearest-neighbors search**.*

![Exact Similarity Search](../imgs/exact_similarity_search.png)

### Euclidean Similarity Search

In this example, ```docID``` and ```embedding``` are columns that are defined in the ```vector_tab``` table. The embedding column has the data type of vector.

```
SELECT docID
FROM vector_tab
ORDER BY VECTOR_DISTANCE(embedding, :query_vector, EUCLIDEAN)
FETCH EXACT FIRST 10 ROWS ONLY;
```

### Euclidean Squared Similarity Search

In the case of Euclidean distances, comparing squared distances is equivalent to comparing distances. So when ordering is more important than the distance values themselves, the Euclidean squared distance is very useful, as it is faster to calculate than the Euclidean distance, avoiding the square-root calculation.

```
SELECT docID
FROM vector_tab
ORDER BY VECTOR_DISTANCE(embedding, :query_vector)
FETCH FIRST 10 ROWS ONLY;
```