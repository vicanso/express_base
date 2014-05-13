program = require 'commander'
do ->
  program.version('0.0.1')
  .option('-p, --port <n>', 'listen port', parseInt)
  .option('--log <n>', 'the log file')
  .option('--uri <n>', 'mongodb uri')
  .parse process.argv


exports.port = program.port || 10000

exports.env = process.env.NODE_ENV || 'development'

###*
 * [staticUrlPrefix 静态文件url前缀]
 * @type {String}
###
exports.staticUrlPrefix = '/static'


exports.redis =
  port : '10010'
  host : 'black'
  password : 'redis pwd'

exports.session = 
  secret : 'jenny&tree'
  key : 'vicanso'
  ttl : 3600

module.exports.mongodbUri = program.uri