var gulp = require('gulp'),
    source = require('vinyl-source-stream'),
    browserify = require('browserify');

gulp.task('js', function () {
  return browserify('./public/js/client.js', {
    noparse: []
  })
  .bundle()
  .pipe(source('bundle.js'))
  .pipe(gulp.dest('./public/js/'));
});

gulp.task('default', ['js']);
