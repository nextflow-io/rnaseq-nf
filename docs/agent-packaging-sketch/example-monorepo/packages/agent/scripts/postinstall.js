import { createRequire } from 'node:module';
import { familySync, GLIBC, MUSL } from 'detect-libc';
import { TARGET_TO_PACKAGE } from '../dist/runtime/targets.js';

const require = createRequire(import.meta.url);

function detectPackageName() {
  const { platform, arch } = process;

  if (platform === 'darwin' && arch === 'arm64') return TARGET_TO_PACKAGE['darwin-arm64'];
  if (platform === 'darwin' && arch === 'x64') return TARGET_TO_PACKAGE['darwin-x64'];
  if (platform === 'win32' && arch === 'arm64') return TARGET_TO_PACKAGE['win32-arm64-msvc'];
  if (platform === 'win32' && arch === 'x64') return TARGET_TO_PACKAGE['win32-x64-msvc'];

  if (platform === 'linux' && arch === 'arm64') {
    return familySync() === GLIBC ? TARGET_TO_PACKAGE['linux-arm64-gnu'] : null;
  }

  if (platform === 'linux' && arch === 'x64') {
    const family = familySync();
    if (family === MUSL) return TARGET_TO_PACKAGE['linux-x64-musl'];
    if (family === GLIBC || family === null) return TARGET_TO_PACKAGE['linux-x64-gnu'];
    return null;
  }

  return null;
}

const packageName = detectPackageName();
if (!packageName) {
  console.warn(`[youragent] no bundled runtime is published for ${process.platform}-${process.arch}`);
  process.exit(0);
}

try {
  require.resolve(packageName);
  console.log(`[youragent] detected bundled runtime ${packageName}`);
} catch {
  console.warn(`[youragent] expected optional dependency ${packageName} is not installed`);
}
