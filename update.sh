#!/bin/bash
cd "$(dirname "$0")"
date_str=$(date +%Y%m%d)

# Update manifest.json
python3 -c '
import os
import json

rrd_files = []
for root, dirs, files in os.walk("."):
    for file in files:
        if file.endswith(".rrd"):
            path = os.path.relpath(os.path.join(root, file), ".")
            rrd_files.append(path)

rrd_files.sort()

with open("manifest.json", "w") as f:
    json.dump(rrd_files, f, indent=2)
'

git add .

if [ -n "$(git status --porcelain)" ]; then
    export GIT_COMMITTER_NAME="[bot]"
    export GIT_COMMITTER_EMAIL="bot@noreply.sti"
    git commit --author="[bot] <bot@noreply.sti>" -m "update $date_str"
    git push origin main
else
    echo "No changes to commit."
fi

