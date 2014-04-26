fs = require 'fs'
path = require 'path'
_ = require 'underscore'
moment = require 'moment'
componentsFile = path.join __dirname, '../components.json'

module.exports = (req, res, cbf) ->
  data = req.body
  refreshComponents data.template, _.uniq data.files
  res.send ''

refreshComponents = (template, files) ->
  allComponents = JSON.parse fs.readFileSync componentsFile
  result = 
    js : []
    css : []
  _.each files, (file) ->
    ext = path.extname file
    switch ext
      when '.js' then result.js.push file if file != '/javascripts/sea_dev.js'
      when '.css' then result.css.push file
      else throw new Error "unexpect file:#{file}"
  components = allComponents[template]
  if !components || components.js.join('') != result.js.join('') || components.css.join('') != result.css.join('')
    result.updatedAt = moment().format 'YYYY-MM-DD HH:mm:ss'
    allComponents[template] = result
    fs.writeFileSync componentsFile, JSON.stringify allComponents, null, 2
