`export default` exports the current value

`export { thing }` or `export { thing as default }` or `export * as module` export the live reference

# Avoid cicular dependencies:

Circular dependencies are allowed in JavaScript, but they're messy and should be avoided. For example, with:

``` javascript
// main.js
import { foo } from './module.js';

foo();

export function hello() {
  console.log('hello');
}
```

And

``` javascript
// module.js
import { hello } from './main.js';

hello();

export function foo() {
  console.log('foo');
}
```

This works! It logs "hello" then "foo". However, this only works due to hoisting, which lifts both function definitions above both of their calls. If we change the code to:

``` javascript
// main.js
import { foo } from './module.js';

foo();

export const hello = () => console.log('hello');
```
And
``` javascript
// module.js
import { hello } from './main.js';

hello();

export const foo = () => console.log('foo');
```
…it fails. module.js executes first, and as a result it tries to access hello before it's instantiated, and throws an error.

Let's get export default involved with:
``` javascript
// main.js
import foo from './module.js';

foo();

function hello() {
  console.log('hello');
}

export default hello;
```
And
``` javascript
// module.js
import hello from './main.js';

hello();

function foo() {
  console.log('foo');
}

export default foo;
```
The above fails, because hello in module.js points to the hidden variable exported by main.js, and it's accessed before it's initialized.

If main.js is changed to use export { hello as default }, it doesn't fail, because it's passing the function by reference and gets hoisted. If main.js is changed to use export default function hello(), again it doesn't fail, but this time it's because it hits that super-magic-special-case of export default function.