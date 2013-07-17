#this is a test to see if the scraper output has been changed such that the additional creations are not collected.
#returns false if there is a problem, true if everything is in working order.
module.exports = (->
  fullJson = require("../events.json")
  borked = false
  for items of fullJson
    unless fullJson[items].hasOwnProperty("country")
      borked = true
    else unless fullJson[items].hasOwnProperty("city")
      borked = true
    else unless fullJson[items].hasOwnProperty("tags")
      borked = true
    else borked = true  if not Object::toString.call(fullJson[items].tags) is "[object Array]"
  console.log "Test status :" + not borked
  not borked
)()