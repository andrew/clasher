allEvents = require('./events.json')

Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

getDates = (startDate, stopDate) ->
  dateArray = new Array()
  currentDate = new Date(startDate)
  while currentDate <= new Date(stopDate)
    dateArray.push new Date(currentDate)
    currentDate = currentDate.addDays(1)
  dateArray

Date::addDays = (days) ->
  dat = new Date(@valueOf())
  dat.setDate dat.getDate() + days
  dat

checkDate = (start, end, country, city, tag) ->
  events = allEvents
  
  # for date in dates
  #   date.toJSON().match(/(.+)T/)[1]
  
  if country?
    events = events.filter (event) ->
      event.country == country
  
  if city?
    events = events.filter (event) ->
      event.city == city
  
  if tag?
    events = events.filter (event) ->
      event.tags.indexOf(tag) >= 0
  
  dates = {}
  for event in events
    if dates[event.startDate]?
      dates[event.startDate].push event
    else
      dates[event.startDate] = [event]
  dates[start] || []

emptyDays = (start, end,  country, city, tag) ->
  dates = getDates(start, end)
  emptyDates = []
  for date in dates
    if checkDate(date.toJSON().match(/(.+)T/)[1], end, country, city).length == 0
      emptyDates.push(date) 
  emptyDates

allCountries = ->
  countries = allEvents.map (event)->
    event.country
  countries.unique().sort()

allCities = ->
  cities= allEvents.map (event)->
    event.city
  cities.unique().sort()

allTags = ->
  tags = allEvents.map (event)->
    event.tags
  tags.concat.apply([], tags).unique().sort()

module.exports = {
  emptyDays: emptyDays,
  checkDate: checkDate,
  allCountries: allCountries,
  allCities: allCities,
  allTags: allTags
}