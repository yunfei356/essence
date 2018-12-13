const PEOPLE_TABLE = 'People';

const AWS = require('aws-sdk');
var documentClient = new AWS.DynamoDB.DocumentClient();

exports.handler = (event, context, callback) => {
	var params = {
		TableName : PEOPLE_TABLE,
		Key: { personId : event.arguments.input.personId }
	};
	
	documentClient.get(params, function(err, data) {
		if (err) {
			console.log(err);
			callback(null, false);
		} else {
			var answersMap = {};
			if (data.Item.hasOwnProperty('answers')) {
				answersMap = data.Item.answers
			};
			var i;
			var inputAnswers = event.arguments.input.answers;
			for (i = 0; i < inputAnswers.length; i++) {
				answersMap[inputAnswers[i].questionId] = inputAnswers[i].selectedAnswers;
			};
			var updateParams = {
				TableName: PEOPLE_TABLE,
				Key: { personId : event.arguments.input.personId },
				UpdateExpression: 'set answers = :answers',
				ExpressionAttributeValues: {':answers' : answersMap }
			};
			documentClient.update(updateParams, function(err, data) {
				if (err) {
					console.log(err);
					callback(null, false);
				}
			});
			callback(null, true);
		}
	});
};

