seajs.use ['jquery', 'underscore', 'Backbone'], ($, _, Backbone) ->


  if CONFIG.env == 'development'
    seajs.emit 'loadComplete'