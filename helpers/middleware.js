'use strict';
var os = require('os');
var util = require('util');
var onHeaders = require('on-headers');
var config = require('../config');
var express = require('express');
var crypto = require('crypto');
var fs = require('fs');
var path = require('path');
var moment = require('moment');
/**
 * [jtInfoHandler 添加信息到response header]
 * @return {[type]} [description]
 */
exports.jtInfoHandler = function(){
  var requestTotal = 0;
  var handlingReqTotal = 0;
  var hostname = os.hostname();
  var processName = config.process;
  return function(req, res, next){
    var start = Date.now();
    handlingReqTotal++;
    requestTotal++;
    onHeaders(res, function(){
      var jtInfo = util.format('%s,%s,%d,%d,%d,%d', hostname, processName, process.pid, handlingReqTotal, requestTotal, Date.now() - start);
      handlingReqTotal--;
      res.set('JT-Info', jtInfo);
    });
    next();
  };
};

/**
 * [debugHandler 将debug的参数配置到res.locals中]
 * @return {[type]} [description]
 */
exports.debugHandler = function(){
  return function(req, res, next){
    res.locals.DEBUG = req.param('_debg');
    var pattern = req.param('_pattern');
    if(!pattern && config.env === 'development'){
      pattern = '*';
    }
    res.locals.PATTERN = pattern;
    next();
  };
};


/**
 * [adminHandler description]
 * @param  {[type]} token [description]
 * @return {[type]}       [description]
 */
exports.adminHandler = function(token){
  var validate = function(req, res, next){
    var key = req.param('key');
    var shasum = crypto.createHash('sha1');
    if(!key || token !== shasum.update(key).digest('hex')){
      res.status(401).send('Unauthorized');
    }else{
      next();
    }
  };
  var router = express.Router();
  //重启node
  router.get('/restart', validate, function(req, res){
    res.status(200).json({msg : 'success'});
    var timer = setTimeout(function(){
      process.exit();
    }, 1000);
  });


  var appVersion = 'no version';
  var getVersion = function(cbf){
    fs.readFile(path.join(__dirname, '../version'), cbf);
  };
  getVersion(function(err, buf){
    if(buf){
      appVersion = buf.toString();
    }
  });
  //获取代码的版本与正在运行的版本
  router.get('/version', validate, function(req, res){
    getVersion(function(err, buf){
      buf = buf || 'no version';
      res.send({
        running : appVersion,
        code : buf.toString()
      });
    });
  });
  return router;
};

/**
 * [static 静态文件处理]
 * @param  {[type]} staticPath [静态文件所在目录]
 * @param  {[type]} maxAge     [maxAge时间（单位秒）]
 * @return {[type]}            [description]
 */
exports.static = function(staticPath, maxAge){
  var handler = express.static(staticPath);
  return function(req, res){
    if(maxAge){
      res.set({
        'Expires' : moment().add(maxAge, 'seconds').toString(),
        'Cache-Control' : util.format('public, max-age=%d, s-max=3600', maxAge),
        'Vary' : 'Accept-Encoding'
      });
    }else{
      res.set({
        'Cache-Control' : 'no-cache'
      });
    }
    handler(req, res, function(err){
      res.status(404).send('');
    });
  };
};