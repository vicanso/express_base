fn = ($scope, $http, jtDebug, $log, utils, user, Book) ->
  $scope.user = {}
  jtDebug = jtDebug 'jt.homePage'
  jtDebug Book
  jtDebug 'start'
  user.getInfo (err, data) ->
    console.error err
    console.dir data

fn.$inject = ['$scope', '$http', 'jtDebug', '$log', 'utils', 'user', 'Book']
JT_APP.addRequires ['jt.book']
JT_APP.controller 'HomePageController', fn



