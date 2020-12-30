## Terminal shortcuts
alias la="ls -al"
alias findhere="find . -name "
alias aliases='code ~/aliases.sh'

## Git shortcuts
alias gs="git status --porcelain"
alias gfgc="git fetch && git checkout"
drupalclone() {
  # usage: drupalclone token
  git clone git@git.drupal.org:project/"$1".git
  cd $1
  git config user.email mfullmer@gmail.com
}
austinclone() {
  # usage: austinclone utdk_profile
  git clone git@github.austin.utexas.edu:eis1-wcs/"$1".git
  cd $1
  git remote rename origin github
  PANTHEON_SITE_GIT_URL="$(terminus connection:info $1.dev --field=git_url)"
  git remote add pantheon "$PANTHEON_SITE_GIT_URL"
}
github() {
  # (MacOS only)
  # usage: github <repository name>
  # e.g., github utdk_profile
  open https://github.austin.utexas.edu/eis1-wcs/"$1"
}
## Other useful Git integrations
# - The official Github CLI: https://cli.github.com/
# - Github Release Notes Generator: https://github.com/github-tools/github-release-notes

## Pantheon/Drupal integration
complete-update() {
  # usage: complete-update txglobal update-1112
  git fetch github && git checkout $2
  gh pr merge -s
  git pull github master
  git push pantheon master
  deployToTestF $1
}
migrate-sync() {
  export SOURCE_SITE="utqs-migration-tester"
  fin db create utexas_migrate && \
  terminus env:wake $SOURCE_SITE.dev && \
  terminus drush $SOURCE_SITE.dev cc all && \
  terminus backup:create $SOURCE_SITE.dev --element=db && \
  terminus backup:get $SOURCE_SITE.dev  --element=db --to=./db.sql.gz && \
  gunzip -c ./db.sql.gz > db.sql && \
  fin db import db.sql --db=utexas_migrate && \
  rm db.sql db.sql.gz
}
pantheon-sync() {
  terminus drush $1.live cr && \
  terminus backup:create $1.live --element=db && \
  terminus backup:get $1.live  --element=db --to=./db.sql.gz && \
  lando db-import db.sql.gz
}
dashboard() {
  # usage: dashboard <site-name>
  # or `dashboard <site-name>.<environment>
  # e.g., dashboard utqs-staff-council.test
  IFS=. PARTS=(${1})
  SITE=${PARTS[0]}
  ID=$(terminus site:info "$SITE" --field=ID)
  if [ ! -z "${PARTS[1]}" ];
  then
    ENV="${PARTS[1]}"
  else
    ENV="dev"
  fi
  open https://dashboard.pantheon.io/sites/"$ID"#"$ENV"/code
}
deployTest() {
  # usage: deployTest <site:name>
  # e.g., deployTest utexas-eureka
  # optional deployment message:
  # deployTest utexas-core "123 - Update fractals"
  USER=$(git config user.name)
  if [ -z "$1" ];
  then
    echo 'You must supply the machine name of a Pantheon site (e.g., utexas-core)'
    return
  fi
  if [ ! -z "$2" ];
  then
    MESSAGE="$2"
  else
    MESSAGE="deploy to TEST"
  fi
  terminus env:deploy "$1".test --sync-content --note=''"$USER"': '"$MESSAGE"'' --cc --updatedb
}
deployTestF() {
  # usage: deployTestF <site:name>
  # e.g., deployTestF utexas-eureka
  # optional deployment message:
  # deployTestF utexas-core "123 - Update fractals"
  USER=$(git config user.name)
  if [ -z "$1" ];
  then
    echo 'You must supply the machine name of a Pantheon site (e.g., utexas-core)'
    return
  fi
  if [ ! -z "$2" ];
  then
    MESSAGE="$2"
  else
    MESSAGE="deploy to TEST"
  fi
  terminus env:deploy "$1".test --note=''"$USER"': '"$MESSAGE"'' --cc --updatedb
}
deployLive() {
  # usage: deployLive <site:name>
  # e.g., deployLive utexas-eureka
  # optional deployment message:
  # deployLive utexas-core "123 - Update fractals"
  USER=$(git config user.name)
  if [ -z "$1" ];
  then
    echo 'You must supply the machine name of a Pantheon site (e.g., utexas-core)'
    return
  fi
  if [ ! -z "$2" ];
  then
    MESSAGE="$2"
  else
    MESSAGE="deploy to LIVE"
  fi
  terminus env:deploy "$1".live --note=''"$USER"': '"$MESSAGE"'' --cc --updatedb
}

## Potpourri
lmgtfy() {
  # usage: lmgtfy how do I add a bash function in my profile
  with_spaces=$@
  stringify="${with_spaces// /+}"
  echo https://lmgtfy.com/?q="$stringify"
}