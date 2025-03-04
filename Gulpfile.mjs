import path from "path";
import gulp from "gulp";
import htmlmin from "gulp-htmlmin";
import cleanCSS from "gulp-clean-css";
import uglify from "gulp-uglify";
import jsonMinify from "gulp-json-minify";
import imagemin, { gifsicle, mozjpeg, optipng, svgo } from "gulp-imagemin";

// Build directory path (default: _site)
const BUILD_DIR = path.resolve(process.env.BUILD_DIR || "_site");
console.log(`Directory to minification: ${BUILD_DIR}`);

// Minification configuration
const CONFIG = {
  html: {
    src: [`${BUILD_DIR}/**/*.html`],
    opts: {
      useShortDoctype: true,
      collapseWhitespace: true,
      removeComments: true,
      minifyJS: true,
      minifyCSS: true,
    },
  },
  css: {
    src: [`${BUILD_DIR}/**/*.css`, `!${BUILD_DIR}/**/vendor`],
    opts: {
      level: 2,
      removeAllComments: true,
    },
  },
  js: {
    src: [
      `${BUILD_DIR}/**/*.{js,mjs}`,
      `!${BUILD_DIR}/**/lib`,
      `!${BUILD_DIR}/**/vendor`,
    ],
    opts: {
      output: { comments: false },
      compress: { drop_console: true },
    },
  },
  json: {
    src: [`${BUILD_DIR}/**/*.{json,webmanifest}`],
  },
  img: {
    src: [`${BUILD_DIR}/**/*.{svg,gif,png,jpg,jpeg}`],
    opts: [
      gifsicle({ interlaced: true, optimizationLevel: 3 }),
      mozjpeg({ quality: 85, progressive: true }),
      optipng({ optimizationLevel: 7 }),
      svgo({
        plugins: [
          {
            name: "removeViewBox",
            active: false,
          },
          {
            name: "cleanupIDs",
            active: false,
          },
        ],
      }),
    ],
  },
};

// Minify HTML files
gulp.task("minify-html", () => {
  return gulp
    .src(CONFIG.html.src)
    .pipe(htmlmin(CONFIG.html.opts))
    .pipe(gulp.dest(BUILD_DIR));
});

// Minify CSS files
gulp.task("minify-css", () => {
  return gulp
    .src(CONFIG.css.src)
    .pipe(cleanCSS(CONFIG.css.opts))
    .pipe(gulp.dest(BUILD_DIR));
});

// Minify JS files
gulp.task("minify-js", () => {
  return gulp
    .src(CONFIG.js.src)
    .pipe(uglify(CONFIG.js.opts))
    .pipe(gulp.dest(BUILD_DIR));
});

// Minify JSON files
gulp.task("minify-json", () => {
  return gulp
    .src(CONFIG.json.src)
    .pipe(jsonMinify())
    .pipe(gulp.dest(BUILD_DIR));
});

// Optimize image files
gulp.task("optimize-images", () => {
  return gulp
    .src(CONFIG.img.src, { encoding: false })
    .pipe(imagemin(CONFIG.img.opts, { verbose: true }))
    .pipe(gulp.dest(BUILD_DIR));
});

// Default task
gulp.task(
  "default",
  gulp.parallel(
    "minify-html",
    "minify-css",
    "minify-js",
    "minify-json",
    "optimize-images"
  )
);
