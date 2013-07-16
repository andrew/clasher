request = require 'request'
cheerio = require 'cheerio'
Batch   = require 'batch'
fs      = require 'fs'

months = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']

loadURLs = (year, cb) ->
  batch = new Batch
  # batch.concurrency 4
  for month in months
    do (month) ->
      batch.push (done) ->
        do(done)->
        url = "http://lanyrd.com/#{year}/#{month}/"

        request url, (error, response, body) ->
          $ = cheerio.load body
          count = $('.tagline').html().replace(',','').match(/\d+/)
          page_count = Math.ceil(count  / 30)

          page_numbers = [1..page_count]
          urls = page_numbers.map (page_number) ->
            "http://lanyrd.com/#{year}/#{month}/?page=#{page_number}"
          done(error, urls)

  batch.on "progress", (e) ->
    console.log('progress', e.percent)
  batch.end (err, urls) ->
    cb(err, urls.concat.apply([], urls))

loadEvents = (url, cb) ->
  request url, (error, response, body) ->
    $ = cheerio.load body, ignoreWhitespace: true
    lis = $('#conference-listing .primary ol li.conference')
    events =lis.map (i, li)->
      li = $(li)
      tags = $(li).find('ul.tags a')
      {
        title: li.find('.summary').html(),
        url: "http://lanyrd.com" + li.find('.summary').attr('href')
        country: li.find('.location a').first().text()?.replace(/(\r\n|\n|\r|\t)/gm,"")
        city: li.find('.location a').last().text()?.replace(/(\r\n|\n|\r|\t)/gm,"")
        startDate: li.find('.dtstart').attr('title')
        endDate: li.find('.dtend').attr('title') || li.find('.dtstart').attr('title')
        tags: tags.map (i, tag) ->
          $(tag).html()
      }
    cb(error, events)

scrape = (year, cb) ->
  loadURLs year, (err, urls) ->
    batch = new Batch
    for url in urls
      do (url) ->
        batch.push (done) ->
          do(done)->
            loadEvents(url, done)
    
    batch.on "progress", (e) ->
      console.log('progress', e.percent)
    batch.end (err, urls) ->
      cb(err, urls.concat.apply([], urls))

scrape new Date().getFullYear(), (err, events) ->
  fs.writeFileSync('events.json', JSON.stringify(events, null, 2) + '\n');
  console.log 'saved to events.json'
  require './jsonparse.coffee'

