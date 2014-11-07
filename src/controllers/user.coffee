JTError = require '../helpers/jterror'

module.exports = (req, res, cbf) ->
  apiDesc = """<pre>
    /user GET 
    success {name : 'vicanso'}
    fail {code : xxx, msg : xxxx, stack : xxxx()}
  </pre>"""
  if req.query?.__api?
    res.send apiDesc
    return
  # res.header 'JT-Deprecate', 'deprecate xxxx, please use xxxx'
  cbf new JTError 100
  # cbf null, {
  #   name : 'vicanso'
  # }