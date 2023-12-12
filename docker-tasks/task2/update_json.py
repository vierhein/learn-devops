import os
import requests
import json
import re

TOKEN = os.getenv("TOKEN")
HEADERS = {'Authorization': f'Bearer {TOKEN}'}


def get_data():
    repo_url = "https://api.github.com/repos/chromium/chromium/tags?page=15"
    response = requests.get(repo_url, headers=HEADERS)
    json_data = response.json()
    with open('output.txt', "w") as file:
        json.dump(json_data, file)
    return json_data

def get_position():
    json_data = get_data()
    for entry in json_data:
        name_value = entry.get('name', '')
        commit_url = entry.get('commit', {}).get('url', '')

        if commit_url:
            try:
                response = requests.get(commit_url, headers=HEADERS)

                if response.status_code == 200:
                    commit_info = response.json()
                    info = commit_info.get('commit', {}).get('message', '')

                    pattern = r"Cr-Branched-From: .+?@{#(\d+)}"
                    match = re.search(pattern, info)
                    
                    if match:
                        # Extract the numbers after "refs/heads/main@{#}"
                        result = match.group(1)
                        print(result)
                    else:
                        print("Pattern not found.")

                else:
                    print(f"Failed to fetch commit information. Status code: {response.status_code}")

            except requests.exceptions.RequestException as e:
                print(f"Error during request: {e}")
        else:
            print("Commit URL not found in the JSON data.")

get_position()