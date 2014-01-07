sudo su rosmirror --command 'rsync -az wiki.ros.org::wiki_mirror /mirror/wiki.ros.org --bwlimit=200 --copy-unsafe-links --delete -n --stats'

echo ^^^^^^^^
echo Progress on the wiki

sudo su rosmirror --command 'rsync -az docs.ros.org::mirror /mirror/docs.ros.org --bwlimit=200 --copy-unsafe-links --delete -n --stats'

echo ^^^^^^^^
echo Progress on the docs



