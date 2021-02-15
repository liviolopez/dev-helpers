#!/bin/bash

# Required jq command
# https://www.baeldung.com/linux/jq-command-json

### check all authors of commits
git log --all --format='%cN <%cE>' | sort -u
echo ''

authors=$'[
  {"wrong_email":"livio@wrong.com", "good_email":"livio@good.com", "author_name":"Livio"},
  {"wrong_email":"john@wrong.com", "good_email":"john@good.com", "author_name":"John"},
  {"wrong_email":"danny@wrong.com", "good_email":"danny@good.com", "author_name":"Danny"}
]'

git_filter=$'if [ "$GIT_COMMITTER_EMAIL" = "$WRONG_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$AUTHOR_NAME"
    export GIT_COMMITTER_EMAIL="$GOOD_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$WRONG_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$AUTHOR_NAME"
    export GIT_AUTHOR_EMAIL="$GOOD_EMAIL"
fi
'

#jq -c '.[]' authors.json | while read i; do # uncomment if the json is a file
echo $authors | jq -c '.[]' | while read i; do # uncomment if the json is a variable
    wrong_email=`echo $i | jq '.wrong_email'`
    good_email=`echo $i | jq '.good_email'`
    author_name=`echo $i | jq '.author_name'`

echo "
WRONG_EMAIL=${wrong_email}
GOOD_EMAIL=${good_email}
AUTHOR_NAME=${author_name}

${git_filter}" >> temp.txt

done

commandString=$(<temp.txt)
rm temp.txt

command="git filter-branch --env-filter '$commandString' --tag-name-filter cat -- --branches --tags"

#echo "$command"
eval $command
