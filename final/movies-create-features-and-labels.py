## THIS DEPENDS ON clean-movies.py

important_features = features_to_normalize + ['id']

movies_with_important_features = movies[important_features]
y = movies.samuel
x = pd.merge(left=movies_with_important_features, right=actor_vector_works, left_on='id', right_on='id')
### Merge in Genres
x = pd.merge(left=x, right=genre_vector, left_on='id', right_on='id')
### Remove id as a feature
x = x[x.columns.difference(['id'])]
