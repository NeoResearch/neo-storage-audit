#!/bin/bash
(cd ~/neo-tests/simple-rpc-node && ./merge_Storage.sh)
cp -r ~/neo-tests/simple-rpc-node/Storage/* ./

git add .
git commit -m "Persisting storage"
git push

