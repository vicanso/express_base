mongodb = require '../helpers/mongodb'
config = require '../config'



module.exports = (req, res, cbf) ->
  Test = mongodb.model 'Test'
  obj =
    id : '123'
    name : 'vicanso'
    books : 'abc'.split ''
  cbf null, {
    viewData :
      globalVariable : 
        name : 'tree'
  }