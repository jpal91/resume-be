import sys
import boto3

def update_api(url):
    ddb = boto3.resource('dynamodb')
    table = ddb.Table('resume_viz_count')
    key = {'Id': 'ApiUrl'}

    current = table.update_item(
        Key=key,
        UpdateExpression='SET CurrentUrl = :u',
        ExpressionAttributeValues={':u': f'{url}'},
        ReturnValues='UPDATED_NEW'
    )
    
    return current

if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit('Not enough args')

    update_api(sys.argv[1])
    