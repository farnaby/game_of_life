#!/bin/bash

set -e

coffee --compile js
mkdir -p game_of_life_pkg/js
cp js/*.js game_of_life_pkg/js
cp ./index.html game_of_life_pkg
zip -r package.zip game_of_life_pkg
rm -rf game_of_life_pkg

