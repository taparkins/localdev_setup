DOWNLOAD_LINK="https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US"
DMG_FILE="/tmp/firefox.dmg"
MOUNT_LOCATION="/Volumes/Firefox"
APP_LOCATION="$MOUNT_LOCATION/Firefox.app"
APP_EXE_LOCATION="${APP_LOCATION}/Contents/MacOS/firefox"

if [[ ! -d ${APP_LOCATION} ]]; then
    wget $DOWNLOAD_LINK -O $DMG_FILE
    hdiutil attach $DMG_FILE
    cp -r $APP_LOCATION /Applications
    touch /Applications/Firefox.app

    # add to dock
    defaults write com.apple.dock persistent-apps -array-add "\
    <dict>\
      <key>tile-data</key>\
      <dict>\
        <key>file-data</key>\
        <dict>\
          <key>_CFURLString</key>\
          <string>/Applications/Firefox.app</string>\
          <key>_CFURLStringType</key>\
          <integer>0</integer>\
        </dict>\
      </dict>\
    </dict>"
    killall Dock
fi

# prep for Tree-Based Tab: remove top-level tab bar
# TODO: for some reason this wasn't working either :(
#PROFILE_DIR="$HOME/Library/Application Support/Firefox/Profiles/"
#PROFILE_DIR_NAME=`ls "${PROFILE_DIR}" | grep default$`
#PROFILE_DIR="${PROFILE_DIR}/${PROFILE_DIR_NAME}"
#if [[ ! -d "${PROFILE_DIR}/chrome" ]]; then
#  mkdir "${PROFILE_DIR}/chrome"
#fi
#if [[ ! -f "${PROFILE_DIR}/chrome/userChrome.css" ]]; then
#  touch "${PROFILE_DIR}/chrome/userChrome.css"
#  echo "#TabsToolbar { visibility: collapse !important; }" > "${PROFILE_DIR}/chrome/userChrome.css"
#fi

# setup my extensions
# TODO: This isn't quite working
#EXTENSION_URLS=(\
#  "https://addons.mozilla.org/firefox/downloads/file/3339183/tree_style_tab-3.1.5-fx.xpi?src=dp-btn-primary" \
#  "https://addons.mozilla.org/firefox/downloads/file/3361355/ublock_origin-1.21.2-an+fx.xpi?src=dp-btn-primary" \
#)
#EXTENSION_FILES=()
#i=0
#for URL in "${EXTENSION_URLS[@]}"
#do
#  EXTENSION_FILE="/tmp/extension${i}.xpi"
#  EXTENSION_FILES+=($EXTNESION_FILE)
#  wget ${URL} -O $EXTENSION_FILE
#  i=${i+1}
#done
#${APP_EXE_LOCATION} ${EXTENSION_FILES[@]}
#echo ${EXTENSION_FILES[@]} | xargs rm

# clean up after ourselves :)
hdiutil detach $MOUNT_LOCATION
rm $DMG_FILE
