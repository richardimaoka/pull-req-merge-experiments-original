```sh
#!/bin/sh

MAIN_BRANCH="development"

FILE="local-ff.txt"
BRANCH="local-ff-1"
cat << STEP
#############################################################
fast-forward merge locally
#############################################################
git switch $MAIN_BRANCH
touch $FILE
git add --all
git commit -m "create $FILE"

git switch -c $BRANCH
echo 1 > $FILE
git add --all
git commit -m "add 1 in branch $BRANCH"

git switch $MAIN_BRANCH
git merge $BRANCH
git branch -d $BRANCH
STEP


FILE="local-no-ff.txt"
BRANCH="local-no-ff-1"
cat << STEP
#############################################################
no-ff merge locally
#############################################################
git switch $MAIN_BRANCH
touch $FILE
git add --all
git commit -m "create $FILE"

git switch -c $BRANCH
echo 1 > $FILE
git add --all
git commit -m "add 1 in branch $BRANCH"

git switch $MAIN_BRANCH
git merge --no-ff --no-edit $BRANCH
git branch -d $BRANCH

STEP

FILE="pull-req-merge-commit.txt"
BRANCH1="pr-merge-commit-1"
BRANCH2="pr-merge-commit-2"
cat << STEP
#############################################################
PR in merge commit
#############################################################
git switch $MAIN_BRANCH
cat << EOF > $FILE
1

2

3
EOF
git add --all
git commit -m "create $FILE"
git push origin $MAIN_BRANCH

git switch -c $BRANCH1
cat << EOF > $FILE
11111

2

3
EOF
git add --all
git commit -m "update 1 in $BRANCH1"
git push --set-upstream origin $BRANCH1
gh pr create --fill --base $MAIN_BRANCH

git switch -c $BRANCH2 $MAIN_BRANCH
cat << EOF > $FILE
1

22222

3
EOF
git add --all
git commit -m "update 2 in $BRANCH2"
cat << EOF > $FILE
1

22222

33333
EOF
git add --all
git commit -m "update 3 in $BRANCH2"
git push --set-upstream origin $BRANCH2
gh pr create --fill --base $MAIN_BRANCH

git switch $MAIN_BRANCH
git pull origin $MAIN_BRANCH
git branch -D $BRANCH1
git branch -D $BRANCH2

git log --oneline --decorate --graph
STEP
```
