var gulp = require('gulp');
var del = require('del');
var coffee = require('gulp-coffee');
var uglify = require('gulp-uglify');
var jshint = require('gulp-jshint');
var stylus = require('gulp-stylus');
var base64 = require('gulp-base64');
var cssmin = require('gulp-cssmin');
var crc32 = require('gulp-crc32');
var _ = require('underscore');
var nib = require('nib');
var copy = require('gulp-copy');
var destPath = 'dest';
var paths = {
  clean : {
    dest : 'dest'
  },
  coffee : {
    node : ['src/**/*.coffee', '!src/statics/**/*.coffee'],
    'static' : ['src/statics/**/*.coffee']
  },
  cssmin : ['src/**/*.css'],
  copy : ['src/**/*', '!src/**/*.coffee', '!src/**/*.styl', '!src/**/*.css'],
  stylus : ['src/**/*.styl'],
  crc32 : ['dest/**/*.css', 'dest/**/*.js']
}
gulp.task('clean:dest', function(cbf){
  del([paths.clean.dest], cbf);
});

gulp.task('scripts:node', ['clean:dest'], function(){
  return gulp.src(paths.coffee.node)
    .pipe(coffee())
    .pipe(jshint())
    .pipe(gulp.dest(destPath))
});


gulp.task('scripts:static', ['clean:dest'], function(){
  return gulp.src(paths.coffee['static'])
    .pipe(coffee())
    .pipe(jshint())
    .pipe(gulp.dest(destPath + '/statics/src'))
    .pipe(uglify())
    .pipe(gulp.dest(destPath + '/statics'))
});

gulp.task('copy', ['clean:dest'], function(){
  return gulp.src(paths.copy).pipe(copy(destPath, {
    prefix : 1
  }));
});


gulp.task('stylus', ['clean:dest'], function(){
  return gulp.src(paths.stylus)
    .pipe(stylus({
      use : nib(),
      compress : true
    }))
    .pipe(base64())
    .pipe(cssmin())
    .pipe(gulp.dest(destPath));
});

gulp.task('cssmin', ['clean:dest'], function(){
  return gulp.src(paths.cssmin)
    .pipe(cssmin())
    .pipe(gulp.dest(destPath));
});


gulp.task('crc32', ['merge-static', 'build'], function(cbf){
  gulp.src(paths.crc32)
    .pipe(crc32({
      dest : 'dest/crc32.json',
      complete : cbf
    }));
});


gulp.task('merge-static', ['build'], function(cbf){
  var Merger = require('jtmerger');
  var fs = require('fs');
  var path = require('path');
  fs.mkdirSync('dest/statics/merge');
  var components = require(path.join(__dirname, 'src/components.json'));
  var mergeInfo = require(path.join(__dirname, 'src/merge.json'));
  var merger = new Merger(mergeInfo);
  var result = merger.getMergeList(components, 'dest/statics');
  _.each(result, function(files, saveFile){
    merger.merge(__dirname, saveFile, files);
  });
  cbf();
});

gulp.task('build', ['scripts:node', 'scripts:static', 'copy', 'stylus', 'cssmin']);

gulp.task('default', ['build', 'merge-static', 'crc32']);