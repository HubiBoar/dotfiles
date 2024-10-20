echo "\n --> Git and Github SSH setup...\n"
chmod 400 ~/.ssh
gh auth login --with-token < ~/.ssh/.githubtoken

echo " => CDE Is Running... (Ctrl-c to Detach. './start.sh profile' to Attach)"
sleep infinity
