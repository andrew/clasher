//A script to modify the towns as the country is selected such that it becomes impossible to select a town outside that country.
//Script file for code which is in the index.ejs and free.ejs files.
var id = 'countries';
//id of country dropdown
var towns = 'towns';
//id of towns dropdown
var tags = 'tagged';
//id of tags dropdown
var countryArr =  <%-cityMap%>;
var tagArr =  <%-tagsMap%>;
if (countryArr != null && tagArr != null) {
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
			var thing = document.createElement("option");
			thing.textContent = selectedTags[i];
			document.getElementById(tags).appendChild(thing);
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
				var thing = document.createElement("option");
				thing.textContent = selectedCount[i];
				document.getElementById(towns).appendChild(thing);
				tagsToPush = arrayUnique(tagsToPush.concat(tagArr[selectedCount[i]]));
			}
			//		console.log(tagsToPush);
			tagsToPush = tagsToPush.sort();
			document.getElementById(tags).innerHTML = "<option></option>"
			for (var i in tagsToPush) {
				var thing = document.createElement("option");
				thing.textContent = tagsToPush[i];
				document.getElementById(tags).appendChild(thing);
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

}

function arrayUnique(array) {
	var a = array.concat();
	for (var i = 0; i < a.length; ++i) {
		for (var j = i + 1; j < a.length; ++j) {
			if (a[i] === a[j])
				a.splice(j--, 1);
		}
	}

	return a;
};

function contains(a, obj) {
	for (var i = 0; i < a.length; i++) {
		if (a[i] == obj) {
			return true;
		}
	}
	return false;
}

