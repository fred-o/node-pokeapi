/*global require*/
var coffee = require('gulp-coffee');
var del    = require('del');
var gulp   = require('gulp');
var util   = require('gulp-util');

gulp.task('clean', function(cb) {
    del(['lib/'], cb);
});

gulp.task('compile', function() {
    gulp.src('src/**/*.coffee')
        .pipe(coffee().on('error', util.log))
        .pipe(gulp.dest('lib'));
});

gulp.task('watch', function() {
    gulp.watch('src/**', ['compile']);
});
