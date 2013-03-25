getDates = (startDate, stopDate) ->
  dateArray = new Array()
  currentDate = startDate
  while currentDate <= stopDate
    dateArray.push new Date(currentDate)
    currentDate = currentDate.addDays(1)
  dateArray

Date::addDays = (days) ->
  dat = new Date(@valueOf())
  dat.setDate dat.getDate() + days
  dat

checkDate = (date, country, city, tag) ->
  events = require('./events.json')
  
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
  dates[date] || []

emptyDays = (start, end,  country, city, tag) ->
  dates = getDates(start, end)
  emptyDates = []
  for date in dates
    if checkDate(date.toJSON().match(/(.+)T/)[1], country, city).length == 0
      emptyDates.push(date) 
  emptyDates


module.exports = {
  emptyDays: emptyDays,
  checkDate: checkDate
}