import pandas as pd
import requests
import json

df = pd.read_csv('yourfile.csv')

api_key = 'bee32fdd-8c3a-4c3c-b5c0-d5a4437ddd5c'

for index, row in df.iterrows():
    part_number = row['MPN']

    headers = {
        'Authorization': 'Bearer {}'.format(api_key),
    }

    response = requests.get('https://api.mouser.com/api/v1/search/partnumber?searchBy=partnumber&partnumber={}'.format(part_number), headers=headers)

    if response.status_code == 200:
        result = json.loads(response.text)
        print(result)
    else:
        print('Failed to fetch part number: {}'.format(part_number))
