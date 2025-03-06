def handler(event, context):

    session = event.get("request", {}).get("session", [])

    if any(attempt.get("challengeName") != "CUSTOM_CHALLENGE" for attempt in session):
        # We only accept custom challenges; fail auth
        event["response"] = {
            "issueTokens": False,
            "failAuthentication": True
        }
    elif len(session) >= 3 and session[-1].get("challengeResult") is False:
        # The user provided a wrong answer 3 times; fail auth
        event["response"] = {
            "issueTokens": False,
            "failAuthentication": True
        }
    elif (
        len(session) > 0
        and session[-1].get("challengeName") == "CUSTOM_CHALLENGE"
        and session[-1].get("challengeResult") is True
    ):
        # The user provided the right answer; succeed auth
        event["response"] = {
            "issueTokens": True,
            "failAuthentication": False
        }
    else:
        # The user did not provide a correct answer yet; present challenge
        event["response"] = {
            "issueTokens": False,
            "failAuthentication": False,
            "challengeName": "CUSTOM_CHALLENGE"
        }

    return event
