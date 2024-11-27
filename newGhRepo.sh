#! /bin/sh

# First, check if GITHUB_TOKEN environment variable exists
if [ -z "$GITHUB_TOKEN" ]; then
    # If it doesn't exist, prompt the user for their token
    echo "Please enter your GitHub Personal Access Token:"
    read -r GITHUB_TOKEN
fi

repoName=$1
while [ -z "$repoName" ]
do
    echo 'Provide a repository name'
    read -r -p $'Repository name:' repoName
done

echo "# $repoName" >> README.md
git init
git add .
git commit -m "First commit"

# Use the token from environment variable or user input
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user/repos -d '{"name": "'"$repoName"'", "private":false}'

GIT_URL=$(curl -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/Dhruvar27/"$repoName" | jq -r '.clone_url')

git branch -M main
git remote add origin "$GIT_URL"
git push -u origin main
