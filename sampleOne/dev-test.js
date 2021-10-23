"use strict";

import { Block } from "./block.js";

const block = new Block("foo", "bar", "zoo", "baz");

console.log(block.toString());
console.log(Block.genesis().toString());
