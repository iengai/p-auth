import os
import boto3
import random

ses = boto3.client('ses')

def handler(event, context):
    if not event.get("request", {}).get("session"):
        secret_login_code = "".join(random.choices("0123456789", k=6))
        send_email(event["request"]["userAttributes"]["email"], secret_login_code)
    else:
        previous_challenge = event["request"]["session"][-1]
        secret_login_code = previous_challenge["challengeMetadata"].split("CODE-")[-1]

    event["response"]["publicChallengeParameters"] = {"email": event["request"]["userAttributes"]["email"]}
    event["response"]["privateChallengeParameters"] = {"secretLoginCode": secret_login_code}
    event["response"]["challengeMetadata"] = f"CODE-{secret_login_code}"
    return event

def send_email(email_address, secret_login_code):
    params = {
        "Destination": {"ToAddresses": [email_address]},
        "Message": {
            "Body": {
                "Html": {
                    "Charset": "UTF-8",
                    "Data": f"<html><body><p>This is your secret login code:</p><h3>{secret_login_code}</h3></body></html>"
                },
                "Text": {
                    "Charset": "UTF-8",
                    "Data": f"Your secret login code: {secret_login_code}"
                }
            },
            "Subject": {
                "Charset": "UTF-8",
                "Data": "Your secret login code"
            }
        },
        "Source": os.environ["SOURCE_EMAIL_ADDRESS"],
    }
    ses.send_email(**params)
