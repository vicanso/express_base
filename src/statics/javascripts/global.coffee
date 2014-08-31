

app = angular.module 'jtApp', ['LocalStorageModule', 'jt.debug', 'jt.utils', 'jt.user']
alert 'addRequires is defined' if app.addRequires

app.addRequires = (arr) ->
  arr = [arr] if !angular.isArray arr
  requires = app.requires
  angular.forEach arr, (item) ->
    requires.push item if !~requires.indexOf item
    return
  return

app.config ['localStorageServiceProvider', (localStorageServiceProvider) ->
  localStorageServiceProvider.prefix = 'jt'
  return
]

app.run ['$http', ($http) ->
  timeline = window.TIME_LINE
  if timeline
    $http.post '/timeline', timeline.getLogs()
  if window.IMPORT_FILES?.length
    $http.post '/import/files', {
      template : CONFIG.template
      files : window.IMPORT_FILES
    }
  return
]
window.JT_APP = app