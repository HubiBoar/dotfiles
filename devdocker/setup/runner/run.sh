echo "\n --> Git and Github SSH setup...\n"
chmod 777 ~/.ssh
gh auth login --with-token < ~/.ssh/.githubtoken

echo " --> CDE Is Running... (Ctrl-c to Detach)"
sleep infinity
