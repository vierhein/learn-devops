import os
import requests
import json
import re

TOKEN = os.getenv("TOKEN")
HEADERS = {'Authorization': f'Bearer {TOKEN}'}
json_file_path = 'output.txt'

def get_data():
    with open(json_file_path, "w") as f:
        pass
    for i in range(1, 15):
        repo_url = "https://api.github.com/repos/chromium/chromium/tags?page={i}"
        response = requests.get(repo_url, headers=HEADERS)
        json_data = response.json()
        with open(json_file_path, "a") as file:
            json.dump(json_data, file)
        return json_data

def get_position():
    new_json = {
        "linux64": {}
    }  
    with open(json_file_path, 'r') as file:
        json_data = json.load(file)
    for entry in json_data:
        version = entry.get('name', '')
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
                        position = match.group(1)
                        # print(position)
                        def add_version(new_json, version, position):
                            new_json["linux64"][version] = {
                                "position": position
                            }
                        add_version(new_json, version, position)

                    else:
                        print("Pattern not found.")

                else:
                    print(f"Failed to fetch commit information. Status code: {response.status_code}")

            except requests.exceptions.RequestException as e:
                print(f"Error during request: {e}")
        else:
            print("Commit URL not found in the JSON data.")
    with open('new.json', "w") as json_file:
        json.dump(new_json, json_file, indent=4)


get_data()
get_position()