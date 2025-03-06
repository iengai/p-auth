def handler(event, context):
    print(f"User {event['userName']} confirmed.")
    return event
