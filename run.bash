#!/bin/bash
set -eo pipefail

bash build.bash
node -e "import('./hello/hello.component.js').then(m => console.log(m.hello('ComponentizeJS')))"
