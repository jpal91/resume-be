import json
import boto3

def lambda_handler(event, context):
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