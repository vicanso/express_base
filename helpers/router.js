'use strict';
var _ = require('lodash');


var render = function(res, template, data, next){
  var importer = data.importer || res.locals.importer;
  res.render(template, data, function(err, html){
    if(err){
      next(err);
      return;
    }
    if(importer){
      html = appendJsAndCss(html, importer); 
    }
    response(res, html, next);
  });
};

var response = function(res, data, next){
  res.send(data);
};

var json = function(res, data, next){
  res.json(data);
};

var appendJsAndCss = function(html, importer){
  html = html.replace('<!--CSS_FILES_CONTAINER-->', importer.exportCss());
  html = html.replace('<!--JS_FILES_CONTAINER-->', importer.exportJs());
  return html;
};

var routerHandler = function(handler, template){
  return function(req, res, next){
    next = _.once(next);
    var cbf = function(err, data){
      if(err){
        next(err);
        return;
      }
      if(res.headersSent){
        var err = new Error('the header has been sent');
        err.msg = '该请求已经发送';
        next(err);
        return;
      }
      if(data){
        if(template){
          res.locals.TEMPLATE = template;
          render(res, template, data, next);
        }else{
          if(_.isObject(data)){
            json(res, data, next);
          }else{
            response(res, data, next);
          }
        }
      }else{
        res.send('');
      }
    };
    handler(req, res, cbf);
  };
}


exports.init = function(router, routeInfos){
  _.forEach(routeInfos, function(routeInfo){
    var template = routeInfo.template;
    var middleware = routeInfo.middleware || [];
    var routes = routeInfo.route;
    if(!_.isArray(routes)){
      routes = [routes];
    }
    var methods = routeInfo.method || 'get';
    if(!_.isArray(methods)){
      methods = [methods];
    }
    var handler = routerHandler(routeInfo.handler, template);
    _.each(routes, function(route){
      _.each(methods, function(method){
        method = method.toLowerCase();
        router[method](route, middleware, handler);
      });
    });
  });
};