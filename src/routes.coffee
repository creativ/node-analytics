module.exports = (app) ->

  app.get '/', (req, res) ->
    console.log req.models
    req.models.UserTrack.find {}, (err, results) ->
      res.render 'index',
        view: 'index'
        userTracks: results

  app.get '/trackme', (req, res) ->
    res.render 'trackme',
      view: 'trackme'
