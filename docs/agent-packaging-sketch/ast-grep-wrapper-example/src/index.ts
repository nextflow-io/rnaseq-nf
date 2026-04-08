import fs from 'node:fs';
import path from 'node:path';
import { parse } from '@ast-grep/napi';
import { getBundledLanguages, registerBundledLanguages } from './registerLanguages.js';

export { getBundledLanguages, registerBundledLanguages };

export function inferLanguageFromFile(filePath: string): string | null {
  const ext = path.extname(filePath).toLowerCase();
  switch (ext) {
    case '.js':
    case '.cjs':
    case '.mjs':
    case '.jsx':
      return 'javascript';
    case '.ts':
    case '.mts':
    case '.cts':
      return 'typescript';
    case '.tsx':
      return 'tsx';
    case '.json':
      return 'json';
    case '.yaml':
    case '.yml':
      return 'yaml';
    case '.sh':
    case '.bash':
      return 'bash';
    default:
      return null;
  }
}

export function parseFile(filePath: string) {
  registerBundledLanguages();
  const language = inferLanguageFromFile(filePath);
  if (!language) {
    throw new Error(`No bundled ast-grep language for file: ${filePath}`);
  }
  const source = fs.readFileSync(filePath, 'utf8');
  return parse(language, source);
}
