#!/bin/sh
for i in *.mp4;
do
ffmpeg -i "$i" -c:v libx264 -pix_fmt yuv420p -crf 22 -r:a 384K -c:a libopus "${i%.*}-comp.mp4"
done
exit 0
