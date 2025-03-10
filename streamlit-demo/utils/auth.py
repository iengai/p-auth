import os

import boto3
import jwt
import requests
from jwt.algorithms import RSAAlgorithm
from dotenv import load_dotenv

# Cognito 配置
load_dotenv()
COGNITO_REGION = "ap-northeast-1"
USER_POOL_ID = os.getenv("USER_POOL_ID")
CLIENT_ID = os.getenv("COGNITO_CLIENT_ID")

cognito_client = boto3.client("cognito-idp", region_name=COGNITO_REGION)


# Step 1: 发起 `initiate-auth` 请求
def initiate_auth(username):
    print("USER_POOL_ID:", USER_POOL_ID)
    response = cognito_client.initiate_auth(
        ClientId=CLIENT_ID,
        AuthFlow="CUSTOM_AUTH",
        AuthParameters={"USERNAME": username}
    )
    print("Received Challenge:", response)
    return response["Session"]


# Step 2: 用户输入 OTP 并验证
def respond_to_auth_challenge(username, otp, session):
    response = cognito_client.respond_to_auth_challenge(
        ClientId=CLIENT_ID,
        ChallengeName="CUSTOM_CHALLENGE",
        Session=session,
        ChallengeResponses={
            "USERNAME": username,
            "ANSWER": otp
        }
    )
    return response


# Step 3: 解码 ID Token 以获取用户信息
def get_cognito_public_keys():
    """ 获取 Cognito JWKS 公钥 """
    jwks_url = f"https://cognito-idp.{COGNITO_REGION}.amazonaws.com/{USER_POOL_ID}/.well-known/jwks.json"
    jwks = requests.get(jwks_url).json()
    public_keys = {}
    for key in jwks['keys']:
        kid = key['kid']
        public_keys[kid] = RSAAlgorithm.from_jwk(key)
    return public_keys


def verify_id_token(id_token):
    """ 验证 ID Token 是否有效 """
    public_keys = get_cognito_public_keys()
    unverified_header = jwt.get_unverified_header(id_token)
    kid = unverified_header['kid']

    if kid not in public_keys:
        raise ValueError("Invalid ID Token: Key ID not found!")

    decoded_token = jwt.decode(id_token, public_keys[kid], algorithms=["RS256"], audience=CLIENT_ID)
    return decoded_token


# Step 4: 通过 Refresh Token 刷新 Access Token
def refresh_auth(refresh_token):
    response = cognito_client.initiate_auth(
        ClientId=CLIENT_ID,
        AuthFlow="REFRESH_TOKEN_AUTH",
        AuthParameters={"REFRESH_TOKEN": refresh_token}
    )
    return response["AuthenticationResult"]

#
# # 执行流程
# username = "iamibe.kai+0603@gmail.com"
#
# # Step 1: 发送 `initiate-auth` 请求
# session = initiate_auth(username)
#
# # Step 2: 用户输入 OTP 进行验证
# otp = input("Enter OTP: ")
# auth_result = respond_to_auth_challenge(username, otp, session)
#
# if "AuthenticationResult" in auth_result:
#     id_token = auth_result["AuthenticationResult"]["IdToken"]
#     access_token = auth_result["AuthenticationResult"]["AccessToken"]
#     refresh_token = auth_result["AuthenticationResult"]["RefreshToken"]
#
#     print("\n✅ Authentication Successful!")
#     print(f"ID Token: {id_token[:50]}...")  # 只显示前50字符
#     print(f"Access Token: {access_token[:50]}...")
#
#     # Step 3: 验证 ID Token
#     decoded_id_token = verify_id_token(id_token)
#     print("\nDecoded ID Token:", decoded_id_token)
#
#     # Step 4: 刷新 Token
#     new_tokens = refresh_auth(refresh_token)
#     print("\n🔄 Refreshed Tokens:", new_tokens)
# else:
#     print("\n❌ Authentication Failed!")
