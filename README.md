# histonets
[![Build Status](https://travis-ci.org/sul-cidr/histonets.svg?branch=master)](https://travis-ci.org/sul-cidr/histonets) | [![codecov](https://codecov.io/gh/sul-cidr/histonets/branch/master/graph/badge.svg)](https://codecov.io/gh/sul-cidr/histonets)

Histonets is an application to convert images of scanned maps into digital networks.

## Installation

Install the Ruby dependencies
```sh
$ bundle install
```

Install node, npm, and yarn
```sh
# Installing Node and npm see: https://nodejs.org/en/download/ or
$ brew install node

# Installing yarn
$ npm install -g yarn
```

Histonets uses [riiif](https://github.com/curationexperts/riiif) for [IIIF image api](http://iiif.io/api/image/2.1/) support. This requires `imagemagick`. To install on OSX:

```sh
# With options for pdf, tiff, and jp2 respectively (not necessarily needed)
$ brew install imagemagick --with-ghostscript --with-tiff --with-jp2
```

## Running the application

Run the application
```sh
$ rails s
```

## Running the tests

Run the tests
```sh
$ bundle exec rake
```

Run the JavaScript linting
```sh
$ node_modules/.bin/eslint ./
```
