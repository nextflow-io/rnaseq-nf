const path = require('node:path');

exports.getRuntime = function getRuntime() {
  return {
    packageRoot: __dirname,
    binaryPath: path.join(__dirname, 'bin', 'youragent'),
    parserRoot: path.join(__dirname, 'parsers'),
    parserManifestPath: path.join(__dirname, 'parsers', 'manifest.json'),
    runtimeManifestPath: path.join(__dirname, 'runtime', 'manifest.json')
  };
};
