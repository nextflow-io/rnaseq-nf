# Bundled runtime packaging sketch

This is a concrete CLI-hacked sketch of the **full Option A** layout discussed in the Pi session for this repo.

It is intentionally checked in as a design artifact rather than a runnable package build for `rnaseq-nf` itself. The goal is to make the proposal tangible by showing:

- a workspace layout
- a root JS package with `optionalDependencies`
- a representative platform package with bundled parser assets
- manifest formats
- a TypeScript runtime resolver
- a lightweight `postinstall` verifier

## What is included

- `example-monorepo/package.json` — workspace root
- `example-monorepo/packages/agent/` — root JS package users install
- `example-monorepo/packages/agent-linux-x64-gnu/` — representative platform package
- `example-monorepo/parsers/lock.json` — parser set lockfile

## Intentional shortcuts

This sketch does **not** include real binaries or compiled parser libraries. Instead it focuses on structure and resolver logic.

The `agent-linux-x64-gnu` package is fleshed out as the example target. The same shape would be mirrored for:

- `@yourorg/agent-darwin-arm64`
- `@yourorg/agent-darwin-x64`
- `@yourorg/agent-linux-arm64-gnu`
- `@yourorg/agent-linux-x64-musl`
- `@yourorg/agent-win32-x64-msvc`
- `@yourorg/agent-win32-arm64-msvc`

## Core ideas captured here

1. The user installs one root package: `@yourorg/agent`
2. npm installs the matching platform package through `optionalDependencies`
3. The platform package bundles:
   - native engine binary
   - parser bundle
   - parser metadata
   - query files
   - runtime manifests
4. Runtime resolution is manifest-driven and strict about ABI compatibility
5. The parser set is version-locked with the engine release

## Suggested next step

If we want to push this further, the next useful upgrade would be:

- fill out the other target package stubs
- add a fake fixture loader test for `resolveRuntime()`
- codify manifest JSON schemas
