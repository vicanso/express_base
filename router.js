'use strict';
var requireTree = require('require-tree');
var controllers = requireTree('./controllers');
var express = require('express');
var routerHandler = require('./helpers/router');
var config = require('./config');
var router = express.Router();
var importer = require('./middlewares/importer');
var staticVerion = null;
var staticMerge = null;
var importerOptions = {
  prefix : config.staticUrlPrefix,
  versionMode : 1,
  srcPath : 'src'
};
try{
  staticVerion = require('./crc32');
  staticMerge = require('./merge');
}catch(err){
  console.error(err);
}
if(config.env !== 'development'){
  importerOptions.version = staticVerion;
  importerOptions.merge = staticMerge;
}

var addImporter = importer(importerOptions);
var session = require('./middlewares/session')();

var routeInfos = [
  {
    route : '/',
    template : 'index',
    middleware : [addImporter],
    handler : controllers.home
  },
  {
    route : '/user',
    middleware : [session],
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
  },
  {
    route : '/redirect',
    handler : function(req, res){
      res.status(301).redirect('/');
    }
  }
];

routerHandler.init(router, routeInfos);

module.exports = router;

