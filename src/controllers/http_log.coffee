_ = require 'underscore'
async = require 'async'
logger = require('../helpers/logger') __filename
module.exports = (req, res, cbf) ->
  ua = req.header 'user-agent'
  ip = req.ip
  data = req.body
  httpLog = "ip:#{ip}, ua:#{ua}"
  _.each data?.success, (tmp) ->
    logger.info "#{httpLog} url:#{tmp.url} use:#{tmp.use}"
    return
  _.each data?.error, (tmp) ->
    logger.error "#{httpLog} url:#{tmp.url} use:#{tmp.use}"
    return
  cbf null, {
    msg : 'success'
  }