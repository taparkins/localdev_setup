DOWNLOAD_LINK="https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US"
DMG_FILE="/tmp/firefox.dmg"
MOUNT_LOCATION="/Volumes/Firefox"
APP_ORIGIN_LOCATION="$MOUNT_LOCATION/Firefox.app"
APP_LOCATION="/Applications/Firefox.app"
APP_EXE_LOCATION="${APP_LOCATION}/Contents/MacOS/firefox"

if [[ ! -e ${APP_LOCATION} ]]; then
    wget $DOWNLOAD_LINK -O $DMG_FILE
    hdiutil attach $DMG_FILE
    cp -r $APP_ORIGIN_LOCATION $APP_LOCATION
    touch $APP_LOCATION
    hdiutil detach $MOUNT_LOCATION
    rm $DMG_FILE

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
PROFILE_DIR="$HOME/Library/Application Support/Firefox/Profiles/"

while [[ ! -d "${PROFILE_DIR}" ]]
do
    echo "******************************************************"
    echo "Further setup requires starting firefox at least once."
    echo "******************************************************"
    nohup ${APP_EXE_LOCATION} &
    sleep 5
done

PROFILE_DIR_NAME=`ls "${PROFILE_DIR}" | grep default-release$`
PROFILE_DIR="${PROFILE_DIR}/${PROFILE_DIR_NAME}"
if [[ ! -d "${PROFILE_DIR}/chrome" ]]; then
  mkdir "${PROFILE_DIR}/chrome"
fi
if [[ ! -f "${PROFILE_DIR}/chrome/userChrome.css" ]]; then
  touch "${PROFILE_DIR}/chrome/userChrome.css"
  echo "#TabsToolbar { visibility: collapse; }" > "${PROFILE_DIR}/chrome/userChrome.css"
fi

if [[ ! -f "${PROFILE_DIR}/prefs.js" ]]; then
    touch "${PROFILE_DIR}/prefs.js"
fi

# setup my extensions
EXTENSION_URLS=(\
  "https://addons.mozilla.org/firefox/downloads/file/3339183/tree_style_tab-3.1.5-fx.xpi?src=dp-btn-primary" \
  "https://addons.mozilla.org/firefox/downloads/file/3361355/ublock_origin-1.21.2-an+fx.xpi?src=dp-btn-primary" \
)
EXTENSION_FILES=(\
  "treestyletab@piro.sakura.ne.jp.xpi" \
  "uBlock0@raymondhill.net.xpi" \
)
NEEDS_INSTALL=()
i=0
for URL in "${EXTENSION_URLS[@]}"
do
  EXTENSION_FILE="${PROFILE_DIR}/extensions/${EXTENSION_FILES[i]}"
  if [[ ! -f "${EXTENSION_FILE}" ]]; then
      NEEDS_INSTALL+=($URL)
  fi
  i=${i+1}
done

if [[ ! -z $NEEDS_INSTALL ]]; then
    echo "******************************************************"
    echo "We detected some uninstalled extensions."
    echo "Unfortunately, this will also require manual steps."
    echo "For each extension you do not have installed, we will"
    echo "launch a browser tab to install it."
    echo "Just click \"yes\" when prompted in the browser."
    echo "******************************************************"
    if [[ -z `ps aux | grep [F]irefox.app` ]]; then
        nohup ${APP_EXE_LOCATION} &
        sleep 5
    fi

    for URL in "${NEEDS_INSTALL[@]}"
    do
        echo ${URL}
        ${APP_EXE_LOCATION} -new-tab ${URL}
    done
    read -p "Press RETURN when you are finished..."

    echo "******************************************************"
    echo "Also, be sure to check the firefoxConfigs/ directory."
    echo "These will have importable configs for the installed"
    echo "extensions."
    echo "******************************************************"
    read -p "Press RETURN when this is done..."

fi

echo "******************************************************"
echo "Don't worry, we just need Firefox to be off for this."
echo "******************************************************"
ps -ax | grep "[F]irefox" | awk '{ print $1 }' | xargs kill

ENABLE_PREFS=( \
    "browser.ctrlTab.recentlyUsedOrder" \
    "toolkit.legacyUserProfileCustomizations.stylesheets" \
)
PREF_VALUES=( \
    "false" \
    "true" \
)
i=0
cp  "${PROFILE_DIR}/prefs.js" "/tmp/prefs.js"
for CHECK_PREF in ${ENABLE_PREFS[@]}
do
    PREF_VALUE=${PREF_VALUES[i]}
    PREF_CORRECT=`cat "${PROFILE_DIR}/prefs.js" | grep ${CHECK_PREF} | grep ${PREF_VALUE}`
    if [[ -z ${PREF_CORRECT} ]]; then
        sed '/${CHECK_PREF}/d' "/tmp/prefs.js" > "/tmp/prefs2.js"
        mv "/tmp/prefs2.js" "/tmp/prefs.js"
        echo "user_pref(\"${CHECK_PREF}\", ${PREF_VALUE});" >> "/tmp/prefs.js"
    fi
    i=${i+1}
done
mv "/tmp/prefs.js" "${PROFILE_DIR}/prefs.js"

if [[ -f nohup.out ]]; then
    rm nohup.out
fi
