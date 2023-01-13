#!/bin/bash

clear

NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'


zenity --info --text="DISCLAIMER: This program relies on yt-dlp and ytfzf"

OAUTH=$(zenity --entry --width=400 --title="OAuth" --text="Enter Your OAuth Token")

PLAYLISTID=$(zenity --entry --width=400 --title="Playlist ID" --text="Enter A Playlist ID")



zenity --question --text="Do You Have More Than 100 Songs? (y/n)"
if [ $? = 0 ]; then
    echo "Since you have more than 100 songs i recommend setting the offset to 0 then running it again at 100"
    echo "This way you will get 200 songs, Normally it is limited to 100 songs"

    echo ""
    echo "Please exit the program and start from the begining"
    sleep 1000s
else
  limit=$(zenity --entry --width=400 --title="Limit" --text="What do you want the limit to be? (Max 100)")



  offset=$(zenity --entry --width=400 --title="Offset" --text="What do you want the offset to be? (0 Is Recommended)")

  tracks=$(curl -X "GET" "https://api.spotify.com/v1/playlists/$PLAYLISTID/tracks?fields=items(track)&limit=$limit&offset=$offset" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTH" | jq '.items[].track.name' | sed 's/"//g')
  artists=$(curl -X "GET" "https://api.spotify.com/v1/playlists/$PLAYLISTID/tracks?fields=items(track)&limit=$limit&offset=$offset" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTH" | jq '.items[].track.album.artists[0].name' | sed 's/"//g')

  output=$(paste <(echo "$tracks") <(echo "$artists") -d $', ')
fi

echo "$output"

sleep 1

echo " "

zenity --question --width=550 --text="Do you want to continue and download these songs? (y/n) \nDisclaimer: You need to have 'yt-dlp' downloaded for downloading of videos to work"
if [ "$?" = 0 ]; then

  songs=()

  # Set the field separator to a comma
  IFS=","

  # Iterate over the fields of the songs_string variable
  while read -r line; do
    # Append each field to the array
    songs+=("$line")
  done <<< "$output"

  dir=$(zenity --entry --width=400 --title="Directory" --text="What directory do you want to download the songs to")

  cd $dir


  am=$(zenity --entry --width=400 --title="Playlist ID" --text="Do you want to Auto-Select or manually select? (auto/manual)\nAuto-Selecting is not 100% accurate as it takes the top result from youtube. If you are into smaller/niche artist choose Manual selection")

  for song in "${songs[@]}"; do
    # Downloads each song!
    echo "$song"
    if [ "$am" = "auto" ] 
    then
      cd "$dir"

      o=$(ytfzf -d -m --sort-by=relevance --auto-select -I link --type=video "$song")
      yt-dlp -x --audio-format mp3 --embed-thumbnail "$o"
      clear
    elif [ "$am" = "manual" ]
    then
      cd "$dir"

      o=$(ytfzf -d -m --sort-by=relevance -I link --type=video "$song")
      yt-dlp -x --audio-format mp3 --embed-thumbnail "$o"

      clear
    fi
    
  done

  echo "Thanks for using my program! Have a nice day or night :D"

fi