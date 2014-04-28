router = require './helpers/router'
config = require './config'
requireTree = require 'require-tree'
controllers = requireTree './controllers'
FileImporter = require 'jtfileimporter'
crc32Config = require './crc32.json' if config.env != 'development'
# session = require './helpers/session'

addImporter = (req, res, next) ->
  fileImporter = new FileImporter()
  fileImporter.version crc32Config if crc32Config
  fileImporter.prefix config.staticUrlPrefix
  res.locals.fileImporter = fileImporter
  next()

routeInfos = [
  {
    route : '/seajs/files'
    type : 'post'
    handler : controllers.seajs
  }
  {
    route : '/'
    handler : controllers.home
    middleware : [addImporter]
    template : 'home'
  }
]






module.exports.init = (app) ->
  router.init app, routeInfos