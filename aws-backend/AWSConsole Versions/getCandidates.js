// The design of this code assumes that a person has to answer at least one question
// to create entries in the PeopleRelations table, in order for him/her to be able
// to see results or show up in others' results.
const PEOPLE_TABLE = 'People';
const RELATION_TABLE = 'PeopleRelations';
const INDEX_NAME = 'Location';
const PARTITION_KEY = 'myId';
const SORT_KEY = 'theirId';
const AWS = require('aws-sdk');
var documentClient = new AWS.DynamoDB.DocumentClient();

exports.handler = (event, context, callback) => {
	var returnObj = { 'lastEvaluatedKey' : '', 'candidates' : [] };

	// Query the PeopleRelations table to get all the candidates with myId = personId
	let params = {
		TableName : RELATION_TABLE,
		KeyConditionExpression: '#key = :pkey',
		FilterExpression: 'relationType < :value',
		ExpressionAttributeNames: { '#key' : PARTITION_KEY },
		ExpressionAttributeValues: {
		    ':pkey' : event.arguments.input.personId,
		    ':value' : 0
		} 
	};
	if (event.arguments.input.lastEvaluatedKey != '') {
	    params['ExclusiveStartKey'] = event.arguments.input.lastEvaluatedKey;
	}
	documentClient.query(params, function(err, data) {
		if (err) {
			console.log(err);
			callback(null, returnObj);
		} else {
		    if (data.hasOwnProperty('lastEvaluatedKey')) {
		        returnObj.lastEvaluatedKey = data.lastEvaluatedKey;
		    }
		    if (!data.hasOwnProperty('Items') || data.Items.length < 1) {
		    	callback(null, returnObj);
		    }
		    let items = data.Items;
			var keys = [];
			var cScoreMap = {};
			var i;
			for (i=0; i<items.length; i++) {
				var keyMap = {};
				keyMap['personId'] = items[i].theirId;
				keys.push(keyMap);
				cScoreMap[items[i].theirId] = items[i].cScore;
			}
			// Get all the items in People table corresponding to above candidates' personId's
			let batchParams = {
				RequestItems : {
					People : {
						Keys : keys,
						ProjectionExpression: 'personId, profileBase'
					}
				}
			};
			documentClient.batchGet(batchParams, function(err, data) {
				if (err) {
					console.log(err);
					callback(null, returnObj);
				} else {
				    var j = 0;
				    var nearbyCandidates = [];
				    var allOtherCandidates = [];
					for (j=0; j<data.Responses.People.length; j++) {
					    let candidate = data.Responses.People[j];
					    candidate['cScore'] = cScoreMap[candidate.personId];
					    if (candidate.profileBase.location == event.arguments.input.location) {
					        nearbyCandidates.push(candidate);
					    } else {
					        allOtherCandidates.push(candidate);
					    }
					}
					//Return all nearby candidates first, then return all other candidates. Both
					//are sorted in descending cScore.
					nearbyCandidates = nearbyCandidates.sort(compare);
					allOtherCandidates = allOtherCandidates.sort(compare);
					returnObj.candidates.push(...nearbyCandidates);
					returnObj.candidates.push(...allOtherCandidates);
					callback(null, returnObj);
				}
			});
		}
	});
};

function compare(a, b) {
	//To be used only for comparing two items of PeopleRelations table.
	if (a.cScore < b.cScore) {
		return -1;
	} else if (a.cScore > b.cScore) {
		return 1;
	} else {
		return 0;
	}
}
