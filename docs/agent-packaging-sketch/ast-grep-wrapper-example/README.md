# ast-grep wrapper example

This example shows the shape I would now prefer **if the real target is ast-grep**.

Instead of inventing a custom engine + parser manifest protocol, this wrapper:

- depends on `@ast-grep/napi`
- depends on a curated set of `@ast-grep/lang-*` packages
- registers those languages in one place
- exposes a small helper API for parsing and scanning files

## Why this shape

It better matches upstream ast-grep's real distribution model:

- native engine packaging is handled by `@ast-grep/napi`
- parser packaging is handled by `@ast-grep/lang-*`
- our value-add is choosing and registering a known-good language bundle

## What this package would become in practice

Likely one of:

- `@yourorg/ast-grep-runtime`
- `@yourorg/ast-grep-runtime-web`
- `@yourorg/ast-grep-runtime-full`
