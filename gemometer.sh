#!/usr/bin/env bash

# Fail when any subcommand fails; Fail when an unknown variable is referenced
set -eu

ROM_ID=$1
TOKEN=$2
URL="https://api.hipchat.com/v2/room/$ROM_ID/notification?auth_token=$TOKEN"

OUTDATED=$(bundle outdated | grep '\*' | sed "s@.*\* \([a-z]\+\)\(.*\)@\<li\>\<a href=\'https:\/\/rubygems.org\/gems\/\1\'\>\1\<\/a\>\2\<\/li\>@" | tr -d "\n")

if [[ -n $OUTDATED ]]
then
  MESSAGE="<p>Outdated gems:</p><ul>$OUTDATED</ul>"
  
  curl \
    -H 'Content-Type: application/json' \
    -X POST $URL \
    -d "{ \"message\": \"$MESSAGE\" }"

  echo "Sent message to Hipchat."
else
  echo "Bundle up to date!"
fi
