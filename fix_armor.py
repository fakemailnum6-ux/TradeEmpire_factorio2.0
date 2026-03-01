import urllib.request
url = 'https://raw.githubusercontent.com/wube/factorio-data/master/base/prototypes/item.lua'
content = urllib.request.urlopen(url).read().decode('utf-8')
lines = content.split('\n')
for i, line in enumerate(lines):
    if 'power-armor-mk2' in line:
        print(f"L{i}: {line}")
