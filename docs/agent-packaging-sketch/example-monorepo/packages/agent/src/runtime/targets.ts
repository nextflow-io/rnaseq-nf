export type TargetTriple =
  | 'darwin-arm64'
  | 'darwin-x64'
  | 'linux-arm64-gnu'
  | 'linux-x64-gnu'
  | 'linux-x64-musl'
  | 'win32-arm64-msvc'
  | 'win32-x64-msvc';

export const TARGET_TO_PACKAGE: Record<TargetTriple, string> = {
  'darwin-arm64': '@yourorg/agent-darwin-arm64',
  'darwin-x64': '@yourorg/agent-darwin-x64',
  'linux-arm64-gnu': '@yourorg/agent-linux-arm64-gnu',
  'linux-x64-gnu': '@yourorg/agent-linux-x64-gnu',
  'linux-x64-musl': '@yourorg/agent-linux-x64-musl',
  'win32-arm64-msvc': '@yourorg/agent-win32-arm64-msvc',
  'win32-x64-msvc': '@yourorg/agent-win32-x64-msvc'
};
