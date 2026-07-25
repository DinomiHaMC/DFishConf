#!/usr/bin/env bash

if [ ! -f ".dirs-exists-flag" ]; then
  cd ~
  mkdir -p Downloads Audios Docs Pictures Videos Code
  touch .dirs-exists-flag
fi

cd Downloads

echo -e "\033[0;32mMoving:\033[0m"
ls ~/Downloads/

mv *.wav *.aiff *.flac *.alac *.mp3 *.aac *.ogg ~/Audios/ 2>/dev/null
mv *.jpg *.jpeg *.png *.gif *.webp *.tiff *.psd *.svg ~/Pictures/ 2>/dev/null
mv *.mp4 *.mov *.avi *.mkv *.webm ~/Videos/ 2>/dev/null
mv *.py *.cpp *.cs *.html *.css *.js *.ts *.tsx *.java *.rs *.c *.cc *.h *.hpp *.go *.rb *.lua *.php *.swift *.kt *.jar *.htm *.sh *.bat *.cmd *.r *.dart *.pyc *.conf ~/Code/ 2>/dev/null
mv * ~/Docs/ 2>/dev/null

echo -e "\n\033[0;32mMoved!\033[0m"

echo -e "\n\033[0;32mAudios:\033[0m"
ls ~/Audios/

echo -e "\n\033[0;32mDocs:\033[0m"
ls ~/Docs/

echo -e "\n\033[0;32mPictures:\033[0m"
ls ~/Pictures/

echo -e "\n\033[0;32mVideos:\033[0m"
ls ~/Videos/

echo -e "\n\033[0;32mCode:\033[0m"
ls ~/Code/

echo -e "\n\033[0;32mDone!\033[0m"
