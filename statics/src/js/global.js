;(function(global){

'use strict';
var requires = ['LocalStorageModule', 'jt.service.debug', 'jt.service.utils', 'jt.service.httpLog'];
var app = angular.module('jtApp', requires);

// 用户在controller中添加require
app.addRequires = function(arr){
  if(!angular.isArray(arr)){
    arr = [arr];
  }
  var requires = app.requires;
  angular.forEach(arr, function(item){
    if(!~requires.indexOf(item)){
      requires.push(item);
    }
  });
  return this;
};


app.config(['localStorageServiceProvider', function(localStorageServiceProvider){
  // localstorage的前缀
  localStorageServiceProvider.prefix = 'jt';
}]).config(['$httpProvider', function($httpProvider){
  $httpProvider.interceptors.push('httpLog');
}]).config(['$provide', function($provide){
  var params = ['$delegate', '$injector', function($delegate, $injector){
    return function(exception, cause){
      if(CONFIG.env !== 'development'){
        var str = 'exception:' + exception.message + ', stack:' + exception.stack;
        if(cause){
          str += ', cause by ' + cause;
        }
        alert(str);
      }else{
        var $http = $injector.get('$http');
        $http.post('/exception?httplog=false', {
          message : exception.message,
          stack : exception.stack,
          cause : cause
        });
      }
      
    };
  }];
  $provide.decorator('$exceptionHandler', params);
}]);








})(this);