#!/usr/bin/env bash

# Parse opts
while [[ "$#" > 1 ]]; do case $1 in
    -n|--name) NAME="$2";;
    -u|--url) URL="$2";;
    -i|--icon) ICON="$2";;
    *) break;;
  esac; shift; shift
done

# Set vars
DEST="$HOME/Applications/Juli Apps";
JULI="/Applications/Juli.app";
ID="$(echo -n "${NAME}" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z)";
APP_BUNDLE="${DEST}/${NAME}.app";
CONTENT_DIR="${APP_BUNDLE}/Contents";
MACOS_DIR="${CONTENT_DIR}/MacOS";
RESOURCE_DIR="${CONTENT_DIR}/Resources";

############################
# Usage instructions       #
# [WIP] print when no args #
############################
read -r -d '' USAGE << EOF
Usage: juli [opts]

Options:

-n --name   App name (required)
-u --url    App URL (required)
-i --icon   Path to .icns file to use
EOF

#############
# Functions #
#############
function log() {
  case "$2" in
    "error")
      tput setaf 1
      ;;
    "warning")
      tput setaf 3
      ;;
    "success")
      tput setaf 6
      ;;
    *)
      tput setaf 0
      ;;
  esac

  echo "$1"
}

function print_usage() {
  echo "${USAGE}"
  exit 0
}

function check_args() {
  if [ -z "$NAME" ]; then
    log "You must specify a name" error
    exit 0
  fi

  if [ -z "$URL" ]; then
    log "You must specify a URL" error
    exit 0
  fi
}

function remove_if_exists(){
  if [ -a "${APP_BUNDLE}" ]; then
    log "$NAME already exists, overwriting..." warning
    rm -rf "${APP_BUNDLE}";
  fi;
}

function scaffold_bundle() {
  log "Making app bundle"

  mkdir -p "${MACOS_DIR}";
  mkdir -p "${RESOURCE_DIR}";
}

function write_executable() {
  log "Creating app executable"

  cat << EOF > "${MACOS_DIR}/${NAME}"
#!/usr/bin/env bash

# App name: ${NAME}
# App url: ${URL}
# App ID: ${ID}

${JULI}/Contents/MacOS/Juli --id="${ID}" --name="${NAME}" --url="${URL}"
EOF
  chmod +x "${MACOS_DIR}/${NAME}";
}

function write_icon() {
  if [[ "$ICON" ]]; then
    log "Copying over icon"
    sips -s format tiff "${ICON}" --out "${RESOURCE_DIR}/app.tiff" --resampleHeightWidth 128 128 >& /dev/null
    tiff2icns -noLarge "${RESOURCE_DIR}/app.tiff" >& /dev/null
    rm -rf "${RESOURCE_DIR}/app.tiff"
  fi;
}

function write_plist() {
  log "Writing app manifest"

  cat << EOF > "${CONTENT_DIR}/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>CFBundleExecutable</key>
    <string>${NAME}</string>
    <key>CFBundleGetInfoString</key>
    <string>${NAME}</string>
    <key>CFBundleIconFile</key>
    <string>app.icns</string>
    <key>CFBundleName</key>
    <string>${NAME}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
  </dict>
</plist>
EOF
}

# Run it!
check_args
remove_if_exists
scaffold_bundle
write_executable
write_icon
write_plist

log "Done!" success
