# Image Time Sorting Tool (Image Sorting Tool)

## Project Introduction

This is a Shell script toolkit for organizing image files that can rename images based on their last modification time and simultaneously update corresponding metadata time information.

## Features

- Sort images according to file last modification time
- Rename images to standard time format (YYYYMMDD_HHMMSS)
- Automatically prevent filename conflicts
- Support multiple image formats
- Synchronize updates to filesystem time and EXIF metadata time

## Included Scripts

### 1. retime-gif.sh

- Specifically handles GIF format images
- Renames GIF files based on file modification time
- Updates filesystem modification time

### 2. retime-jpg,png,jpeg.sh

- Handles JPG, PNG, JPEG format images
- In addition to renaming and updating filesystem time, also modifies EXIF capture time
- Requires exiftool to be pre-installed

## Usage

### Preparation

1. Place images to be processed into the `test` directory
2. Ensure appropriate script execution permissions
3. Ensure output directory exists

### Execute Scripts

```bash
# Rename GIF images and update time
./retime-gif.sh

# Rename JPG/PNG/JPEG images and update EXIF time
./retime-jpg,png,jpeg.sh
```

### Install Dependencies (JPG/PNG/JPEG script only)

If using the JPG/PNG/JPEG processing script, install exiftool first:

```bash
# Ubuntu/Debian systems
sudo apt install libimage-exiftool-perl

# CentOS/RHEL/Fedora systems
sudo yum install perl-Image-ExifTool
# or
sudo dnf install perl-Image-ExifTool
```

## Output Format

All images will be renamed to the following format:

- `YYYYMMDD_HHMMSS.ext` (e.g.: 20231003_144137.jpg)
- If duplicate names exist, add sequence number: `YYYYMMDD_HHMMSS_n.ext` (e.g.: 20231003_144137_1.jpg)

## Supported Formats

- **GIF script**: `.gif`
- **JPG/PNG/JPEG script**: `.jpg`, `.jpeg`, `.png` (case-insensitive)

## Workflow

1. Scan target image files in specified directory
2. Sort files according to last modification time
3. Rename each file to corresponding timestamp format
4. Update file system time and metadata time (when applicable)
5. Display processing progress information

## Notes

- Script defaults to processing files in `test` directory, can be modified as needed
- Recommend backing up important files before processing
- Script automatically handles filename conflicts
- JPG/PNG/JPEG script modifies EXIF metadata, this operation is irreversible

## Application Scenarios

- Organizing large numbers of photos in chronological order
- Unified management of photos from different devices
- Fixing timestamp confusion caused by incorrect operations
- Creating organized image file structures