require('dotenv').config();
const fs = require('fs');
const assert = require('assert');

const apiKey = process.env.TMDB_API_KEY;

function main() {
  const movieIdsFullText = fs.readFileSync('data/movie_ids.csv', { encoding: 'utf8' });
  const movieIds = movieIdsFullText.split('\n');
  // last row is empty
  movieIds.pop()
  assert.equal(movieIds.length, 4803);
}

main();
