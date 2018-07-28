require('dotenv').config();
const fs = require('fs');
const assert = require('assert');
const request = require('superagent');

const apiKey = process.env.TMDB_API_KEY;
const tmdbEndpoint = 'https://api.themoviedb.org/3/movie';

function retrieveIdsFromCsv() {
  const movieIdsFullText = fs.readFileSync('data/movie_ids.csv', { encoding: 'utf8' });
  const movieIds = movieIdsFullText.split('\n');
  // last row is empty
  movieIds.pop()
  return movieIds;
}

function retrievePosterPath(movieId) {
  const movieEndpoint = `${tmdbEndpoint}/${movieId}`;
  console.log(movieEndpoint);
  return request
    .get(movieEndpoint)
    .query({ api_key: apiKey })
    .set('accept', 'json')
    .then((movieInfo) => {
      const { poster_path: posterPath } = movieInfo.body;
      return posterPath;
    });
}

function main() {
  const movieIds = retrieveIdsFromCsv();
  assert.equal(movieIds.length, 4803);
  
  return retrievePosterPath(movieIds.shift())
  .then((posterPath) => {
    console.log(posterPath);
  });
}

main();
