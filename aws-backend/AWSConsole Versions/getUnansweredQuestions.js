const PEOPLE_TABLE = 'People';
const QUESTIONS_TABLE = 'Questions';

const AWS = require('aws-sdk');
var documentClient = new AWS.DynamoDB.DocumentClient();

exports.handler = (event, context, callback) => {
    var getParams = {
		TableName : PEOPLE_TABLE,
		Key: { personId : event.arguments.input.personId }
	};
	var person;
	documentClient.get(getParams, function(err, data) {
		if (err) {
			console.log(err);
			callback(null, []);
		} else {
		    person = data.Item;
		}
	});
	var queryParams = {
        TableName: QUESTIONS_TABLE,
        KeyConditionExpression: 'lang = :lang',
        FilterExpression: '#type = :type',
        ExpressionAttributeNames: {
            '#type': "type"
        },
        ExpressionAttributeValues: {
            ':lang': event.arguments.input.lang,
            ':type': event.arguments.input.type
        }
	};
	documentClient.query(queryParams, function(err, data) {
	    if (err) {
	        console.log(err);
	        callback(null, []);
	    } else {
	        var questions = processResults(person, data.Items);
	        callback(null, questions);
	    }
	})
};

function processResults(personObj, questionsList) {
    var unansweredQuestions = [];
    if (!(personObj.hasOwnProperty("answers"))) {
        return questionsList;
    }
    var i;
    for (i=0; i<questionsList.length; i++) {
        if (!(questionsList[i].questionId in personObj.answers)) {
            unansweredQuestions.push(questionsList[i]);
        }
    }
    return unansweredQuestions;
}
