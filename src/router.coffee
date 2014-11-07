router = require './helpers/router'
config = require './config'
requireTree = require 'require-tree'
controllers = requireTree './controllers'
FileImporter = require 'jtfileimporter'
JTMerger = require 'jtmerger'
if config.env != 'development'
  crc32Config = require './crc32.json'
  merger = new JTMerger require './merge.json'


###*
 * [addImporter description]
 * @param {[type]}   req  [description]
 * @param {[type]}   res  [description]
 * @param {Function} next [description]
###
addImporter = (req, res, next) ->
  fileImporter = new FileImporter merger
  fileImporter.debug true if res.locals.DEBUG
  fileImporter.hosts config.staticHosts
  # template = res.locals.TEMPLATE
  # if template && components
  #   currentTemplateComponents = components[template]
  #   fileImporter.importJs currentTemplateComponents?.js
  #   fileImporter.importCss currentTemplateComponents?.css

  fileImporter.version crc32Config if crc32Config
  fileImporter.prefix config.staticUrlPrefix
  res.locals.fileImporter = fileImporter
  next()


###*
 * [setNoCache 所有不可以缓存的GET请求，都应带上cache=false，方便haproxy判断该请求是否可以进入varnish]
 * @param {[type]}   req  [description]
 * @param {[type]}   res  [description]
 * @param {Function} next [description]
###
setNoCache = (req, res, next) ->
  query = req.query
  if req.method == 'GET' && query.cache != 'false'
    query.cache = false
    querystring = require 'querystring'
    url = require 'url'
    urlInfo = url.parse req.url
    res.redirect 301, "#{urlInfo.pathname}?#{querystring.stringify(query)}"
  else
    res.header 'Cache-Control', 'no-cache, no-store'
    next()

getCacheController = (ttl) ->
  (req, res, next) ->
    if config.env == 'development'
      res.header 'Cache-Control', 'no-cache, no-store'
    else
      res.header 'Cache-Control', "public, max-age=#{ttl}"
    next()
routeInfos = [
  {
    route : '/import/files'
    type : 'post'
    middleware : [setNoCache]
    handler : controllers.import_files
  }
  {
    route : '/statistics'
    type : 'post'
    middleware : [setNoCache]
    handler : controllers.statistics
  }
  {
    route : '/httplog'
    type : 'post'
    middleware : [setNoCache]
    handler : controllers.http_log
  }
  {
    route : '/'
    handler : controllers.home
    middleware : [
      getCacheController 600
      addImporter
    ]
    template : 'home'
  }
  {
    route : '/user'
    middleware : [setNoCache]
    handler : controllers.user
  }
]






module.exports.init = (app) ->
  router.init app, routeInfos