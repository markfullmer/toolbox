## Git ##
gitclone() {
  # usage: gitclone <project>
  # or: gitclone <vendor>/<project>
  # Provide a shortcut default account
  if [[ "$1" == *\/* ]]; then
    path=$1
    project=$(basename $1)
  else
    path="markfullmer/"$1
    project=$1
  fi
  # e.g., gitclone toolbox
  git clone git@github.com:"$path".git
  # Make sure the clone succeeded before doing anything else.
  if [ "$?" -eq 0 ]; then
    cd $project
    # Convention for remote naming.
    git remote rename origin github
    git remote -v
  fi
}
drupalclone() {
  # usage: drupalclone token
  git clone git@git.drupal.org:project/"$1".git
  cd $1
  git remote rename origin github
}

## Pantheon ##

dashboard() {
  # usage: dashboard <site:name>
  # e.g., dashboard utqs-staff-council
  ID=$(terminus site:info "$1" --field=ID)
  open https://dashboard.pantheon.io/sites/"$ID"#dev/code
}
deployToTest() {
  # usage: deployToTest <site:name>
  # e.g., deployToTest utexas-eureka
  USER=$(git config user.name)
  terminus env:deploy "$1".test --sync-content --note=''"$USER"': deploy to TEST' --cc --updatedb
}
deployToLive() {
  # usage: deployToLive <site:name>
  # e.g., deployToLive utexas-eureka
  USER=$(git config user.name)
  terminus env:deploy "$1".live --note=''"$USER"': deploy to LIVE' --cc --updatedb
}

# Miscellaneous / Just for fun ##

lmgtfy() {
  # usage: lmgtfy how do I add a bash function in my profile
  with_spaces=$@
  stringify="${with_spaces// /+}"
  echo https://lmgtfy.com/?q="$stringify"
}
