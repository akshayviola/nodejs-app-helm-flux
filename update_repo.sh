#!/bin/bash

# Navigate to the directory containing the Git repository
cd /home/user/Desktop/2Clouds /Helm_Jenkins_Task/nodejs-app-helm-flux

# Fetch the latest changes from the remote repository
git fetch origin

# Merge the changes from the remote main branch
git merge origin/main

# Check if the merge was successful
if [ $? -eq 0 ]; then
    echo "Merge completed successfully."
else
    echo "Merge failed. Please resolve conflicts."
    exit 1
fi
