# Usage
# sh composer-updater.sh drupal8sites.sh

# Functionality:
# 1. Clone the repository from Pantheon & add the Github remote
# 2. Create a new branch
# 3. Update Drupal core via Composer
# 4. Push the updates to a multidev & to the Github remote
# 5. Provide Github issue & pull request

## Prerequisites/assumptions
# 1. You are using Pantheon and have terminus installed on the machine
# 2. The Pantheon site name matches the repository name on your Github mirror.
# 3. You are using the Github CLI (https://cli.github.com/)

# -------------
if [ -z "$1" ];
then
  echo 'You must supply a filename as the first parameter'
  exit
fi
source $1
if [ -z "$SITES" ];
then
  echo 'Your source file is missing required variables'
  exit
fi

for ARRAY in "${SITES[@]}"
 do
   DATE=`date "+%m%d"`
   BRANCH="update-$DATE"
    SITE=${ARRAY%%:*}
    REVIEWER=${ARRAY#*:}
    echo "Site: $SITE"
    echo "Branch: $BRANCH"
    echo "Github endpoint: $GITHUB"
    echo "Assignee: $ASSIGNEE"
    echo "Project: $PROJECT"
    echo "Reviewer(s): $REVIEWER"
    echo "Packages to be updated: $PACKAGES"
    echo "Commit message: $TITLE"
    echo "Multidev name: https://$BRANCH-$SITE.pantheonsite.io"
    echo "Issue body: $ISSUE_BODY"
done