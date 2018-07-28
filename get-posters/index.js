require('dotenv').config();
const fs = require('fs');
const assert = require('assert');
const request = require('request');
const throttledRequest = require('throttled-request')(request);

// we are limitted 40 requests every ten seconds
const LIMIT_RATE = 30;
const TEN_SECONDS = 10 * 1000;
throttledRequest.configure({
  requests: LIMIT_RATE,
  milliseconds: TEN_SECONDS,
});


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
  return new Promise((res, rej) => {
    const movieEndpoint = `${tmdbEndpoint}/${movieId}?api_key=${apiKey}`;
    return throttledRequest(movieEndpoint, (error, response, body) => {
      const { poster_path: posterPath } = JSON.parse(body);
      res(posterPath);
    });
  })
}

function getPosterForMovieWithThrottle(movieId) {
  return retrievePosterPath(movieId)
  .then((posterPath) => {
    console.log(posterPath);
    return posterPath;
  });
}

function main() {
  const movieIds = retrieveIdsFromCsv();
  assert.equal(movieIds.length, 4803);
  
  movieIds.slice(0, 42).forEach((movieId) => (
    getPosterForMovieWithThrottle(movieId)
    .then(() => console.log('all done'))
  ));
}

main();
