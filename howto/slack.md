### Post to Slack via API

```sh
curl -X POST \
-H 'Content-Type: application/json' \
-d '{
   "attachments":[
      {
         "fallback":"fallback text",
         "color":"#D00000",
         "fields":[
            {
               "title":"hello world",
               "value":"hello world",
               "short":false
            }
         ]
      }
   ]
}' \
'see secrets.md for url'
```

---

### List emails from all users in a Slack channel

```py
import requests

SLACK_API_TOKEN='*** CENSORED ***'

CHANNEL_ID = '*** find out from browser url **'


members = requests.get(
    f'https://slack.com/api/conversations.members?token={SLACK_API_TOKEN}&channel={CHANNEL_ID}'
).json()['members']

users_list = requests.get(
    f'https://slack.com/api/users.list?token={SLACK_API_TOKEN}'
).json()['members']

emails = list()

for user in users_list:
    if "email" in user['profile'] and user['id'] in members:
        emails.append(user['profile']['email'])

for email in sorted(emails):
    print(email)
```
