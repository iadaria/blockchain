> npm i crypto-js --save

### Blcok

- timestamp in miliseconds
- lastHash - the hash of the block before it
- hash - based on its own data
- the data to store

### Block Hashes and SHA-256

1. The hash is generated from the timestamp, lastHash, and stored data.
2. We'll use an algorithm called SHA-256:

- Produces a unique 32-byte(256 bit) hash value for unique data inputs
- One-way hash

3. Useful for block validation.

### JS syntax

1. Add jsonfig.json
1. Add in eslintrc: jest: true
