module.exports = (req, res, cbf) ->
  session = req.session
  session.times ?= 0
  session.times++
  cbf null, {
    viewData :
      globalVariable : 
        name : 'tree'
  }