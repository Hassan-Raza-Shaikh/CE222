#!/bin/sh
# Build reveal.js slides from slides.md
# Requires: pandoc (with reveal.js support). Uses CDN for reveal.js.

pandoc slides.md \
  -t revealjs \
  -s \
  -o slides.html \
  --resource-path=. \
  --css custom.css \
  -V revealjs-url=https://unpkg.com/reveal.js@4 \
  -V theme=white \
  -V transition=fade \
  -V slideNumber=true \
  -V hash=true \
  -V center=false

echo "Built slides.html"
