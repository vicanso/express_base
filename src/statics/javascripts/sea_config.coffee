seajs.config {
  base : CONFIG.staticUrlPrefix
  alias : 
    'jtLazyLoad' : 'components/jtlazy_load/dest/jtlazy_load.js'
}

define 'jquery', ->
  window.jQuery

define 'underscore', ->
  window._

define 'Backbone', ->
  window.Backbone
