def handler(event, context):
    expected_answer = event["request"]["privateChallengeParameters"].get("secretLoginCode")
    user_answer = event["request"].get("challengeAnswer")

    event["response"]["answerCorrect"] = (user_answer == expected_answer)

    return event
