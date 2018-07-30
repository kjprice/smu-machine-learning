const fs = require('fs');
const request = require('request');
const throttledRequest = require('throttled-request')(request);

const IMG_URLS_FILEPATH = 'data/samuel-images-urls.txt';

function getUrls() {
  return fs.readFileSync(IMG_URLS_FILEPATH, { encoding: 'utf8'})
  .split('\n');
}

function main() {
  const urls = getUrls();
}

main();