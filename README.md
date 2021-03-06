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

Install the [Python library `histonets`](https://github.com/sul-cidr/histonets-cv). Developers may want to install this into a [virtualenv](http://docs.python-guide.org/en/latest/dev/virtualenvs/). For now it's only available from its repository. It also needs a Python version 3.4 or higher.

```sh
$ pip3 install https://github.com/sul-cidr/histonets-cv/archive/master.zip
```

The application also uses redis for background job queueing. Make sure to have redis installed as background jobs get scheduled automatically.

```sh
$ brew install redis
```

## Setup

Histonets uses two commands to seed the application with collections of images. Make sure that all images are contained with directories within the `data/` directory. Each subdirectory within `data` should be flat, i.e., should contain no further subdirectories of images.

`bundle exec rails db:seed` will iterate over `data`, creating a new collection in the application for each subdirectory. It will also iterate over the images in each subdirectory, creating an image model for each and associating it with the proper collection.

`bundle exec rake histogram` will iterate over all collections in the application, calculating the composite histogram and palette of each. Before running this command, make sure all of the images from the subdirectories in `data` have been copied over to `spec/fixtures/images` where the image server points. Due to the restrictions of the image server, all images should exist at the same level within `spec/fixtures/images`.  

## Running the application

Run the application
```sh
$ rails s
```

Run the redis server
```sh
$ redis-server
```

Run the sidekiq job processor
```sh
$ bundle exec sidekiq
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

## Updating the deployed CLI

```sh
$ bundle exec cap dev python:update_cli
```
