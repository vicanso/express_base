module = angular.module 'jt.user', []


module.factory 'user', ['$http', 'localStorageService', 'utils', ($http, localStorageService, utils) -> 
  userInfo = localStorageService.get 'user'
  if !userInfo
    userInfo = 
      uuid : utils.uuid()
  localStorageService.set 'user', userInfo

  user =
    test : ->

  user

]
