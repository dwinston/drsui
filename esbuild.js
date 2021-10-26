const ElmPlugin = require('esbuild-plugin-elm');

require('esbuild').build({
    entryPoints: ['src/index.js'],
    bundle: true,
    outfile: 'bundle.js',
    plugins: [ElmPlugin({ debug: true})],
  }).catch(_e => process.exit(1))