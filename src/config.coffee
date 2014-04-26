program = require 'commander'
do ->
  program.version('0.0.1')
  .option('-p, --port <n>', 'listen port', parseInt)
  .option('--log <n>', 'the log file')
  .parse process.argv


module.exports.port = program.port || 10000

module.exports.env = process.env.NODE_ENV || 'development'