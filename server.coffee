checks  = require './check'
express = require 'express'

app = express()

app.set('view engine', 'ejs')
app.set('views', __dirname + '/views');
app.use(express.static(__dirname + "/public/"))
app.use(express.bodyParser())

app.get "/", (req,res) ->
  start= req.query.start
  country = req.query.country || null
  city = req.query.city || null
  tag = req.query.tag || null
  if start?
    events = checks.checkDate(start, country, city, tag)
  else
    events = []
  res.render 'index',
    start: start,
    events: events,
    country: country || '',
    city: city || '',
    tag: tag || '',
    allTags: checks.allTags()
    allCities: checks.allCities()
    allCountries: checks.allCountries()

app.get "/free", (req,res) ->
  start = req.query.start
  end = req.query.end
  country = req.query.country || null
  city = req.query.city || null
  tag = req.query.tag || null
  days = checks.emptyDays(start, end, country, city, tag)
  events = checks.checkDate(start, end, country, city, tag)
  res.render 'free',
    start: start,
    end: end,
    days: days,
    events: events,
    country: country || '',
    city: city || '',
    tag: tag || '',
    allTags: checks.allTags()
    allCities: checks.allCities()
    allCountries: checks.allCountries()

port = process.env.PORT || 8080
app.listen port
console.log "Listening on Port '#{port}'"