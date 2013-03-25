checks = require('./check')

start = new Date('2013-01-01')
end = new Date('2013-12-31')
city = null
county = null
tag = null

console.log checks.emptyDays(start, end, county, city, tag)
console.log checks.checkDate('2013-01-01', county, city, tag)