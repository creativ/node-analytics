express = require 'express'
http = require 'http'
orm = require 'orm'
app = express()

PORT = 8000

app.configure ->
  app.set 'port', process.env.PORT or PORT
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger('dev') if app.get('env') is 'development'
  app.use express.bodyParser()
  app.use express.methodOverride()
  # FIXME: move credentials to env
  app.use orm.express 'mysql://root:analytics@localhost/analytics',
    define: (db, models, next) ->
      models.UserTrack = db.define 'userTrack',
        browser: String
        platform: String
        type: String
        path: String
        language: String
        tracked: Date
      models.UserTrack.sync()
      next()
  require('./middleware/analytics')(app)
  app.use app.router
  app.use require('connect-assets')(
    src: "#{__dirname}/assets"
    helperContext: app.locals
  )
  require('./middleware/404')(app)

app.configure 'development', ->
  app.use express.errorHandler()
  app.locals.pretty = true

require('./routes')(app)

http.createServer(app).listen app.get('port'), ->
  port = app.get 'port'
  env = app.settings.env
  console.log "listening on port #{port} in #{env} mode"

module.exports = app
