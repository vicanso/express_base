var gulp = require('gulp');
var path = require('path');
var jshint = require('gulp-jshint');
var uglify = require('gulp-uglify');
var stylus = require('gulp-stylus');
var base64 = require('gulp-base64');
var cssmin = require('gulp-cssmin');
var nib = require('nib');
var copy = require('gulp-copy');
var del = require('del');
var path = require('path');
var through = require('through');
var bufferCrc32 = require('buffer-crc32');
var fs = require('fs');
gulp.task('jshint', ['clean:dest'], function(){
  var srcList = [
    '*.js',
    'controllers/*.js', 
    'helpers/*.js', 
    'middlewares/*.js',
    'statics/src/**/*.js',
    '!statics/src/component/*.js'
  ];
  return gulp.src(srcList)
    .pipe(jshint({
      predef : [],
      node : true
    }))
    .pipe(jshint.reporter('default'));
});


gulp.task('clean:dest', function(cbf){
  del(['statics/dest'], cbf);
});

gulp.task('clean:build', ['static_version'], function(cbf){
  del(['statics/build'], cbf);
});


gulp.task('static_css', ['clean:dest'], function(){
  return gulp.src('statics/src/**/*.styl')
    .pipe(stylus({
      use : nib(),
      compress : true
    }))
    .pipe(base64())
    .pipe(cssmin())
    .pipe(gulp.dest('statics/build'));
});

gulp.task('static_copy_css_js', ['clean:dest'], function(){
  return gulp.src(['statics/**/*.css', 'statics/**/*.js'])
    .pipe(copy('statics/build', {
      prefix : 2
    }));
});

gulp.task('static_js', ['clean:dest'], function(){
  return gulp.src('statics/src/**/*.js')
    .pipe(uglify())
    .pipe(gulp.dest('statics/build'));
});

gulp.task('static_copy_other', ['clean:dest'], function(){
  return gulp.src(['statics/**/*', '!statics/**/*.js', '!statics/**/*.styl', '!statics/**/*.css', '!statics/**/*.js'])
    .pipe(copy('statics/dest', {
      prefix : 2
    }));
});




gulp.task('static_version', ['static_copy_css_js', 'static_js', 'static_css'], function(){
  var crc32Infos = {};
  var crc32 = function(file){
    var version = bufferCrc32.unsigned(file.contents);
    crc32Infos['/' + file.relative] = version;
    var ext = path.extname(file.path);
    file.path = file.path.substring(0, file.path.length - ext.length) + '_' + version + ext;
    this.emit('data', file);
  };

  return gulp.src(['statics/build/**/*.js', 'statics/build/**/*.css'])
    .pipe(through(crc32, function(){
      fs.writeFileSync('crc32.json', JSON.stringify(crc32Infos, null, 2));
      this.emit('end');
    }))
    .pipe(gulp.dest('statics/dest'));
});



gulp.task('default', ['clean:dest', 'jshint', 'static_copy_other', 'static_version', 'clean:build']);