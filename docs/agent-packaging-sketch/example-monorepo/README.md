# Example monorepo

This is a concrete sketch of the bundled runtime layout.

## Packages

- `packages/agent` — root JavaScript package with runtime resolution logic
- `packages/agent-linux-x64-gnu` — representative platform package containing a binary + bundled parser assets

## Notes

- Only one platform package is fully mocked out here.
- The parser `.so` files are empty placeholders so the directory shape is visible.
- The TypeScript resolver is the most important executable artifact in this sketch.
