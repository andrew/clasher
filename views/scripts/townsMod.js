//A script to modify the towns as the country is selected such that it becomes impossible to select a town outside that country.

var id = 'countries';
//id of country dropdown
var towns = 'towns';
//id of towns dropdown
var tags = 'tagged';
//id of tags dropdown
var countryArr = [];
var tagArr = [];
for (var i = 0; i < eventJson.length; i++) {
	var countToUse = eventJson[i].country;
	if (countToUse.length > 0) {
		if (eventJson[i].country in countryArr == false) {
			countryArr[countToUse] = new Array();
		}
		if (contains(countryArr[countToUse], eventJson[i].city) == false) {
			countryArr[countToUse].push(eventJson[i].city);
		}
		if (contains(tagArr, eventJson[i].city) == false) {
			tagArr[eventJson[i].city] = new Array();
		}
		for (var z in eventJson[i].tags) {
			if (contains(tagArr[eventJson[i].city], eventJson[i].tags[z]) == false) {
				tagArr[eventJson[i].city].push(eventJson[i].tags[z])
			}
		}
	}
}

if (document.getElementById(towns).value != "") {
	var citSel = document.getElementById(towns).value;
	editor();
	document.getElementById(towns).value = citSel;
	tagEditor();

} else if (document.getElementById(id).value != "") {
	editor();
}

document.getElementById(id).addEventListener("change", function() {
	editor();
});

document.getElementById(towns).addEventListener("change", function() {
	tagEditor();
});

function tagEditor() {
	var selectedTags = tagArr[document.getElementById(towns).value].sort();
	document.getElementById(tags).innerHTML = ""
	document.getElementById(tags).innerHTML = "<option></option>"

	for (var i in selectedTags) {
		document.getElementById(tags).innerHTML += "<option>" + selectedTags[i] + "</option>";
	}
}

function editor() {
	console.log(document.getElementById(id).value.length);
	if (document.getElementById(id).value.length > 0) {
		var selectedCount = countryArr[document.getElementById(id).value].sort();
		var tagsToPush = new Array();
		document.getElementById(towns).innerHTML = ""
		document.getElementById(towns).innerHTML = "<option></option>"

		for (var i in selectedCount) {
			document.getElementById(towns).innerHTML += "<option>" + selectedCount[i] + "</option>";
			tagsToPush = tagsToPush.concat(tagArr[selectedCount[i]]);
		}
		console.log(tagsToPush);
		tagsToPush = tagsToPush.sort();
		document.getElementById(tags).innerHTML = "<option></option>"
		for (var i in tagsToPush) {
			document.getElementById(tags).innerHTML += "<option>" + tagsToPush[i] + "</option>"
		}
	} else {
		console.log("tagging");
		var totalTags = [];
		var totalCounts = [];
		for (var i in tagArr) {
			for (var z in tagArr[i]) {
				if (contains(totalTags, tagArr[i][z]) == false) {
					totalTags.push(tagArr[i][z]);
				}
			}
			totalCounts.push(i);
		}
		totalTags = totalTags.sort();
		totalCounts = totalCounts.sort();
		console.log(totalTags);
		console.log(totalCounts);
		document.getElementById(tags).innerHTML = "<option></option>"
		for (var i in totalTags) {
			var thing = document.createElement("option");
			thing.textContent = totalTags[i];
			document.getElementById(tags).appendChild(thing);
		}
		document.getElementById(towns).innerHTML = "<option></option>"
		for (var i in totalCounts) {
			var thing = document.createElement("option");
			thing.textContent = totalCounts[i];
			document.getElementById(towns).appendChild(thing);
		}
	}
}

function contains(a, obj) {
	for (var i = 0; i < a.length; i++) {
		if (a[i] === obj) {
			return true;
		}
	}
	return false;
}
