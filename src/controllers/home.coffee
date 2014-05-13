mongodb = require '../helpers/mongodb'
module.exports = (req, res, cbf) ->
  Test = mongodb.model 'Test'
  new Test({
    id : '123'
    name : 'vicanso'
  }).save ->
  cbf null, {
    viewData :
      globalVariable : 
        name : 'tree'
  }