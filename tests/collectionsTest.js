//this is a test to see if the scraper output has been changed such that the additional creations are not collected.
//returns false if there is a problem, true if everything is in working order.
module.exports = (function(){var fullJson = require("../events.json");
var borked = false;
for(var items in fullJson){
	if(!fullJson[items].hasOwnProperty("country")){
		borked = true;
	}
	else if(!fullJson[items].hasOwnProperty("city")){
		borked = true;
	}
	else if(!fullJson[items].hasOwnProperty("tags")){
		borked = true;
	} 
	
	else if(!Object.prototype.toString.call(fullJson[items].tags) === '[object Array]'){
		borked = true;	
	} 
}
console.log("Test status :"+ !borked)
return !borked;
})();
