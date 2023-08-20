#!/bin/bash
URL=$(curl -s https://api.github.com/repos/CorsixTH/CorsixTH/releases/latest | jq '.assets[] | select(.name|endswith(".tar.gz.sig")) | .browser_download_url' | tr -d '"')
echo $URL
VERSION=$(echo $URL|cut -d'/' -f8|tr -d '-'|cut -c2-)
if [[ "$VERSION" == "" ]]; then
   echo "ERROR: could not fetch latest version"
   exit 1
fi
LOCAL_VERSION=$(cat snapcraft.yaml|grep "version: "|cut -d" " -f2|tr -d '"')
if [[ "$VERSION" != "$LOCAL_VERSION" ]]; then
   echo "local and remove versions differ"
   echo "old version: $LOCAL_VERSION"
   echo "new version: $VERSION"
   sed -i "/^\([[:space:]]*version: \).*/s//\1\"$VERSION\"/" snapcraft.yaml
   echo "git commit -a -m 'version update: $VERSION'"
   echo "git push"
else
   echo "no update available. current version is $VERSION"
fi
