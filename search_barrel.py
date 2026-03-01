import urllib.request
import re

url = "https://raw.githubusercontent.com/wube/factorio-data/master/base/prototypes/item.lua"
try:
    content = urllib.request.urlopen(url).read().decode('utf-8')
    if "empty-barrel" in content:
        print("empty-barrel found in item.lua")
        match = re.search(r'\{[^}]*name\s*=\s*"empty-barrel"[^}]*type\s*=\s*"([^"]+)"', content)
        if match:
            print(f"type is {match.group(1)}")
        else:
            match2 = re.search(r'type\s*=\s*"([^"]+)"[^}]*name\s*=\s*"empty-barrel"', content)
            if match2:
                 print(f"type is {match2.group(1)}")
            else:
                 print("Could not find type")
except Exception as e:
    print('Failed', e)
