require('dotenv').config();
const fs = require('fs');
const assert = require('assert');
const request = require('request');
const throttledRequest = require('throttled-request')(request);

// we are limitted 40 requests every ten seconds
const LIMIT_RATE = 26;
const TEN_SECONDS = 10 * 1000;
throttledRequest.configure({
  requests: LIMIT_RATE,
  milliseconds: TEN_SECONDS,
});

let movieCount = 0;

const POSTER_WIDTH = 400;
const posterEndpoint = `http://image.tmdb.org/t/p/w${POSTER_WIDTH}/`;

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
      console.log(`Checking ${movieCount++} movie`);
      const { poster_path: posterPath } = JSON.parse(body);
      res(posterPath);
    });
  })
}

function checkIfPathIsJpg(posterPath) {
  if (posterPath.indexOf('jpg') == -1) {
    console.log (`${posterPath} is not a jpg`)
  }
}

function getPosterForMovieWithThrottle(movieId) {
  return retrievePosterPath(movieId)
  .then((posterPath) => {
    if (!posterPath) {
      console.log(`${movieId} has no poster path`);
      return;
    }
    checkIfPathIsJpg(posterPath);
    return new Promise((res) => {
      request(`${posterEndpoint}/${posterPath}`)
      .pipe(fs.createWriteStream(`data/posters/${movieId}.jpg`))
      .on('error', (e) => {
        console.log(`Error with "${movieId}" having path "${posterPath}": ${e.message}`);
      })
      .on('end', () => {
        res(posterPath);
      });
    });
  });
}

function main() {
  const movieIds = retrieveIdsFromCsv();
  assert.equal(movieIds.length, 4803);
  
  movieIds.forEach((movieId) => (
    getPosterForMovieWithThrottle(movieId)
  ));
}

main();
