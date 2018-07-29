missing_movies=$(cat missing_movies.txt)
echo $missing_movies

for movie in $missing_movies
do
  if [ ! -f data/posters/$movie.jpg ]
  then
    echo data/posters/$movie.jpg does not exist
  fi
  # echo $movie
done