#!/bin/bash

echo "Please enter your OAuth token:"
OAUTH="BQBStYcria2agimI1uyt7dC_JnGF17ppuj7ScqU2QUsFzqRWW1n0D42lfM5ghEED4myNrWrNbqlJvtzqeS1uwwfjbG1-v_8ETfZuYkUQAVXbM7j6OvkOpzwJNpFZ4ezgmW9_64NIdJ6QtDy3Wmu6T4l0noG-xuSJT070sVArIXemTQ0scLZ6ZcGfU5kEUyEACtZqRa8SNB_LR9HR"


echo ""

echo "Please enter your playlist ID"
PLAYLISTID="6jO8TpwpwalYEpu2kVLNs4"

echo ""

echo "Do You Have More Than 100 Songs? (y/n)"
read yn

if [ "$yn" = "y" ]; then
  echo "How many hundred songs do you have (If you have 101 songs type 200 so all songs will be listed)"
  read LIMIT

  num=($expr $LIMIT/100)

  for((i=0;i<$num;i++));
    do
        i1=($expr $i + 1)
        i2=$(expr $i1 \* 100)
        output=$(curl -X "GET" "https://api.spotify.com/v1/playlists/$PLAYLISTID/tracks?fields=items(track)&limit=100&offset=$i2" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTH"| sed '/artists/,/is_local/d' | sed -n -e '/name/p' | sed 's/"//g' | sed 's/^[^:]*://')
    done

else
  echo " "
  echo "What do you want the limit to be? (Max 100)"
  read limit

  output=$(curl -X "GET" "https://api.spotify.com/v1/playlists/$PLAYLISTID/tracks?fields=items(track)&limit=$limit&offset=0" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $OAUTH" | sed '/artists/,/id/d' | sed '/available_markets/,/is_local/d' | sed -n -e '/name/p'  | sed 's/"//g' | sed 's/^[^:]*://')
fi

echo "$output"

sleep 1

echo ""

echo "            Do you want to continue and download these songs? (y/n)               "
echo "Disclaimer: You need to have 'yt-dlp' downloaded for downloading of videos to work"
read continue
if [ "$continue" = "y" ]; then

  songs=()

  # Set the field separator to a comma
  IFS=","

  # Iterate over the fields of the songs_string variable
  while read -r line; do
    # Append each field to the array
    songs+=("$line")
  done <<< "$output"

  echo "What directory do you want to download the songs to"
  read dir

  cd $dir

  echo ""

  echo "Do you want to Auto-Select or manually select? (auto/manual)\nAuto-Selecting is not 100% accurate as it takes the top result from youtube. If you are into smaller/niche artist choose Manual selection"
  read am

  for song in "${songs[@]}"; do

    # Downloads each song!
    echo "$song"

    if [ "$am" = "auto" ]
    then
      cd "$dir"

      o=$(ytfzf -d -m --sort-by=relevance --auto-select -I link --type=video "$song")
      yt-yt-dlp -x --audio-format opus --embed-thumbnail --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" "$o"

      clear
    elif [ "$am" = "manual" ]
    then
      cd "$dir"

      o=$(ytfzf -d -m --sort-by=relevance -I link --type=video "$song")
      yt-yt-dlp -x --audio-format opus --embed-thumbnail --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" "$o"

      clear
    fi
  done

  echo "Thanks for using my program! Have a nice day or night :D"

fi
