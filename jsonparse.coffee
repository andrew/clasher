
#A script to modify the towns as the country is selected such that it becomes impossible to select a town outside that country.

#id of country dropdown

#id of towns dropdown
contains = (a, obj) ->
  i = 0

  while i < a.length
    return true  if a[i] is obj
    i++
  false
fs = require("fs")
eventJson = require("./events.json")
countryArr = []
tagArr = []
i = 0

while i < eventJson.length
  countToUse = eventJson[i].country
  if countToUse.length > 0
    countryArr[countToUse] = new Array()  if eventJson[i].country of countryArr is false
    countryArr[countToUse].push eventJson[i].city  if contains(countryArr[countToUse], eventJson[i].city) is false
    tagArr[eventJson[i].city] = new Array()  if tagArr.hasOwnProperty(eventJson[i].city) is false
    z = 0

    while z < eventJson[i].tags.length
      tagArr[eventJson[i].city].push eventJson[i].tags[z]  if contains(tagArr[eventJson[i].city], eventJson[i].tags[z]) is false
      z++
  if i is eventJson.length - 1
    count = {}
    tag = {}
    countryArr.sort()
    for k of countryArr
      countryArr[k].sort
      count[k] = countryArr[k]
    tagArr.sort()
    for k of tagArr
      tagArr[k].sort
      tag[k] = tagArr[k]
    fs.writeFile "countryCities.json", JSON.stringify(count, null, 4), (err) ->
      if err
        console.log "Error writing country -> city mapping!"
      else
        console.log "country -> city mapping saved!"

    fs.writeFile "cityTags.json", JSON.stringify(tag, null, 4), (err) ->
      if err
        console.log "Error writing city -> tag mapping!"
        require("./server.coffee");
      else
        console.log "city -> tag mapping saved!"
        require("./server.coffee");
  i++