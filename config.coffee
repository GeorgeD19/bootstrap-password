module.exports = config:
  # https://github.com/brunch/brunch/blob/stable/docs/config.md
  paths:
    public: 'public'

  files:
    javascripts:
      joinTo:
        'js/vendor.js': /^(bower_components|vendor)/
        'js/bootstrap-password.js': /^app/

      order:
        before: [
          'bower_components/jquery/dist/jquery.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/affix.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/alert.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/button.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/carousel.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/collapse.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/dropdown.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/tab.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/transition.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/scrollspy.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/modal.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/tooltip.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/popover.js'
        ]

    stylesheets:
      joinTo:

        'css/vendor.css': /^(bower_components|vendor)/
        'css/bootstrap-password.css': /^app/
      order:
        before: [
          'bower_components/bootstrap-sass-official/assets/stylesheets/_bootstrap.scss'
        ]

  plugins:
    imageoptimizer:
      path: 'images'
      smushit: no

    coffeelint:
      pattern: /^app\/.*\.coffee$/
      options:
        max_line_length:
          level: "ignore"
        no_unnecessary_fat_arrows:
          level: "ignore"

  conventions:
    # defaults here: https://github.com/brunch/brunch/blob/stable/src/helpers.coffee#L258
    assets: /^app[\/\\]+assets[\/\\]+/ # works to get bootstrap assets as well

    # 1. omit anything starting with an underscore (except root of _bootstrap.scss) default: /[\\/]_/
    # 2. default: omit stuff
    # 3. need to omit bootstrap's assets/javascripts
    ignored: [
      /[\\/]_(?!bootstrap.scss)/

      /vendor[\\/](node|j?ruby-.*|bundle)[\\/]/
      /bower_components\/bootstrap-sass-official\/assets\/javascripts/
    ]