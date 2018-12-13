package com.amazonaws.lambda.demo;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.BatchGetItemOutcome;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.TableKeysAndAttributes;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.ScanRequest;
import com.amazonaws.services.dynamodbv2.model.ScanResult;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent;
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent.DynamodbStreamRecord;

public class UpdateCScoresHandler implements RequestHandler<DynamodbEvent, Integer> {

	private AmazonDynamoDB client;
	private DynamoDB dynamoDB;
	private Context context;
	
    @Override
    public Integer handleRequest(DynamodbEvent event, Context context) {
    	
    	this.context = context;
        context.getLogger().log("Received event: " + event);

        // Checking which person has modified answers.
        Set<String> personsModified = new HashSet<String> ();
        for (DynamodbStreamRecord record : event.getRecords()) {
        	context.getLogger().log("Inside for loop");
            context.getLogger().log(record.getEventID());
            context.getLogger().log(record.getEventName());
            context.getLogger().log(record.getDynamodb().toString());
            
            if ("MODIFY".equals(record.getEventName())) {
            	Map<String, AttributeValue> newImage = record.getDynamodb().getNewImage();
            	Map<String, AttributeValue> oldImage = record.getDynamodb().getOldImage();
            	String personId = newImage.get("personId").getS();
            	if (!personsModified.contains(personId) && answersChanged(newImage, oldImage)) {
            		context.getLogger().log("Inside modified");
            		personsModified.add(personId);
            	}
            }
        }
        
        client = AmazonDynamoDBClientBuilder.standard().build();
        dynamoDB = new DynamoDB(client);
        String peopleTableName = "People";
        
        try {
        	TableKeysAndAttributes batchGetParams = new TableKeysAndAttributes(peopleTableName);
        	batchGetParams.addHashOnlyPrimaryKeys("personId", personsModified.toArray());
        	batchGetParams.withProjectionExpression("personId, answers");
        	
        	BatchGetItemOutcome outcome = dynamoDB.batchGetItem(batchGetParams);
        	List<Item> modifiedPeople = outcome.getTableItems().get(peopleTableName);
        	List<Map<String, AttributeValue>> allPeople;
        	
        	Map<String, AttributeValue> lastKey = null;
        	do {
        		ScanRequest scanReq = new ScanRequest()
        				.withTableName(peopleTableName)
        				.withProjectionExpression("personId, answers");
        		if (lastKey != null) {
        			scanReq.withExclusiveStartKey(lastKey);
        		}
        		ScanResult scanRes = client.scan(scanReq);
        		lastKey = scanRes.getLastEvaluatedKey();
        		
        		allPeople = scanRes.getItems();
        		updateCScores(modifiedPeople, allPeople);
        	} while (lastKey != null);
        } catch (Exception e) {
        	System.err.println(e.getMessage());
        }
        
        return event.getRecords().size();
    }
    
    private void updateCScores(List<Item> modifiedPeople, List<Map<String, AttributeValue>> allPeople) {
    	for (int i = 0; i < modifiedPeople.size(); i++) {
    		for (int j = 0; j < allPeople.size(); j++) {
    			Item modifiedPerson = modifiedPeople.get(i);
    			Map<String, AttributeValue> otherPerson = allPeople.get(j);
    			if (!((String) modifiedPerson.get("personId")).equals((String) otherPerson.get("personId").getS()) &&
    					otherPerson.containsKey("answers")) {
    						double cScore = calculateCScore(modifiedPerson, otherPerson);
    						saveScore(cScore, (String) modifiedPerson.get("personId"), otherPerson.get("personId").getS());
    						saveScore(cScore, otherPerson.get("personId").getS(), (String) modifiedPerson.get("personId"));
    					}
    		}
    	}
    }
    
    private void saveScore(double score, String partitionKey, String sortKey) {
    	try {
    		Table relationsTable = dynamoDB.getTable("PeopleRelations");
    		Item relationItem = relationsTable.getItem("myId", partitionKey, "theirId", sortKey);
    		if (relationItem != null) {
    			Map<String, String> expressionAttributeNames = new HashMap<String, String>();
    			expressionAttributeNames.put("#a", "cScore");
    			Map<String, Object> expressionAttributeValues = new HashMap<String, Object>();
    			expressionAttributeValues.put(":x", score);
    			relationsTable.updateItem("myId", partitionKey,
    					"theirId", sortKey, "set #a = :x", expressionAttributeNames,
    					expressionAttributeValues);
    		} else {
    			Item newItem = new Item()
    					.withPrimaryKey("myId", partitionKey, "theirId", sortKey)
    					.withInt("relationType", -1).withDouble("cScore", score);
    			relationsTable.putItem(newItem);
    		}
    	} catch (Exception e) {
    		System.err.println(e.getMessage());
    	}
    	
    }
    
    private double calculateCScore(Item modifiedPerson, Map<String, AttributeValue> otherPerson) {
    	return 1.0;
    }
    
    
    private boolean answersChanged(Map<String, AttributeValue> newImage, Map<String, AttributeValue> oldImage) {
    	if (!newImage.containsKey("answers")) {
    		return false;
    	}
    	else if (!oldImage.containsKey("answers"))
    		return true;
    	Map<String, AttributeValue> newAnswers = newImage.get("answers").getM();
    	Map<String, AttributeValue> oldAnswers = oldImage.get("answers").getM();
    	if (newAnswers.size() != oldAnswers.size())
    		return true;
    	for (String questionId : newAnswers.keySet()) {
    		if (!oldAnswers.containsKey(questionId)) {
    			return true;
    		} else {
    			List<AttributeValue> newAnswersList = newAnswers.get(questionId).getL();
    			List<AttributeValue> oldAnswersList = oldAnswers.get(questionId).getL();
    			if (newAnswersList.size() != oldAnswersList.size()) {
    				return true;
    			}
    			else {
    				for (int i = 0; i < newAnswersList.size(); i++) {
    					String newAnswer = newAnswersList.get(i).getN();
    					String oldAnswer = newAnswersList.get(i).getN();
    					if (newAnswer != oldAnswer) {
    						return true;
    					}
    				}
    			}
    		}
    	}
    	return false;
    }
}