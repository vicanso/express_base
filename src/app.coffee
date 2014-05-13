path = require 'path'
config = require './config'

initAppSetting = (app) ->
  app.set 'view engine', 'jade'
  app.set 'trust proxy', true
  app.set 'views', "#{__dirname}/views"

  app.locals.CONFIG =
    env : config.env
    staticUrlPrefix : config.staticUrlPrefix
  return

initMongode = ->
  uri = config.mongodbUri
  if uri
    mongodb = require './helpers/mongodb'
    mongodb.init uri
    mongodb.initModels path.join __dirname, './models'


initServer = ->
  initMongode()
  express = require 'express'
  app = express()
  initAppSetting app
  app.use '/healthchecks', (req, res) ->
    res.send 'success'

  app.use require('morgan')() if config.env == 'production'

  serveStatic = require 'serve-static'
  ###*
   * [staticHandler 静态文件处理]
   * @param  {[type]} mount      [description]
   * @param  {[type]} staticPath [description]
   * @return {[type]}            [description]
  ###
  staticHandler = (mount, staticPath) ->
    staticHandler = serveStatic staticPath
    
    hour = 3600
    hour = 0 if !process.env.NODE_ENV

    staticMaxAge = 30 * 24 * hour

    if config.env == 'development'
      jtDev = require 'jtdev'
      app.use mount, jtDev.ext.converter staticPath
      app.use mount, jtDev.stylus.parser staticPath
      app.use mount, jtDev.coffee.parser staticPath

    app.use mount, (req, res, next) ->
      res.header 'Cache-Control', "public, max-age=#{staticMaxAge}, s-maxage=#{hour}"
      staticHandler req, res, (err) ->
        return next err if err
        res.send 404

  staticHandler '/static', path.join "#{__dirname}/statics"



  app.use require('morgan')('tiny') if config.env == 'development'


  app.use require('method-override')()
  app.use require('body-parser')()


  require('./router').init app

  app.listen config.port

  console.log "server listen on: #{config.port}"

if config.env == 'development'
  initServer()
else
  JTCluster = require 'jtcluster'
  options = 
    slaveTotal : 2
    slaveHandler : initServer
  jtCluster = new JTCluster options
  jtCluster.on 'log', (msg) ->
    console.dir msg


