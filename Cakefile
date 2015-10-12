# see for ideas:
#  - https://github.com/twilson63/cakefile-template/blob/master/Cakefile
#  - https://github.com/jashkenas/coffee-script/blob/master/Cakefile
util = require 'util'
{print} = require 'util'
{spawn, exec} = require 'child_process'
glob = require("glob") # https://github.com/isaacs/node-glob
rmrf = (require 'rimraf').sync
mkdirp = require 'mkdirp'
ncp = require('ncp').ncp
ncp.limit = 16;
cpr = require('cpr')
Server = require('karma').Server;

try
  which = require('which').sync
catch err
  if process.platform.match(/^win/)?
    console.log 'WARNING: the which module is required for windows\ntry: npm install which'
  which = null

# ANSI Terminal Colors
bold = '\x1b[0;1m'
green = '\x1b[0;32m'
reset = '\x1b[0m'
red = '\x1b[0;31m'

task 'test', ->
  config = "#{__dirname}/karma.conf.js"
  server = new Server configFile: config, (exitCode) ->
      console.log "Karma has exited with #{exitCode}"
      process.exit exitCode
  server.start

task 'build:test', ->
  invoke 'build:assets-scss'
  exec 'brunch b', (error, stdout, stderr) ->
    if stdout
      console.log stdout
      invoke 'test'
    else if stderr
      console.log stderr
    else if error
      console.log error

task 'build:dist', ->
  invoke 'build:test'
  exec 'brunch b', (error, stdout, stderr) ->
    if stdout
      console.log stdout
      invoke 'test'
    else if stderr
      console.log stderr
    else if error
      console.log error

task 'build:assets-scss', 'copy the scss files to make them optionally available', ->
  log "Running build:assets-scss", green

  options =
    deleteFirst: true # Delete "to" before
    overwrite: true # If the file exists, overwrite it
    confirm: true
    filter: (file) ->
      matches = file.endsWith('.scss')
      #log "#{file}: matches: #{matches}", green
      matches
  cpr('app', 'public/scss', options, (err, files) ->
    return console.error(err) if err
  )


task 'ghpages', ->
  invoke 'build:dist'
  exec 'brunch b'
  config =
    src: 'public',
    dest: '../bootstrap-password-ghpages'

  ncp config.src, config.dest, (err) ->
    return console.error(err) if err
    console.log "done!"


# Cakefile Tasks
#
# ## *docs*
#
# Generate Annotated Documentation
#
# <small>Usage</small>
#
# ```
# cake docs
# ```
#task 'docs', 'generate documentation', -> docco()

# ## *clean*
#
# Cleans up generated ??? files
#
# <small>Usage</small>
#
# ```
# cake clean
# ```
#task 'clean', 'clean generated files', -> clean() -> log ";)", green

#
log = (message, color, explanation) -> console.log color + message + reset + ' ' + (explanation or '')
error = (message, explanation) -> log message, red, explanation
