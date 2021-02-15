### check current remote
git remote -v

### remove origin remote
git remote remove origin

### add new remote REMEMBER. YOU NEED TO CREATE FIRST THE NEW REPO
git remote add origin https://github.com/URL-PROJECT.git

### check again remote with new url
git remote -v

### PUSH TO THE NEW REPO
git push --all origin

### PUSH ALL TAGS
git push --tags origin