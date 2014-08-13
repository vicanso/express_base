seajs.use ['jquery', 'underscore', 'Backbone', 'jtLazyLoad', 'debug'], ($, _, Backbone, JTLazyLoad, debug) ->
  debug = debug 'home'
  debug 'debug test'
  debug 'json:%j', {
    test : 'a'
  }

  $.ajax({
    url : '/user'
    dataType : 'json'  
  }).success((res)->
  ).error (res) ->
    console.dir res

  if CONFIG.env == 'development'
    seajs.emit 'loadComplete'