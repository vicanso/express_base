HomePageCtrl = ($scope, $http, debug, $log, utils, user, Book) ->
  debug = debug 'jt.homePage'
  debug Book
  debug 'start'

HomePageCtrl.$inject = ['$scope', '$http', 'debug', '$log', 'utils', 'user', 'Book']
window.HomePageCtrl = HomePageCtrl

window.JT_APP.addRequires ['jt.book']
