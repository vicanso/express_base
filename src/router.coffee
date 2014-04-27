router = require './helpers/router'
config = require './config'
requireTree = require 'require-tree'
controllers = requireTree './controllers'
FileImporter = require 'jtfileimporter'
session = require './helpers/session'

addImporter = (req, res, next) ->
  fileImporter = new FileImporter()
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
    middleware : [session, addImporter]
    template : 'home'
  }
]






module.exports.init = (app) ->
  router.init app, routeInfos