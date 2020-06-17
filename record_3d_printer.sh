#!/bin/zsh

/Applications/VLC.app/Contents/MacOS/VLC -I dummy "http://$1:8080/?action=stream" --rate 1 --video-filter=scene --vout=dummy --start-time=10 --scene-format=jpg  --scene-ratio=400 --scene-prefix=snapshot --scene-path=/Users/andygeers/Desktop/3DPrinter --sout-x264-lookahead=10  --sout-x264-tune=stillimage vlc://quit

echo ""
echo "To create timelapse:"
echo "bin/ffmpeg -r 10 -start_number 0 -i ""/Users/andygeers/Desktop/3DPrinter/snapshot%*.jpg"" -c:v libx264 -vf ""fps=25,format=yuv420p""  ~/Desktop/3DPrinter/timelapse.mp4"
