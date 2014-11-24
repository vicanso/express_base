'use strict';
var requireTree = require('require-tree');
var controllers = requireTree('./controllers');
var express = require('express');
var routerHandler = require('./helpers/router');
var config = require('./config');
var router = express.Router();
var importer = require('./middlewares/importer');
var staticVerion = null;
var importerOptions = {
  prefix : config.staticUrlPrefix,
  versionMode : 1
};
try{
  staticVerion = require('./crc32');
}catch(err){
  console.error(err);
}
if(config.env !== 'development'){
  importerOptions.version = staticVerion;
}

var addImporter = importer(importerOptions);

var routeInfos = [
  {
    route : '/',
    template : 'index',
    middleware : [addImporter],
    handler : controllers.home
  },
  {
    route : '/user',
    handler : controllers.user
  },
  {
    method : 'post',
    route : '/httplog',
    handler : controllers.http_log
  },
  {
    method : 'post',
    route : '/exception',
    handler : controllers.exception
  },
  {
    method : 'post',
    route : '/statistics',
    handler : controllers.statistics
  }
];

routerHandler.init(router, routeInfos);

module.exports = router;

