program = require 'commander'
do ->
  program.version('0.0.1')
  .option('-p, --port <n>', 'listen port', parseInt)
  # .option('--log <n>', 'the log file')
  .option('--mongodb <n>', 'mongodb uri eg.mongodb://localhost:10020/test, mongodb://user:pwd@localhost:10020/test')
  .option('--redis <n>', 'redis uri eg.redis://localhost:10010, redis://pwd@localhost:10010')
  .option('--stats <n>', 'stats uri eg.stats://localhost:6000')
  .parse process.argv


exports.port = program.port || 10000

exports.env = process.env.NODE_ENV || 'development'

exports.app = 'express_base'

###*
 * [staticUrlPrefix 静态文件url前缀]
 * @type {String}
###
exports.staticUrlPrefix = '/static'


exports.staticPath = __dirname + '/statics'


exports.staticHosts = if exports.env == 'development' then null else ['s1.vicanso.com', 's2.vicanso.com']


exports.redis = do ->
  url = require 'url'
  redisUri = program.redis || 'redis://localhost:10010'
  urlInfo = url.parse redisUri
  {
    port : urlInfo.port
    host : urlInfo.hostname
    password : urlInfo.auth
  }


exports.stats = do ->
  url = require 'url'
  statsUri = program.stats || 'stats://localhost:6000'
  urlInfo = url.parse statsUri
  {
    port : urlInfo.port
    host : urlInfo.hostname
  }
  
exports.session = 
  secret : 'jenny&tree'
  key : 'vicanso'
  ttl : 3600 * 6

module.exports.mongodbUri = program.mongodb || 'mongodb://localhost:10020/test'