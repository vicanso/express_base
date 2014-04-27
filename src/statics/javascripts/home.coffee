seajs.use ['jquery', 'underscore', 'Backbone', 'jtLazyLoad'], ($, _, Backbone, JTLazyLoad) ->


  if CONFIG.env == 'development'
    seajs.emit 'loadComplete'