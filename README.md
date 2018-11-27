# neo-storage-audit
## Incremental storage of Neo Blockchain

This project intends to group all incremental changes made on Neo Blockchain Storage. 
Data is organized in folder batches of 100k blocks, including files that group 1k blocks.

### Example file
Example for `dump-block-0.json`. Line `0 0` means block zero has zero changes on storage. Next line will group all changes in json format, in this case, an empty array `[]`.

#### But all files are empty
In the beggining, no storage was used, so all arrays will be empty. Please take a look at folder `BlockStorage_1500000`, specially file `dump-block-1445000.json`, when Storage action begins ;)

### Use cases
Using this raw data it's possible to easily reproduce past notifications in **any given block**. This is amazing!

This data can also be used to enforce newer standards regarding a storage hashing representation to make sure storage is correct in every network node.

### License
Data is freely available in MIT/Creative Commons.

NeoResearch 2018
