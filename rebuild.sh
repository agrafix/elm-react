#!/bin/bash

cd "$(dirname "$0")"

if [ ! -d node_modules/browserify ] || [ ! -d node_modules/react ]; then
    echo "Please run 'npm install' first."
    exit
fi

$(npm bin)/browserify src/wrapper.js -o src/Native/React.js