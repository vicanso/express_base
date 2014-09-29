JTError = require '../helpers/jterror'

module.exports = (req, res, cbf) ->
  res.header 'JT-Deprecate', 'deprecate xxxx, please use xxxx'
  cbf new JTError 100
  # cbf null, {
  #   name : 'vicanso'
  # }