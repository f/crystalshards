var gulp = require('gulp'),
    sass = require('gulp-sass'),
    browserSync = require('browser-sync').create(),
    autoprefixer = require('gulp-autoprefixer'),
    csso = require('gulp-csso'),
    rename = require('gulp-rename'),
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify');


var refreshBrowser = browserSync.reload,
    src = "./assets/",
    dist = "./public/",
    filesScript = [
        src + "js/main.js"
    ];


gulp.task('style', function () {
    return gulp.src(src + "css/main.scss")
        .pipe(sass({
            errLogToConsole: true,
            outputStyle: 'expanded'
        }).on('error', sass.logError))
        .pipe(autoprefixer())
        .pipe(csso())
        //.pipe(rename({
        //    suffix: '.min'
        //}))
        .pipe(gulp.dest(dist + "src/"))
        .pipe(browserSync.stream());
});


gulp.task('script', function () {
    return gulp.src(filesScript)
        .pipe(concat('main.js'))
        //.pipe(uglify())
        .pipe(gulp.dest(dist + "src/"))
});


gulp.task("watch", ["style", "script"], function () {
    browserSync.init({
        notify: false,
        proxy: "localhost:3000"
    });
    gulp.watch(src + 'css/**/*.scss', ["style"]);
    gulp.watch(src + 'js/main.js', ["script", refreshBrowser]);
    gulp.watch(dist + "**/*.ecr").on("change", refreshBrowser);
});


gulp.task("default", ["watch"]);
gulp.task("export", ["style", "script"]);
