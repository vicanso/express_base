path = require 'path'
fs = require 'fs'
crc32 = require 'buffer-crc32'
destPath = 'dest'
srcPath = 'src'
staticsSrcPath = path.join srcPath, 'statics'
staticsDestPath = path.join destPath, 'statics'
buildPath = 'build'

normalizePath = 'dest/statics/components/normalize.css'

module.exports = (grunt) ->
  noneCopyFileExts = ['.coffee', '.js', '.styl']
  grunt.initConfig {
    clean : 
      grunt : [
        'node_modules/grunt-contrib-stylus/node_modules/stylus'
        'src/statics/components/jtlazy_load/src'
        'src/statics/components/jquery/src'
      ]
      dest : [destPath]
      build : [buildPath]
    coffee : 
      # node.js的coffee直接编译到目标目录
      node : 
        expand : true
        cwd : srcPath
        src : ['**/*.coffee', '!statics/**/*.coffee']
        dest : destPath
        ext : '.js'
      # 前端用的coffee编译到build目录，后续需要做uglify
      statics :
        expand : true
        cwd : staticsSrcPath
        src : ['**/*.coffee']
        dest : buildPath
        ext : '.js'
    jshint :
      options : 
        eqnull : true
      node :
        expand : true
        cwd : destPath
        src : ['**/*.js']
      statics :
        expand : true
        cwd : buildPath
        src : ['**/*.js']
    uglify : 
      statics :
        files : [
          {
            expand : true
            cwd : buildPath
            src : '**/*.js'
            dest : staticsDestPath
          }
          {
            expand : true
            cwd : staticsSrcPath
            src : '**/*.js'
            dest : staticsDestPath
          }
        ]
    stylus :
      bulid :
        files : [
          {
            expand : true
            cwd : srcPath
            src : ['**/*.styl']
            dest : destPath
            ext : '.css'
          }
        ]
    copy :
      # 将其它不需要处理的文件复制（除coffee js styl）
      build : 
        files : [
          {
            expand : true
            cwd : srcPath
            src : ['**/*']
            dest : destPath
            filter : (file) ->
              ext = path.extname file
              if ext && ~noneCopyFileExts.indexOf ext
                false
              else
                true
          }
        ]
      # 将前端使用的js未压缩版的文件复制一份到src目录下，为了线上调试用
      js :
        files : [
          {
            expand : true
            cwd : buildPath
            src : ['**/*.js']
            dest : staticsDestPath + '/src'
          }
          {
            expand : true
            cwd : staticsSrcPath
            src : '**/*.js'
            dest : staticsDestPath + '/src'
          }
        ]
    cssmin : 
      build : 
        files : [
          {
            expand : true
            cwd : destPath
            src : ['**/*.css']
            dest : destPath
            filter : (file) ->
              file != normalizePath
          }
        ]
    imageEmbed : 
      build : 
        files : [
          {
            expand : true
            cwd : destPath
            src : ['**/*.css']
            dest : destPath
            filter : (file) ->
              file != normalizePath
          }
        ]
    # 计算静态文件的crc32
    crc32 : 
      strict :
        files : [
          {
            expand : true
            cwd : staticsDestPath
            src : ['**/*.css', '**/*.js']
          }
        ]
  }

  grunt.registerMultiTask 'crc32', ->
    crc32Infos = {}
    @files.forEach (file) ->
      if file.src[0] != normalizePath
        buf = fs.readFileSync file.src[0]
        destFile = '/' + file.dest
        crc32Infos[destFile] = crc32.unsigned buf
    fs.writeFileSync path.join(destPath, 'crc32.json'), JSON.stringify( crc32Infos, null, 2)

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-image-embed'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-concat'

  grunt.registerTask 'gen', ['clean:grunt', 'clean:dest', 'coffee', 'jshint', 'uglify', 'copy:build', 'stylus', 'cssmin', 'imageEmbed', 'crc32', 'clean:build']