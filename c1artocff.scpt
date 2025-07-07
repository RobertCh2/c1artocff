tell application "Capture One"
	
	set selectedImages to (get selected variants)
	if (count of selectedImages) is 0 then
		display dialog "Please select images to process." buttons {"OK"} with title "No Images Selected"
		return
	end if
	
	set totalImages to (count of selectedImages)
	set croppedCount to 0
	set errorCount to 0
	set processedCount to 0
	
	-- Statistics tracking
	set ratio43Count to 0
	set ratio32Count to 0
	set ratio169Count to 0
	set ratio11Count to 0
	set ratio6524Count to 0
	set ratio76Count to 0
	set ratio54Count to 0
	set otherRatioCount to 0
	
	set progress total units to totalImages
	set progress completed units to 0
	set progress text to "Processing GFX aspect ratio crops..."
	
	repeat with currentVariant in selectedImages
		try
			set parentImg to (get parent image of currentVariant)
			set imgDimensions to (get dimensions of parentImg)
			set imgWidth to (item 1 of imgDimensions)
			set imgHeight to (item 2 of imgDimensions)
			set imagePath to (get path of parentImg)
			
			set aspectRatioResult to (do shell script "eval `/usr/libexec/path_helper -s`; /usr/local/bin/exiftool -RawImageAspectRatio \"" & imagePath & "\"")
			
			set oldDelimiters to AppleScript's text item delimiters
			set AppleScript's text item delimiters to ": "
			set aspectRatioParts to text items of aspectRatioResult
			set aspectRatioValue to item -1 of aspectRatioParts
			set AppleScript's text item delimiters to oldDelimiters
			
			set targetRatio to 0
			
			if aspectRatioValue is "16:9" then
				set targetRatio to 16 / 9
				set ratio169Count to ratio169Count + 1
			else if aspectRatioValue is "3:2" then
				set targetRatio to 3 / 2
				set ratio32Count to ratio32Count + 1
			else if aspectRatioValue is "1:1" then
				set targetRatio to 1
				set ratio11Count to ratio11Count + 1
			else if aspectRatioValue is "65:24" then
				set targetRatio to 65 / 24
				set ratio6524Count to ratio6524Count + 1
			else if aspectRatioValue is "7:6" then
				set targetRatio to 7 / 6
				set ratio76Count to ratio76Count + 1
			else if aspectRatioValue is "5:4" then
				set targetRatio to 5 / 4
				set ratio54Count to ratio54Count + 1
			else if aspectRatioValue is "4:3" then
				set targetRatio to 4 / 3
				set ratio43Count to ratio43Count + 1
			else
				set otherRatioCount to otherRatioCount + 1
			end if
			
			if targetRatio > 0 then
				set currentRatio to imgWidth / imgHeight
				
				if currentRatio > targetRatio then
					set newWidth to imgHeight * targetRatio
					set newHeight to imgHeight
				else
					set newWidth to imgWidth
					set newHeight to imgWidth / targetRatio
				end if
				
				set newWidth to (round newWidth)
				set newHeight to (round newHeight)
				
				set cropCenterX to imgWidth / 2
				set cropCenterY to imgHeight / 2
				
				if newWidth < imgWidth or newHeight < imgHeight then
					set crop of currentVariant to {cropCenterX, cropCenterY, newWidth, newHeight}
					set croppedCount to croppedCount + 1
				end if
			else
				set errorCount to errorCount + 1
			end if
			
		on error
			set errorCount to errorCount + 1
		end try
		
		set processedCount to processedCount + 1
		set progress completed units to processedCount
		set progress text to "Processed " & processedCount & " of " & totalImages & " (Cropped: " & croppedCount & ")"
	end repeat
	
	set summaryMessage to "RESULTS:" & return
	set summaryMessage to summaryMessage & "Total images processed: " & totalImages & return
	set summaryMessage to summaryMessage & "Successfully cropped: " & croppedCount & return
	if errorCount > 0 then
		set summaryMessage to summaryMessage & "Errors encountered: " & errorCount & return
	end if
	
	set summaryMessage to summaryMessage & return & "ASPECT RATIOS FOUND:" & return
	if ratio43Count > 0 then
		set summaryMessage to summaryMessage & "4:3 (four thirds): " & ratio43Count & return
	end if
	if ratio32Count > 0 then
		set summaryMessage to summaryMessage & "3:2 (classic): " & ratio32Count & return
	end if
	if ratio169Count > 0 then
		set summaryMessage to summaryMessage & "16:9 (widescreen): " & ratio169Count & return
	end if
	if ratio11Count > 0 then
		set summaryMessage to summaryMessage & "1:1 (square): " & ratio11Count & return
	end if
	if ratio6524Count > 0 then
		set summaryMessage to summaryMessage & "65:24 (XPan / panoramic): " & ratio6524Count & return
	end if
	if ratio76Count > 0 then
		set summaryMessage to summaryMessage & "7:6 (portrait / medium format): " & ratio76Count & return
	end if
	if ratio54Count > 0 then
		set summaryMessage to summaryMessage & "5:4 (large format): " & ratio54Count & return
	end if
	if otherRatioCount > 0 then
		set summaryMessage to summaryMessage & "Other ratios: " & otherRatioCount & return
	end if
	
	display dialog summaryMessage buttons {"OK"} default button 1 with title "Aspect ratio to crop processing complete" with icon note
	
end tell
