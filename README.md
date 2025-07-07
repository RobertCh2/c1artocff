# Capture One aspect ratio to crop for FujiFilm 

## Overview
Capture One version 16.6.3.6 does not have an option to automatically crop images when the aspect ratio was set in-camera on Fujifilm cameras. This script provides that functionality.

## Compatibility
- **Platform**: macOS
- **Capture One**: Version 16.6.3.6 (may work with other versions)
- **File Format**: RAF files (Fujifilm RAW)

## Prerequisites
First, install ExifTool using Homebrew:
```bash
brew install exiftool
```

## Installation

1. In Capture One, open the **Scripts** menu and select **Open Scripts Folder**
2. Copy the script file to this folder
3. Ensure the script has the `.scpt` extension
4. In Capture One, go to **Scripts** menu and select **Update Script Menu**

## Usage

1. Select the RAF files you want to process in Capture One
2. From the **Scripts** menu, choose **c1artocff**
3. The script will automatically crop the images based on the aspect ratio set in-camera

## Notes
- Only works with Fujifilm RAF files
- Requires ExifTool to read camera settings
- The script reads the in-camera aspect ratio setting and applies the appropriate crop

## Troubleshooting
- Ensure ExifTool is properly installed and accessible from the command line
- Verify the script file has the correct `.scpt` extension
- Make sure to update the Scripts menu after copying the file
