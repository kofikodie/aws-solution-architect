import json
import boto3
import os

ssm = boto3.client('ssm', region_name="eu-west-1")

def lambda_handler():
    db_url = ssm.get_parameters(Names=["/app/db/url"])
    print(db_url)   
    db_password = ssm.get_parameters(Names=["/app/db/password"], WithDecryption=True)
    print(db_password)
    return "worked"

if __name__ == "__main__":
    res = lambda_handler()
    print(res)