#!/bin/bash
set -eo pipefail

echo "Building with componentize..."
node componentize.mjs

echo "Transpiling with jco..."
jco transpile hello.component.wasm -o hello --map 'wasi-*=@bytecodealliance/preview2-shim/*'

echo "Setting up hello directory npm..."
cd hello
npm init -y

# Add type:module to package.json
npm pkg set type=module

cd ..

echo "Done! To test in Node.js, run:"
echo "node -e \"import('./hello/hello.component.js').then(m => console.log(m.hello('ComponentizeJS')))\""
