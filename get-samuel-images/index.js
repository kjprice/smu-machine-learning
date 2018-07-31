const fs = require('fs');
const request = require('request');
const throttledRequest = require('throttled-request')(request);

const IMAGE_PATHS = {
  samuel: 'data/samuel-images-urls.txt',
  notSamuel: 'data/not-samuel-images-urls.txt',
};

const IMAGES_TO_SCRAPE = 'notSamuel';

const IMG_URLS_FILEPATH = IMAGE_PATHS[IMAGES_TO_SCRAPE];

const LIMIT_RATE = 26;
const TEN_SECONDS = 10 * 1000;
throttledRequest.configure({
  requests: LIMIT_RATE,
  milliseconds: TEN_SECONDS,
});

function getUrls() {
  return fs.readFileSync(IMG_URLS_FILEPATH, { encoding: 'utf8'})
  .split('\n');
}

function pipeImageToLocal(url, imageNumber) {
  return new Promise((res, rej) => {
    return throttledRequest(url)
    .on('error', (e) => console.log(e))
    .pipe(fs.createWriteStream(`data/images/${IMAGES_TO_SCRAPE}/${imageNumber}.jpg`))
    .on('error', (e) => {
      console.log(e);
      // rej(e);
    });
  });
}

function downloadImagesFromUrls(urls) {
  return Promise.all(urls.map(pipeImageToLocal))
}

function main() {
  const urls = getUrls();
  downloadImagesFromUrls(urls)
  .then(() => {console.log('all done')});
}

main();