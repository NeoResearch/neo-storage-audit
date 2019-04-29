# neo-storage-audit
## Incremental storage of Neo Blockchain

This project intends to group all incremental changes made on Neo Blockchain Storage. 

## Folder organization (where to find the desired block?)
Data is organized in folder batches of 100k blocks, including files that group 1k blocks.
Example: folder `BlockStorage_100000` will include blocks from 1 to 100000.
Example 2: block 5300 will be located on file `dump-block-6000.json`, that includes blocks from 5001 to 6000.

As a general rule, `dump-block-X.json` includes blocks `X-1000+1` to `X` (inclusive), and folder `BlockStorage_Y` includes blocks `Y-100000+1` to `Y` (inclusive). `BlockStorage_0` and `dump-block-0.json` only contains block zero.

## Dump file organization
Each storage dump file is a valid json list, containing several block structs. Each block struct contains three fields: `block` (which is block height), `size` (number of storage actions recorded in that block), and `storage` (which is the list of actions that happened in that block). 

If `storage` field is an empty list, then `size` field will be zero, as in the next example (`dump-block-0.json`):
```json
[
   {"block":0, "size":0, "storage": []}
]
```

#### But all files are empty
In the beggining, no storage was used, so all arrays will be empty. Please take a look at folder `BlockStorage_1500000`, specially file `dump-block-1445000.json` (block 1444843), when Storage action begins ;)

#### Storage actions: Added/Changed/Deleted
Block actions can be one of the three: `Added` (when a new key/value is created), `Changed` (when a value is changed for a given existing key) or `Deleted` (when a key is removed together with its value).
The hex format of key and value follows Neo standard for serialization of StorageKey and StorageItem (don't worry, we will explain these here in details ;) ).

### Serialization format for storage keys and values
Remember Neo `HelloWorld` example? It writes value `World` on key `Hello`.

```cs
using Neo.SmartContract.Framework.Services.Neo;
namespace Neo.SmartContract {
    public class HelloWorld : Framework.SmartContract {
        public static void Main() {
            Storage.Put("Hello", "World");
        }
    }
}
```
This one currently has the following scripthash `d741527ea66813c0c50e78bb403926b4c88a64c4` (in little-endian format).

When executing this contract, the following action will happen:
```json
{"state":"Added","key":"d741527ea66813c0c50e78bb403926b4c88a64c448656c6c6f00000000000000000000000b","value":"0005576f726c6400"}
```

StorageKey is `d741527ea66813c0c50e78bb403926b4c88a64c448656c6c6f00000000000000000000000b`, that can be decomposed in two parts: scripthash (contract prefix `d741527ea66813c0c50e78bb403926b4c88a64c4`) and key `48656c6c6f00000000000000000000000b` (with 16-bytes padding).
The key is written via helper WriteBytesWithGrouping, that writes information in blocks of 16-bytes, separated by a single zero byte, and finally padded with enough zeroes to match 16 size. The padding size is the last byte, in this case `0x0b` so 11 zeroes were added and real key is only `48656c6c6f` (meaning `Hello` on ASCII).

StorageItem is `0005576f726c6400` and consists of three parts: StateBase prefix (currently `0x00`), the desired `value` (which is `05576f726c64`) and the storage attribute (usually `0x00` meaning that data is not constant). 
The `value` part is written via WriteVarBytes, which includes a prefix for the byte array size (via WriteVarInt) and content (via WriteVarBytes). So, `0x05` indicates that the following 5 bytes will be stored: `576f726c64` (which is `World` on ASCII). 

If invocation is repeated on the same contract, the state action will be recorded as `Changed` (not `Added`). 
Finally, if a key is deleted, storage action will be recorded as `Deleted`, and no `value` will be presented, only the `key`.

#### General serialization format
Just for short, these are the serialization rules to remember easily:

For `key` is:  `<ScriptHash 20-bytes> + <key 16-byte multiple zero padded>`

For `value` is `<StateBase 0x00> + <data size> + <data contents> + <storage attribute 1-byte (usually 0x00)>`

### Use cases
Using this raw data it's possible to easily reproduce past notifications in **any given block**. This is amazing!

This data can also be used to enforce newer standards regarding a storage hashing representation to make sure storage is correct in every network node.

### Storage Recovery

Use the code available at [https://gist.github.com/ixje/810cb086970cec43b709f6ae8589b872](https://gist.github.com/ixje/810cb086970cec43b709f6ae8589b872).

##### usage
`python main.py -s Storage/ -o temp_output -b 2458`, to read the audit files from `Storage/`

write the new chain in `./temp_output` and, consequently, restore to blockheight `2458`

### License
Data is freely available in MIT/Creative Commons.

NeoResearch 2018-2019
