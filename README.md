# p-auth

## reference
https://github.com/aws-samples/amazon-cognito-passwordless-email-auth/tree/master/cognito

## cmds
### register
```
aws cognito-idp sign-up \
  --client-id {client-id} \
  --username {username/email} \
  --user-attributes Name=email,Value={email}
```

### init-auth
```
aws cognito-idp initiate-auth \
  --client-id {client-id} \
  --auth-flow CUSTOM_AUTH \
  --auth-parameters USERNAME={email}
```

### verify-auth
```
aws cognito-idp respond-to-auth-challenge \
  --client-id {client-id} \
  --challenge-name CUSTOM_CHALLENGE \
  --challenge-responses USERNAME=email,ANSWER={code} \
  --session {session}
```