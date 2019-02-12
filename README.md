# neo-storage-audit
## Incremental storage of Neo Blockchain

This project intends to group all incremental changes made on Neo Blockchain Storage. 

## Folder organization (where to find the desired block?)
Data is organized in folder batches of 100k blocks, including files that group 1k blocks.
Example: folder `BlockStorage_100000` will include blocks from 1 to 100000.
Example 2: block 5300 will be located on file `dump-block-6000.json`, that includes blocks from 5001 to 6000.

As a general rule, `dump-block-X.json` includes blocks `X-1000+1` to `X` (inclusive), and folder `BlockStorage_Y` includes blocks `Y-100000+1` to `Y` (inclusive).

### Example json file
Example for `dump-block-0.json`. Line `0 0` means block zero has zero changes on storage. Next line will group all changes in json format, in this case, an empty array `[]`.

#### But all files are empty
In the beggining, no storage was used, so all arrays will be empty. Please take a look at folder `BlockStorage_1500000`, specially file `dump-block-1445000.json`, when heavy Storage action begins ;)

### Use cases
Using this raw data it's possible to easily reproduce past notifications in **any given block**. This is amazing!

This data can also be used to enforce newer standards regarding a storage hashing representation to make sure storage is correct in every network node.

### License
Data is freely available in MIT/Creative Commons.

NeoResearch 2018
