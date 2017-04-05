#! /bin/sh

cd "`dirname "$0"`"

sdef /Applications/iTunes.app | sdp -fh --basename "iTunes" --bundleid com.apple.iTunes
sdef /Applications/Mail.app | sdp -fh --basename "Mail" --bundleid com.apple.mail
sdef /Applications/Safari.app | sdp -fh --basename "Safari" --bundleid com.apple.Safari
#sdef "$INPUT_FILE_PATH" | sdp -fh -o "$DERIVED_FILES_DIR" --basename "$INPUT_FILE_BASE" --bundleid `defaults read "$INPUT_FILE_PATH/Contents/Info" CFBundleIdentifier`