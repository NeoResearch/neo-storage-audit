#!/bin/bash
(cd ~/neo-tests/simple-rpc-node && ./merge_Storage.sh)
cp -r ~/neo-tests/simple-rpc-node/Storage_mainnet/* ./

git add .
git commit -m "Persisting storage"
git push

