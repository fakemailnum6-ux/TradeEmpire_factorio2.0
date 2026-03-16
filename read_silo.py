import urllib.request
url = 'https://raw.githubusercontent.com/wube/factorio-data/master/core/lualib/silo-script.lua'
content = urllib.request.urlopen(url).read().decode('utf-8')
lines = content.split('\n')
for i, line in enumerate(lines):
    if 'remote.add_interface' in line:
        for j in range(max(0, i-5), min(len(lines), i+20)):
            print(f"L{j}: {lines[j]}")
