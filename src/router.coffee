router = require './helpers/router'
requireTree = require 'require-tree'
controllers = requireTree './controllers'
FileImporter = require 'jtfileimporter'

addImporter = (req, res, next) ->
  fileImporter = new FileImporter()
  fileImporter.prefix '/static'
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