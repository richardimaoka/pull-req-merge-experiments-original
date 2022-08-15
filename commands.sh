#!/bin/sh

cat << STEP
mkdir pull-req-merge-experiments
cd pull-req-merge-experiments 
git init
gh repo create "$CURDIR" --public --source=. --remote=origin

STEP

MAIN_BRANCH="main"

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
echo 2 > $FILE
git add --all
git commit -m "add 2 in branch $BRANCH"

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
echo 2 > $FILE
git add --all
git commit -m "add 2 in branch $BRANCH"

git switch $MAIN_BRANCH
git merge --no-ff --no-edit $BRANCH
git branch -d $BRANCH

STEP


FILE="pull-req-merge-commit.txt"
BRANCH1="pr-merge-commit-1"
BRANCH2="pr-merge-commit-2"
cat << STEP 
#############################################################
PR merge commit
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
sed -i 's/1/11111/' pull-req-merge-commit.txt
git add --all
git commit -m "update 1 in $BRANCH1"
git push --set-upstream origin $BRANCH1

git switch -c $BRANCH2 $MAIN_BRANCH
sed -i 's/2/22222/' pull-req-merge-commit.txt
git add --all
git commit -m "update 2 in $BRANCH2"
sed -i 's/3/33333/' pull-req-merge-commit.txt
git add --all
git commit -m "update 3 in $BRANCH2"
git push --set-upstream origin $BRANCH2

gh pr create --title $BRANCH1 --body "" --base $MAIN_BRANCH --head $BRANCH1
gh pr create --title $BRANCH2 --body "" --base $MAIN_BRANCH --head $BRANCH2
gh pr merge $BRANCH1 --merge --delete-branch
gh pr merge $BRANCH2 --merge --delete-branch

git switch $MAIN_BRANCH
git pull origin $MAIN_BRANCH
# git branch -D $BRANCH1
# git branch -D $BRANCH2

git log --oneline --decorate --graph
STEP


FILE="pull-req-squash-merge.txt"
BRANCH1="pr-squash-merge-1"
BRANCH2="pr-squash-merge-2"
cat << STEP 
#############################################################
PR squash merge
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
sed -i 's/1/11111/' $FILE
git add --all
git commit -m "update 1 in $BRANCH1"
git push --set-upstream origin $BRANCH1

git switch -c $BRANCH2 $MAIN_BRANCH
sed -i 's/2/22222/' $FILE
git add --all
git commit -m "update 2 in $BRANCH2"
sed -i 's/3/33333/' $FILE
git add --all
git commit -m "update 3 in $BRANCH2"
git push --set-upstream origin $BRANCH2

gh pr create --title $BRANCH1 --body "" --base $MAIN_BRANCH --head $BRANCH1
gh pr create --title $BRANCH2 --body "" --base $MAIN_BRANCH --head $BRANCH2
gh pr merge $BRANCH1 --squash --delete-branch
gh pr merge $BRANCH2 --squash --delete-branch

git switch $MAIN_BRANCH
git pull origin $MAIN_BRANCH
# git branch -D $BRANCH1
# git branch -D $BRANCH2

git log --oneline --decorate --graph
STEP


FILE="pull-req-rebase-merge.txt"
BRANCH1="pr-rebase-merge-1"
BRANCH2="pr-rebase-merge-2"
cat << STEP 
#############################################################
PR rebase merge
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
sed -i 's/1/11111/' $FILE
git add --all
git commit -m "update 1 in $BRANCH1"
git push --set-upstream origin $BRANCH1

git switch -c $BRANCH2 $MAIN_BRANCH
sed -i 's/2/22222/' $FILE
git add --all
git commit -m "update 2 in $BRANCH2"
sed -i 's/3/33333/' $FILE
git add --all
git commit -m "update 3 in $BRANCH2"
git push --set-upstream origin $BRANCH2

gh pr create --title $BRANCH1 --body "" --base $MAIN_BRANCH --head $BRANCH1
gh pr create --title $BRANCH2 --body "" --base $MAIN_BRANCH --head $BRANCH2
gh pr merge $BRANCH1 --rebase --delete-branch
gh pr merge $BRANCH2 --rebase --delete-branch

git switch $MAIN_BRANCH
git pull origin $MAIN_BRANCH
git branch -D $BRANCH1
git branch -D $BRANCH2

git log --oneline --decorate --graph
STEP
