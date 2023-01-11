import json
import boto3

def get_visitors(event, context):
    ddb = boto3.resource('dynamodb')
    table = ddb.Table('resume_viz_count')
    
    item = table.get_item(
            Key={
                'Id': 'main'
            }
        )['Item']['v_count']
    
    return {
        'statusCode': 200,
        'body': json.dumps(int(item))
    }

def add_visitors(event, context):
    ddb = boto3.resource('dynamodb')
    table = ddb.Table('resume_viz_count')
    key = {'Id': 'main'}
    
    current = table.update_item(
        Key=key,
        UpdateExpression='SET v_count = v_count + :p',
        ExpressionAttributeValues={":p": 1},
        ReturnValues='UPDATED_NEW'
    )['Attributes']['v_count']
    
    return {
        'statusCode': 200,
        'body': json.dumps(int(current))
    }

def sub_visitors(event, context):
    ddb = boto3.resource('dynamodb')
    table = ddb.Table('resume_viz_count')
    key = {'Id': 'main'}
    
    current = table.update_item(
        Key=key,
        UpdateExpression='SET v_count = v_count - :p',
        ExpressionAttributeValues={":p": 1},
        ReturnValues='UPDATED_NEW'
    )['Attributes']['v_count']
    
    return {
        'statusCode': 200,
        'body': json.dumps(int(current))
    }