## Git ##
drupalclone() {
  # usage: drupalclone token
  git clone git@git.drupal.org:project/"$1".git
  cd $1
}
gitclone() {
  # usage: gitclone <repository name>
  # e.g., gitclone markfullmer/toolbox
  open https://git@github.com:"$1"
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
