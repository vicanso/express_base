mongodb = require '../helpers/mongodb'
config = require '../config'
module.exports = (req, res, cbf) ->
  res.header 'Cache-Control', 'public, max-age=600'
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