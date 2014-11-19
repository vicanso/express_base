'use strict';
var express = require('express');
var config = require('./config');
var path = require('path');
var middleware = require('./helpers/middleware');
var connectTimeout = require('connect-timeout');
var monitor = require('./helpers/monitor');
var JTCluster = require('jtcluster');
/**
 * [initAppSetting 初始化app的配置信息]
 * @param  {[type]} app [description]
 * @return {[type]}     [description]
 */
var initAppSetting = function(app){
  app.set('view engine', 'jade');
  app.set('trust proxy', true);
  app.set('views', path.join(__dirname, 'views'));

  app.locals.ENV = config.env;
  app.locals.STATIC_URL_PREFIX = config.staticUrlPrefix;
};


var initServer = function(){
  //性能监控的间隔时间
  var monitorInterval = 10 * 1000;
  if(config.env === 'development'){
    monitorInterval = 60 * 1000;
  }
  monitor.start(monitorInterval);

  var app = express();
  initAppSetting(app);

  app.use(connectTimeout(5 * 1000));
  app.use('/ping', function(req, res){
    res.send('OK');
  });

  app.use(middleware.jtInfoHandler());

  //单位秒
  var staticMaxAge = 365 * 24 * 3600;
  if(config.env === 'development'){
    staticMaxAge = 0;
  }
  app.use('/static', middleware.static(path.join(__dirname, 'statics'), staticMaxAge));


  app.use(require('method-override')());

  var bodyParser = require('body-parser');
  app.use(bodyParser.json());


  app.use('/jt', middleware.adminHandler('6a3f4389a53c889b623e67f385f28ab8e84e5029'));


  app.use(middleware.debugHandler());
  

  app.get('/', function(req, res, next){
    res.send('xxxxx');
  });

  app.listen(config.port);
  console.info('server listen on:' + config.port);
};

if(config.env === 'development'){
  initServer();
}else{
  new JTCluster({
    handler : initServer,
    envs : [
      {
        jtProcessName : 'tiger'
      },
      {
        jtProcessName : 'cuttlefish'
      }
    ],
    error : console.error,
    log : console.log
  });
}
