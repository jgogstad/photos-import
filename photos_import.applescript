on hazelProcessFile(theFile, inputAttributes)
	tell application "Finder"
		set albumContainer to theFile
		set yearContainer to container of albumContainer
		# Remove first word from albumName, i.e. "2017-09-18 My album name" => "My album name"
		set albumName to do shell script "sed -E 's/^[^ ]* //' <<<" & quoted form of (name of albumContainer as text)
		set yearName to name of yearContainer as text
	end tell
	tell application "Photos"
		set folderExists to exists folder named yearName
		if (not folderExists) then
			make new folder named yearName
		end if
		
		set targetFolder to get folder yearName
		set albumExists to exists album named albumName in targetFolder
		if (not albumExists) then
			make new album named albumName at targetFolder
		end if
		set targetAlbum to get album albumName in targetFolder
		
		set nonProcessed to paragraphs of (do shell script "/usr/local/bin/exiftool -p '$FileName $Keywords' " & quoted form of POSIX path of albumContainer & " 2>&1 | grep -Ev 'Processed|directories scanned|image files read' | sed -E -e 's/^Warning.*\\/(.*\\.jpg).*/\\1/' -e 's/^(.*\\.jpg) .*/\\1/' ")
		
		tell application "Finder" to set nonProcessedFiles to every file in theFile whose name is in nonProcessed
		set posixPaths to {}
		set imageList to {}
		repeat with f in nonProcessedFiles
			set end of posixPaths to "\"" & POSIX path of theFile & name of f & "\""
			set end of imageList to f as alias
		end repeat
		
		set imported to import imageList into targetAlbum skip check duplicates no
		repeat with i in imported
			set kws to the keywords of i
			if kws is missing value or kws is {} then
				set kws to {"Processed"}
			else
				set end of kws to "Processed"
			end if
			set keywords of i to kws
		end repeat
	end tell
	
	set tid to text item delimiters
	set text item delimiters to " "
	do shell script "/usr/local/bin/exiftool -overwrite_original -Keywords+=Processed " & posixPaths as text
	set text item delimiters to tid
end hazelProcessFile
