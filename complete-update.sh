# Usage
# sh complete-update.sh drupal8sites.sh

# Prerequisites
# 1. The `composer-update.sh` script must have been run relative to this script,
# resulting in a downloaded codebase and a staged branch.

# Functionality:
# For each site listed in the sourced file...
# 1. cd into the already-created directory & merge the checked-out branch
# 2. Pull master from the Github remote & push to Pantheon.
# 3. Deploy to TEST and LIVE.

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
  SITE=${ARRAY%%:*}
  if [ ! -d "$SITE" ]
  then
    echo "Could not find directory named $SITE. Skipping..."
  else
    cd $SITE
    gh pr merge -s
    git pull github master
    PANTHEON_SITE_GIT_URL="$(terminus connection:info $SITE.dev --field=git_url)"
    git remote add pantheon "$PANTHEON_SITE_GIT_URL"
    git push pantheon master
    USER=$(git config user.name)
    terminus env:deploy "$SITE".test --sync-content --note=''"$USER"': '"$TITLE"'' --cc --updatedb
    terminus env:deploy "$SITE".live --note=''"$USER"': '"$TITLE"'' --cc --updatedb
    cd ..
  fi
done
pwd
