// Can update multiple person-candidate pairs at the same time, person don't have to be the same.
const TABLENAME = 'PeopleRelations';
const PARTITION_KEY = 'myId';
const SORT_KEY = 'theirId';
const RELATION_ATTRIBUTE = 'relationType';
const AWS = require('aws-sdk');
var documentClient = new AWS.DynamoDB.DocumentClient();

exports.handler = (event, context, callback) => {
	var candidates = event.arguments.input;
	var i;
	var updateSuccess = true;
	for (i=0; i<candidates.length; i++)  {
		let candidate = candidates[i];
		let getParams = {
			TableName : TABLENAME,
			Key: {
				myId: candidates[i].candidateId,
				theirId: candidates[i].personId
			}
		};
		documentClient.get(getParams, function(err, data) {
			if (err) {
				console.log(err);
				updateSuccess = false;
			} else {
				var relationship = 0;
				console.log(event.arguments.input[i]);
				if (candidate.likedByMe) {
					relationship = 1;
				}
				if (data.hasOwnProperty('Item') && data.Item.relationship == 1 && relationship == 1) {
					// We both like each other, so connect
					let updateParams = {
						TableName : TABLENAME,
						Key: {
							myId: candidate.candidateId,
							theirId: candidate.personId
						},
						UpdateExpression: 'set #a = :x',
						ExpressionAttributeNames: {'#a' : RELATION_ATTRIBUTE},
						ExpressionAttributeValues: {':x' : 2 }
					};
					documentClient.update(updateParams, function(err, data) {
						if (err) {
							console.log(err);
							updateSuccess = false;
						}
					});
					let putParams = {
						TableName : TABLENAME,
						Item: {
							myId: candidate.personId,
							theirId: candidate.candidateId,
							relationType: 2
						}
					};
					documentClient.put(putParams, function(err, data) {
						if (err) {
							console.log(err);
							updateSuccess = false;
						}
					});	
				} else {	
					var params = {
						TableName : TABLENAME,
						Item: {
							myId: candidate.personId,
							theirId: candidate.candidateId,
							relationType: relationship
						}
					};
					documentClient.put(params, function(err, data) {
						if (err) {
							console.log(err);
							updateSuccess = false;
						}
					});
				}	
			}
		});
	}
	callback(null, updateSuccess);
};

