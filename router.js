'use strict';
var requireTree = require('require-tree');
var controllers = requireTree('./controllers');
var express = require('express');
var routerHandler = require('./helpers/router');
var router = express.Router();
var importer = require('./middlewares/importer');
var addImporter = importer({
  prefix : '/static'
  // version : '123',
  // versionMode : 1
});

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
  }
];

routerHandler.init(router, routeInfos);

module.exports = router;

