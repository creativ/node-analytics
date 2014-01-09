_ = require 'underscore.string'
useragent = require 'express-useragent'

module.exports = (app) ->
  app.use (req, res, next) ->
    if _.include req.url, "."
      next()
    else
      if req.headers['user-agent'] isnt undefined
        ua = useragent.parse req.headers['user-agent']
        if req.headers['accept-language'] is undefined
          req.headers['accept-language'] = 'unknown'
        checkType = ->
          if ua.isMobile is true
            return 'mobile'
          else
            return 'desktop'
        records req, ua.Browser, ua.Platform, checkType(), req._parsedUrl['path'], req.headers['accept-language'].split(',')[0]
      next()

records = (req, browser, platform, type, path, language) ->
  req.models.UserTrack.create [
    browser: browser
    platform: platform
    type: type
    path: path
    language: language
    tracked: new Date()
  ], (err, items) ->
    console.error err
