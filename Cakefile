# see for ideas:
#  - https://github.com/twilson63/cakefile-template/blob/master/Cakefile
#  - https://github.com/jashkenas/coffee-script/blob/master/Cakefile
util = require 'util'
server = (require 'karma').server
fs = require 'fs'
path = require 'path'
{print} = require 'util'
{spawn, exec} = require 'child_process'
glob = require("glob") # https://github.com/isaacs/node-glob
rmrf = (require 'rimraf').sync
mkdirp = require 'mkdirp'
ncp = require('ncp').ncp;

ncp.limit = 16;

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
  server.start configFile: config, (exitCode) ->
      console.log "Karma has exited with #{exitCode}"
      process.exit exitCode

#task 'dev', ->
#  invoke 'build:pre'
#  exec "clear; DEBUG='brunch:*,-brunch:source-file,-brunch:watch' brunch watch --server", (error, stdout, stderr) ->
#    if stdout
#      console.log stdout
#    else if stderr
#      console.log stderr
#    else if error
#      console.log error

#task 'build:pre', ->
#  invoke 'build:assets-hack'

task 'build:test', ->
#  invoke 'build:pre'
  exec 'brunch b', (error, stdout, stderr) ->
    if stdout
      console.log stdout
      invoke 'test'
    else if stderr
      console.log stderr
    else if error
      console.log error

#task 'build:dist', ->
#  invoke 'build:pre'
#  exec 'brunch b', (error, stdout, stderr) ->
#    if stdout
#      console.log stdout
#      invoke 'test'
#    else if stderr
#      console.log stderr
#    else if error
#      console.log error


readFile = (filePath) ->
  log "readFile(#{filePath})", green
  fs.readFileSync(filePath, {encoding: 'utf8'})

writeFile = (filePath, data) ->
  fs.writeFileSync(filePath, data, {encoding: 'utf8'})

copyFile = (sourceFile, destFile) ->
  writeFile(destFile, readFile(sourceFile))

copyAll = (config, skipRm = false) ->
  rmrf(config.dest) unless skipRm
#  fs.mkdirSync(config.dest, 0o0755)
  mkdirp(config.dest)

  glob("#{config.src}", null, (err, matches) ->

    for file in matches
      #log "About to check basename on #{file}", green
      fileName = path.basename(file)
      dest = "#{config.dest}/#{fileName}"
      copyFile file, dest
      log "Copied #{file} to: #{dest}", green
  )

#task 'build:assets-hack', ->
#  # (hack) see https://github.com/brunch/brunch/issues/633
#  invoke 'build:assets-bootstrap-fonts'

#task 'build:assets-scss', 'copy the scss files to make them optionally available', ->
#  log "Running build:assets-scss", green
#
#  config =
#    src: 'app/lib/**/*.scss',
#    dest: 'public/scss'
#
#  copyAll(config)

#task 'build:assets-bootstrap-fonts', 'copy the bootstrap fonts in the expected public location (hack) see https://github.com/brunch/brunch/issues/633', ->
#  log "Running build:assets-bootstrap-fonts...", green
#
#  config =
#    src: 'bower_components/bootstrap-sass-official/assets/fonts/bootstrap/*',
#    dest: 'public/fonts/bootstrap'
#
#  copyAll(config)


task 'ghpages', ->
  invoke 'build:pre'
  exec 'brunch b'
  config =
    src: 'public',
    dest: '../bootstrap-password-ghpages'

#  copyAll(config, true)
  ncp config.src, config.dest, (err) ->
    return console.error(err)  if err
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
