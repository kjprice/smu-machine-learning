import pandas as pd
import numpy as np
import sklearn as sk
import json

from sklearn.feature_extraction.text import CountVectorizer
from sklearn.preprocessing import normalize

# merge two datasets
movies = pd.merge(left=movies, right=credits, left_on='id', right_on='movie_id')

# turn json into python objects
json_columns = ['genres', 'keywords', 'production_countries', 'spoken_languages', 'cast', 'crew']
for column in json_columns:
  movies[column] = movies[column].apply(json.loads, encoding="utf-8")



######## Actors ########

# create functions that will help with extracting actor information
def actor_to_id_string(actor):
  return '{} - {}'.format(actor['name'], actor['id'])

def cast_to_actors(cast):
  actors = []
  for person in cast:
    actors.append(actor_to_id_string(person))
  return actors

# Create a new column (array) from cast
movies.actors = movies.cast.apply(cast_to_actors)

# Create a list of all actors
all_actors = []
for actors in movies.actors:
  for actor in actors:
    all_actors.append(actor)
actors = pd.Series(all_actors)
unique_actors_count = pd.crosstab(actors, columns='count')

# Create function to determine if actor has been in more than 3 films
actors_string_id_by_id = {}
actor_counts_by_string_id = {}
unique_actors_count_dict = unique_actors_count.to_dict()['count']

def actor_has_more_than_x_movies(actor, number_of_movies = 3):
    string_id = str(actor['id'])

    # First, get the unique id created for the actor
    actor_string_id = ''
    if string_id in actors_string_id_by_id:
        actor_string_id = actors_string_id_by_id[string_id]
    else:
        actor_string_id = actor_to_id_string(actor)
        actors_string_id_by_id[string_id] = actor_string_id
    
    # Now let's see how many movies this actor has played in
    actor_count = unique_actors_count_dict[actor_string_id]
    return actor_count > number_of_movies

# Create a list of all actors that have been in more than 3 movies
movies_actors_ids = []
for actors in movies.cast:
  movie_actors_ids = []
  for actor in actors:
    if (not actor_has_more_than_x_movies(actor, 3)):
      continue
    movie_actors_ids.append(str(actor['id']))
  movies_actors_ids.append(' '.join(movie_actors_ids))

# Vectorize the list of actors
def get_actor_feature_name(id):
  return actors_string_id_by_id[id] + ' (actor)'
vectorizer = CountVectorizer()
movie_vector = vectorizer.fit_transform(movies_actors_ids).toarray()

actor_feature_ids = vectorizer.get_feature_names()
actor_feature_names = []
for id in actor_feature_ids:
  actor_name = get_actor_feature_name(id)
  actor_feature_names.append(actor_name)

actor_vector_works = pd.DataFrame(movie_vector, columns=actor_feature_names)
actor_vector_works['id'] = movies.id

# Create the label for whether Samuel L Jackson was in the film (samuel)
movies['samuel'] = actor_vector_works[get_actor_feature_name('2231')] == 1





######## GENRES ########

def unique_genres(movies_genres):
  genre_map = {}
  for genres in movies_genres:
    for genre in genres:
      name = genre['name']
      if not name in genre_map:
        genre_map[name] = 0
      genre_map[name]+=1
  return pd.Series(genre_map).sort_values(ascending=False)

def get_genres_feature_name(genre):
  return genre['name'] + ' (genre)'

movies_genres_ids = []
movie_genres_names_by_id = {}
for genres in movies.genres:
  movie_genres_ids = []
  for genre in genres:
    genre_feature_name = get_genres_feature_name(genre)
    movie_genres_ids.append(str(genre['id']))
    movie_genres_names_by_id[str(genre['id'])] = genre_feature_name
  movies_genres_ids.append(' '.join(movie_genres_ids))

genre_vectorization = CountVectorizer()

movie_vector = genre_vectorization.fit_transform(movies_genres_ids).toarray()
genre_feature_ids = genre_vectorization.get_feature_names()

def get_feature_names_by_ids(ids):
  genre_feature_names = []

  for id in ids:
    genre_feature_names.append(movie_genres_names_by_id[id])
  return genre_feature_names

genre_feature_names = get_feature_names_by_ids(genre_feature_ids)

genre_vector = pd.DataFrame(movie_vector, columns=genre_feature_names)
genre_vector['id'] = movies.id

features_to_normalize = [
  'budget',
  'popularity',
  'vote_average',
  'vote_count',
  'revenue'
]

for feature in features_to_normalize:
  feature_array = movies[feature].values.astype('float64').reshape(1, -1)
  movies[feature + '_original'] =     movies[feature]
  movies[feature] = normalize(feature_array, axis=1, norm='max')[0]


