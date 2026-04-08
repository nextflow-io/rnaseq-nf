import js from '@ast-grep/lang-javascript';
import ts from '@ast-grep/lang-typescript';
import tsx from '@ast-grep/lang-tsx';
import json from '@ast-grep/lang-json';
import yaml from '@ast-grep/lang-yaml';
import bash from '@ast-grep/lang-bash';
import { registerDynamicLanguage } from '@ast-grep/napi';

const REGISTRATION = {
  javascript: js,
  typescript: ts,
  tsx,
  json,
  yaml,
  bash
} as const;

let registered = false;

export function registerBundledLanguages(): void {
  if (registered) return;
  registerDynamicLanguage(REGISTRATION);
  registered = true;
}

export function getBundledLanguages(): string[] {
  return Object.keys(REGISTRATION).sort();
}
