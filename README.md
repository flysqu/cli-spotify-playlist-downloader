# cli-spotify-playlist-downloader
Downloads all songs in a spotify playlist using the spotify api and ytfzf

## Flowchart
![](https://github.com/Lop010/cli-spotify-playlist-downloader/blob/main/assets/ezgif-4-4ec5c4682e.gif)

## Dependencies
1. [ytfzf](https://github.com/pystardust/ytfzf)
2. [yt-dlp](https://github.com/yt-dlp/yt-dlp)
3. [FFmpeg](https://ffmpeg.org/) (On most distros it is preinstalled) 

## How to get a OAuth token

1. Go to this url "https://developer.spotify.com/console/get-playlist-tracks/" (You may have to log in to your spotify account) <br />
2. Scroll down and click the button "Get Token"<br />
3. Check only the box "playlist-read-private"<br />
4. Now click request token<br />
5. Now copy the OAuth field and paste it into the program (The token is very long so make sure to copy the whole thing)<br />
