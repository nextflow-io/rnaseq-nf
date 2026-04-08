import fs from 'node:fs';
import path from 'node:path';
import { createRequire } from 'node:module';
import { familySync, GLIBC, MUSL } from 'detect-libc';
import { TARGET_TO_PACKAGE, type TargetTriple } from './targets.js';

const require = createRequire(import.meta.url);

export interface RuntimeManifest {
  product: string;
  packageVersion: string;
  platform: NodeJS.Platform;
  arch: NodeJS.Architecture;
  libc?: 'glibc' | 'musl';
  engine: {
    version: string;
    abi: number;
    binary: string;
  };
  parsers: {
    root: string;
    manifest: string;
    count: number;
    setVersion: string;
  };
}

export interface ParserManifest {
  setVersion: string;
  engineAbi: number;
  languages: Record<string, {
    path: string;
    metadata: string;
    queries: string;
    extensions: string[];
  }>;
}

export interface ParserMetadata {
  language: string;
  displayName: string;
  grammarVersion: string;
  parserAbi: number;
  engineAbi: number;
  fileExtensions: string[];
  queries: Record<string, string>;
  license: string;
  source: {
    name: string;
    revision: string;
  };
}

export interface ResolvedRuntime {
  target: TargetTriple;
  packageName: string;
  packageRoot: string;
  binaryPath: string;
  parserRoot: string;
  parserManifestPath: string;
  runtimeManifestPath: string;
  runtimeManifest: RuntimeManifest;
  parserManifest: ParserManifest;
}

interface PlatformPackageModule {
  getRuntime(): {
    packageRoot: string;
    binaryPath: string;
    parserRoot: string;
    parserManifestPath: string;
    runtimeManifestPath: string;
  };
}

function detectTargetTriple(): TargetTriple {
  const { platform, arch } = process;

  if (platform === 'darwin' && arch === 'arm64') return 'darwin-arm64';
  if (platform === 'darwin' && arch === 'x64') return 'darwin-x64';
  if (platform === 'win32' && arch === 'arm64') return 'win32-arm64-msvc';
  if (platform === 'win32' && arch === 'x64') return 'win32-x64-msvc';

  if (platform === 'linux' && arch === 'arm64') {
    const family = familySync();
    if (family !== GLIBC) {
      throw new Error(`Unsupported Linux ARM64 libc: ${family ?? 'unknown'}`);
    }
    return 'linux-arm64-gnu';
  }

  if (platform === 'linux' && arch === 'x64') {
    const family = familySync();
    if (family === MUSL) return 'linux-x64-musl';
    if (family === GLIBC || family === null) return 'linux-x64-gnu';
    throw new Error(`Unsupported Linux x64 libc: ${family}`);
  }

  throw new Error(`No bundled runtime is available for ${platform}-${arch}`);
}

function readJson<T>(filePath: string): T {
  return JSON.parse(fs.readFileSync(filePath, 'utf8')) as T;
}

function assertFile(filePath: string, description: string): void {
  if (!fs.existsSync(filePath)) {
    throw new Error(`${description} missing at expected path: ${filePath}`);
  }
}

export function resolveRuntime(): ResolvedRuntime {
  const target = detectTargetTriple();
  const packageName = TARGET_TO_PACKAGE[target];

  let platformPackage: PlatformPackageModule;
  try {
    platformPackage = require(packageName) as PlatformPackageModule;
  } catch (error) {
    throw new Error(
      `The package ${packageName} is not installed for target ${target}. Reinstall @yourorg/agent.`,
      { cause: error as Error }
    );
  }

  const runtime = platformPackage.getRuntime();
  assertFile(runtime.runtimeManifestPath, 'Runtime manifest');
  assertFile(runtime.parserManifestPath, 'Parser manifest');
  assertFile(runtime.binaryPath, 'Runtime binary');

  const runtimeManifest = readJson<RuntimeManifest>(runtime.runtimeManifestPath);
  const parserManifest = readJson<ParserManifest>(runtime.parserManifestPath);

  if (runtimeManifest.engine.abi !== parserManifest.engineAbi) {
    throw new Error(
      `Installed parser set requires engine ABI ${parserManifest.engineAbi}, ` +
      `but runtime engine ABI is ${runtimeManifest.engine.abi}.`
    );
  }

  return {
    target,
    packageName,
    packageRoot: runtime.packageRoot,
    binaryPath: runtime.binaryPath,
    parserRoot: runtime.parserRoot,
    parserManifestPath: runtime.parserManifestPath,
    runtimeManifestPath: runtime.runtimeManifestPath,
    runtimeManifest,
    parserManifest
  };
}

export function getBinaryPath(): string {
  return resolveRuntime().binaryPath;
}

export function getAvailableLanguages(): string[] {
  return Object.keys(resolveRuntime().parserManifest.languages).sort();
}

export function getParserMetadata(language: string): ParserMetadata {
  const runtime = resolveRuntime();
  const parser = runtime.parserManifest.languages[language];
  if (!parser) {
    throw new Error(`Parser ${language} is not present in bundled parser set ${runtime.parserManifest.setVersion}`);
  }

  const metadataPath = path.join(runtime.parserRoot, parser.metadata);
  assertFile(metadataPath, `Parser metadata for ${language}`);
  return readJson<ParserMetadata>(metadataPath);
}
