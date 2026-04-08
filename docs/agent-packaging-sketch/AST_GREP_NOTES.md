# ast-grep-specific packaging notes

This note refines the earlier generic bundled-runtime sketch by grounding it in **ast-grep's actual packaging model** and this repository's recent git history.

## What local git history suggests

I checked the local commit history in this repository and found:

- no existing commits mentioning `ast-grep`, `tree-sitter`, or parser packaging
- recent work here is about **Nextflow modernization**, **agent guidance**, **typing**, and one new design-sketch commit:
  - `b9ed261 add bundled runtime packaging sketch`

So there is **no local precedent** in this repo for parser bundling or ast-grep-specific packaging. That means we should optimize for:

- lowest conceptual overhead
- easiest onboarding for future agents
- reusing ast-grep's existing distribution model instead of inventing a parallel one

## What ast-grep itself actually does

ast-grep already splits packaging across two layers:

1. **native core** via `@ast-grep/napi`
2. **language packages** via `@ast-grep/lang-*`

### Native core

`@ast-grep/napi` is published as a Node package with platform-specific native targets generated via napi-rs.

That means the platform-native piece is already solved using the common pattern of:

- top-level JS package
- platform-specific native binary packages
- version checks between wrapper and native binding

### Language packages

The language packages live in a separate monorepo and package one grammar per npm package, for example:

- `@ast-grep/lang-javascript`
- `@ast-grep/lang-typescript`
- `@ast-grep/lang-yaml`

Each package exports a language registration object with fields like:

- `libraryPath`
- `extensions`
- `languageSymbol`
- `expandoChar`

Each package also contains:

- `prebuilds/prebuild-<OS>-<ARCH>/parser.so` when available
- a `postinstall` script that resolves or builds the parser if no prebuild exists

## Important implication

If we are specifically building around **ast-grep**, then the earlier generic "one platform package contains the full parser universe" idea is probably **too custom**.

For ast-grep, the more natural package model is:

- rely on `@ast-grep/napi` for the native engine layer
- compose a curated set of `@ast-grep/lang-*` packages for the language layer
- optionally add **our own meta-package** that installs and registers the language set we want

That gives us a better fit with upstream behavior, better compatibility with future ast-grep updates, and less bespoke runtime logic.

## Revised recommendation for an ast-grep-based product

### Option A: thin wrapper over upstream ast-grep packages

Install:

- `@ast-grep/napi`
- selected `@ast-grep/lang-*` packages

Then provide a helper that registers those languages.

This is the lowest-maintenance approach.

### Option B: our own meta-package for a curated language bundle

Publish something like:

- `@yourorg/ast-grep-runtime`
- `@yourorg/ast-grep-runtime-web`
- `@yourorg/ast-grep-runtime-full`

Each meta-package would depend on:

- `@ast-grep/napi`
- a fixed list of `@ast-grep/lang-*` packages

This gives a cleaner installation story without forking ast-grep's internals.

### Option C: vendor ast-grep artifacts into our own platform packages

This is still possible, but only if we truly need:

- zero `postinstall` ambiguity
- complete offline reproducibility
- a fully owned support surface

This is the highest-maintenance approach because we would be re-packaging logic upstream ast-grep already maintains.

## Best fit for this repo's current stage

Given this repo's history, I would currently choose **Option B**:

- keep the packaging story simple for future agents
- align with ast-grep upstream
- avoid overdesigning a custom parser ABI/manifests layer too early
- still get a one-install curated runtime story

## Practical design differences vs the earlier generic sketch

If we pivot to ast-grep, then we should prefer:

- **language packages**, not one giant parser manifest we invented
- **registration code**, not a custom parser loader protocol
- **upstream package version lockstep**, not our own engine/parser ABI scheme unless we fork upstream
- **bundle definitions** like `web`, `systems`, `full`, instead of platform packages containing every parser asset directly

## pnpm caveat

One important upstream detail: ast-grep language packages rely on postinstall behavior, and the upstream docs note that **pnpm v10 does not run lifecycle scripts by default** unless explicitly allowlisted.

So if we want smooth install UX, our wrapper package should document or automate that expectation clearly.
