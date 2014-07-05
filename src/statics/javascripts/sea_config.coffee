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


if CONFIG.jsDebug > 0
  filterModList = ['jquery', 'underscore', 'Backbone', 'moment', 'async']
  stats = (obj, level) ->
    funcs = _.functions obj
    _.each funcs, (func) ->
      start = new Date() - 0
      tmp = _.wrap obj[func], (originalFunc, args...) ->
        msg = "call #{func}"
        msg += ", args:#{args}" if level > 1
        originalFunc.apply @, args
        console.log "#{msg} use:#{new Date() - start}ms"
      obj[func] = tmp

  seajs.on 'exec', (mod) ->
    id = mod.id
    return if ~_.indexOf filterModList, id
    stats mod.exports, CONFIG.jsDebug 