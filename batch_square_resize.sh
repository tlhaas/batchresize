#!/bin/bash

INPUT_DIR="$1"
OUTPUT_DIR="$2"
RES="${3:-600}"     # Default to 600
QUALITY="${4:-95}"  # Default to 95

# Validate RES is numeric and within 1–7000
if ! [[ "$RES" =~ ^[0-9]+$ ]]; then
  echo "⚠️  Invalid resolution: $RES. Must be a number. Using default: 600."
  RES=600
elif [ "$RES" -lt 1 ]; then
  echo "⚠️  Resolution too low: $RES. Minimum is 1. Using 1."
  RES=1
elif [ "$RES" -gt 7000 ]; then
  echo "⚠️  Resolution too high: $RES. Maximum is 7000. Using 7000."
  RES=7000
fi

# Validate QUALITY is numeric and within 1–100
if ! [[ "$QUALITY" =~ ^[0-9]+$ ]] || [ "$QUALITY" -lt 1 ] || [ "$QUALITY" -gt 100 ]; then
  echo "⚠️  Invalid quality: $QUALITY. Must be between 1 and 100. Using default: 90."
  QUALITY=90
fi

RESOLUTION="${RES}x${RES}" # Enforce square

mkdir -p "$OUTPUT_DIR"

# Count total images to process
total=$(find "$INPUT_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.tif" \) | wc -l)
count=0

for img in "$INPUT_DIR"/*.{jpg,jpeg,png,webp,bmp,tiff,tif}; do
  [ -e "$img" ] || continue

  ((count++))
  filename=$(basename "$img")
  name="${filename%.*}"

  # Get image dimensions
  dimensions=$(magick identify -format "%w %h" "$img")
  width=$(echo $dimensions | cut -d' ' -f1)
  height=$(echo $dimensions | cut -d' ' -f2)

  max_dim=$(( width > height ? width : height ))

  # Convert and force output to JPEG with defined quality
  magick "$img" \
    -background white -gravity center -extent "${max_dim}x${max_dim}" \
    -resize "$RESOLUTION" \
    -quality "$QUALITY" \
    jpg:"$OUTPUT_DIR/${name}.jpg"

  # Log filesize
  filesize=$(du -h "$OUTPUT_DIR/${name}.jpg" | cut -f1)
  echo "[$count/$total] Processed $filename → ${name}.jpg ($filesize, ${RESOLUTION}, Q$QUALITY)"
done

echo "✅ All done! $count image(s) processed."
