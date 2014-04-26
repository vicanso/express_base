window.LOAD_FILES ?= []
seajs.on 'fetch', (mod) ->
  LOAD_FILES.push mod.uri

seajs.on 'loadComplete', ->
  setTimeout ->
    return if !CONFIG.template || !LOAD_FILES.length
    $.post '/seajs/files', {
      template : CONFIG.template
      files : LOAD_FILES
    }
  , 1


