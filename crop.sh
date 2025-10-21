#!/bin/bash

# sudo apt install imagemagick
# Run the above command once.
# DPI and PPI are the same.
# Put all the image files to be cropped inside "input" folder.
# Measurements are taken from left top corner of the input image.
# Output images are appended with "_cropped" string.
# Output images will be in "output" folder that is auto-created.

# Set input and output directories
input_folder="./input"   # Change if your images are elsewhere
output_folder="./output"
mkdir -p "$output_folder"  # Create output folder if it doesn't exist

# Prompt user for image DPI, width and height in mm
read -p "Enter DPI/PPI: " dpi
read -p "Enter crop width in millimeters: " width_mm
read -p "Enter crop height in millimeters: " height_mm

# Convert mm to pixels (1 inch = 25.4 mm)
mm_to_pixels=$(echo "$dpi / 25.4" | bc -l)
width_px=$(echo "$width_mm * $mm_to_pixels" | bc)
height_px=$(echo "$height_mm * $mm_to_pixels" | bc)

# Round pixel values to nearest integer (optional but recommended)
width_px=$(printf "%.0f" "$width_px")
height_px=$(printf "%.0f" "$height_px")

# Process each supported image file in the input folder
for img_file in "$input_folder"/*.{jpg,jpeg,png,tiff,bmp}; do
  if [ -f "$img_file" ]; then
    # Get the base filename (e.g., image.jpg)
    filename=$(basename "$img_file")

    # Extract the name and extension separately
    name="${filename%.*}"         # e.g., 'image'
    ext="${filename##*.}"         # e.g., 'jpg'

    # Construct the output filename with '_cropped' suffix
    output_file="$output_folder/${name}_cropped.${ext}"

    # Crop the image from the top-left corner
    convert "$img_file" -crop "${width_px}x${height_px}+0+0" "$output_file"

    echo "Processed: $filename -> ${name}_cropped.${ext}"
  fi
done

echo "Cropping completed for all images in '$input_folder'. Output saved in '$output_folder'."
