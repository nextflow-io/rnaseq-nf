#!/usr/bin/env node
import { spawnSync } from 'node:child_process';
import { resolveRuntime } from '../dist/index.js';

const runtime = resolveRuntime();
const result = spawnSync(runtime.binaryPath, process.argv.slice(2), {
  stdio: 'inherit',
  env: {
    ...process.env,
    YOURAGENT_PARSER_ROOT: runtime.parserRoot,
    YOURAGENT_PARSER_MANIFEST: runtime.parserManifestPath,
    YOURAGENT_RUNTIME_MANIFEST: runtime.runtimeManifestPath
  }
});

if (result.error) {
  throw result.error;
}

process.exit(result.status ?? 0);
