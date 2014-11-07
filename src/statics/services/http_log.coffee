###*
 * $http相关的数据记录（请求使用时间，出错等）
###

module = angular.module 'jt.service.httpLog', ['LocalStorageModule']

now = Date.now || ->
  new Date().getTime()
module.factory 'jtHttpLog', ['$q', '$injector', 'localStorageService', ($q, $injector, localStorageService) ->
  # 本地存储http log，定时将所有的log往服务器发送
  httpLogStorage = localStorageService.get('httpLog') || {
    success : []
    error : []
  }

  ###*
   * [postHttpLog 向服务器发送http log的数据]
   * @return {[type]} [description]
  ###
  postHttpLog = ->
    $http = $injector.get '$http'
    if httpLogStorage.success.length || httpLogStorage.error.length
      $http.post('/httplog', httpLogStorage).success((res) ->
        console.dir res
      ).error (res) ->
        console.dir res
      httpLogStorage =
        success : []
        error : []
      localStorageService.set 'httpLog', httpLogStorage

  setInterval ->
    postHttpLog()
  , 120 * 1000
  setTimeout ->
    total = httpLogStorage.success.length + httpLogStorage.error.length
    postHttpLog() if total > 20
    return
  , 1


  httpLog =
    request : (config) ->
      config._createdAt = now()
      config
    response : (res) ->
      config = res.config
      url = config.url
      deprecate = res.headers 'JT-Deprecate'
      if CONFIG.env == 'development' && deprecate
        alert "url: #{url}, desc:#{deprecate}" 

      if url != '/httplog'
        useTime = now() - config._createdAt
        httpLogStorage.success.push {
          url : url
          use : useTime
        }
        localStorageService.set 'httpLog', httpLogStorage
      res
    requestError : (rejection) ->
      $q.reject rejection

    responseError : (rejection) ->
      deprecate = rejection.headers 'JT-Deprecate'
      config = rejection.config
      url = config.url
      if CONFIG.env == 'development' && deprecate
        alert "url: #{url}, desc:#{deprecate}" 
      httpLogStorage.error.push {
        url : url
        status : rejection.status
        use : now() - config._createdAt
      }
      localStorageService.set 'httpLog', httpLogStorage
      $q.reject rejection
  httpLog
]