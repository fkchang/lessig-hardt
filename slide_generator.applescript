-- Lessig-Hardt Slide Generator
-- This script converts a simple text file into a Keynote presentation
-- Supports both Statement slides and Title & Bullets slides

-- User selects the text file containing slide content
set theFile to choose file with prompt "Select the text file containing your slides content:"
set slideContent to read theFile as Çclass utf8È

-- Parse the slide data
set slideList to {}
set currentSlide to {slideTitle:"", slideColor:"black", slideSize:"medium", slideType:"statement", bulletPoints:{}, slideBG:"white", slidePos:"center", slideTrans:"none", slideBody:"", slideAuthor:""}
set slideLines to paragraphs of slideContent
set collectingBullets to false

repeat with i from 1 to count of slideLines
	set currentLine to item i of slideLines
	
	if currentLine starts with "TITLE: " then
		-- If we already have title data and find a new title, save the previous slide
		if slideTitle of currentSlide is not "" then
			copy currentSlide to end of slideList
			set currentSlide to {slideTitle:"", slideColor:"black", slideSize:"medium", slideType:"statement", bulletPoints:{}, slideBG:"white", slidePos:"center", slideTrans:"none", slideBody:"", slideAuthor:""}
		end if
		
		-- Extract the title text
		set slideTitle of currentSlide to text 8 thru end of currentLine
		set collectingBullets to false
		
	else if currentLine starts with "COLOR: " then
		-- Extract color
		set colorName to text 8 thru end of currentLine
		set slideColor of currentSlide to colorName
		set collectingBullets to false
		
	else if currentLine starts with "SIZE: " then
		-- Extract size
		set sizeName to text 7 thru end of currentLine
		set slideSize of currentSlide to sizeName
		set collectingBullets to false
		
	else if currentLine starts with "BG: " then
		-- Extract background color
		set bgName to text 5 thru end of currentLine
		set slideBG of currentSlide to bgName
		set collectingBullets to false
	
	else if currentLine starts with "POS: " then
		-- Extract text position
		set posName to text 6 thru end of currentLine
		set slidePos of currentSlide to posName
		set collectingBullets to false
	
	else if currentLine starts with "TRANS: " then
		-- Extract transition effect
		set transName to text 8 thru end of currentLine
		set slideTrans of currentSlide to transName
		set collectingBullets to false


	else if currentLine starts with "SECTION: " then
		-- Save previous slide if exists
		if slideTitle of currentSlide is not "" then
			copy currentSlide to end of slideList
			set currentSlide to {slideTitle:"", slideColor:"black", slideSize:"medium", slideType:"statement", bulletPoints:{}, slideBG:"white", slidePos:"center", slideTrans:"none", slideBody:"", slideAuthor:""}
		end if
		set slideTitle of currentSlide to text 10 thru end of currentLine
		set slideType of currentSlide to "section"
		set collectingBullets to false
	
	else if currentLine starts with "SUBTITLE: " then
		set slideBody of currentSlide to text 11 thru end of currentLine
		set collectingBullets to false
	
	else if currentLine starts with "AGENDA: " then
		if slideTitle of currentSlide is not "" then
			copy currentSlide to end of slideList
			set currentSlide to {slideTitle:"", slideColor:"black", slideSize:"medium", slideType:"statement", bulletPoints:{}, slideBG:"white", slidePos:"center", slideTrans:"none", slideBody:"", slideAuthor:""}
		end if
		set slideTitle of currentSlide to text 9 thru end of currentLine
		set slideType of currentSlide to "agenda"
		set collectingBullets to true
	
	else if currentLine starts with "QUOTE: " then
		if slideTitle of currentSlide is not "" then
			copy currentSlide to end of slideList
			set currentSlide to {slideTitle:"", slideColor:"black", slideSize:"medium", slideType:"statement", bulletPoints:{}, slideBG:"white", slidePos:"center", slideTrans:"none", slideBody:"", slideAuthor:""}
		end if
		set slideBody of currentSlide to text 8 thru end of currentLine
		set slideType of currentSlide to "quote"
		set collectingBullets to false
	
	else if currentLine starts with "ATTRIBUTION: " then
		set slideTitle of currentSlide to text 14 thru end of currentLine
		set collectingBullets to false
	
	else if currentLine starts with "BIGFACT: " then
		if slideTitle of currentSlide is not "" then
			copy currentSlide to end of slideList
			set currentSlide to {slideTitle:"", slideColor:"black", slideSize:"medium", slideType:"statement", bulletPoints:{}, slideBG:"white", slidePos:"center", slideTrans:"none", slideBody:"", slideAuthor:""}
		end if
		set slideTitle of currentSlide to text 10 thru end of currentLine
		set slideType of currentSlide to "bigfact"
		set collectingBullets to false
	
	else if currentLine starts with "FACTTEXT: " then
		set slideBody of currentSlide to text 11 thru end of currentLine
		set collectingBullets to false

	else if currentLine starts with "COVER: " then
		if slideTitle of currentSlide is not "" or slideBody of currentSlide is not "" then
			copy currentSlide to end of slideList
			set currentSlide to {slideTitle:"", slideColor:"black", slideSize:"medium", slideType:"statement", bulletPoints:{}, slideBG:"white", slidePos:"center", slideTrans:"none", slideBody:"", slideAuthor:""}
		end if
		set slideTitle of currentSlide to text 8 thru end of currentLine
		set slideType of currentSlide to "cover"
		set collectingBullets to false

	else if currentLine starts with "AUTHOR: " then
		set slideAuthor of currentSlide to text 9 thru end of currentLine
		set collectingBullets to false

	else if currentLine starts with "BULLETS:" then
		-- Mark this as a bullet slide
		set slideType of currentSlide to "bullets"
		set collectingBullets to true
		
	else if collectingBullets and currentLine starts with "- " then
		-- Add bullet point (remove the "- " prefix)
		set bulletText to text 3 thru end of currentLine
		copy bulletText to end of bulletPoints of currentSlide
		
	end if
end repeat

-- Add the last slide if it has content
if slideTitle of currentSlide is not "" then
	copy currentSlide to end of slideList
end if

-- Create slides in Keynote
tell application "Keynote"
	-- Create new document
	activate
	set newDoc to make new document
	
	-- Find the master slides we need
	set statementMaster to missing value
	set titleBulletsMaster to missing value
	set sectionMaster to missing value
	set agendaMaster to missing value
	set quoteMaster to missing value
	set bigFactMaster to missing value
	
	repeat with m in slide layouts of newDoc
		if name of m is "Statement" then
			set statementMaster to m
		else if name of m is "Title & Bullets" then
			set titleBulletsMaster to m
		else if name of m is "Section" then
			set sectionMaster to m
		else if name of m is "Agenda" then
			set agendaMaster to m
		else if name of m is "Quote" then
			set quoteMaster to m
		else if name of m is "Big Fact" then
			set bigFactMaster to m
		end if
	end repeat
	
	-- Check if first slide is a cover slide
	set hasCover to false
	if (count of slideList) > 0 then
		if slideType of item 1 of slideList is "cover" then
			set hasCover to true
		end if
	end if
	
	-- Delete the default first slide only if no cover
	if not hasCover then
		try
			delete slide 1 of newDoc
		end try
	end if
	
	-- Process each slide
	repeat with aSlide in slideList
		-- Create a new slide with appropriate master
		if slideType of aSlide is "cover" then
			-- Use the existing first slide for cover
			set newSlide to slide 1 of newDoc
		else if slideType of aSlide is "statement" and statementMaster is not missing value then
			set newSlide to make new slide with properties {base layout:statementMaster} at end of slides of newDoc
		else if slideType of aSlide is "bullets" and titleBulletsMaster is not missing value then
			set newSlide to make new slide with properties {base layout:titleBulletsMaster} at end of slides of newDoc
		else if slideType of aSlide is "section" and sectionMaster is not missing value then
			set newSlide to make new slide with properties {base layout:sectionMaster} at end of slides of newDoc
		else if slideType of aSlide is "agenda" and agendaMaster is not missing value then
			set newSlide to make new slide with properties {base layout:agendaMaster} at end of slides of newDoc
		else if slideType of aSlide is "quote" and quoteMaster is not missing value then
			set newSlide to make new slide with properties {base layout:quoteMaster} at end of slides of newDoc
		else if slideType of aSlide is "bigfact" and bigFactMaster is not missing value then
			set newSlide to make new slide with properties {base layout:bigFactMaster} at end of slides of newDoc
		else
			-- Fallback to default slide
			set newSlide to make new slide at end of slides of newDoc
		end if
		
		-- Convert color name to RGB
		log "Processing slide: " & slideTitle of aSlide & " with color: " & slideColor of aSlide
		set textColor to {0, 0, 0} -- Default: black
		log "Default textColor set to black"
		
		if slideColor of aSlide is "blue" then
			set textColor to {0, 0, 65535} -- Deep blue
		else if slideColor of aSlide is "red" then
			set textColor to {65535, 0, 0} -- Deep red
		else if slideColor of aSlide is "green" then
			set textColor to {0, 65535, 0} -- Deep green 
		else if slideColor of aSlide is "gray" then
			set textColor to {32768, 32768, 32768} -- Gray
		else if slideColor of aSlide is "white" then
			set textColor to {65535, 65535, 65535} -- White
		end if
		
		-- Set font size based on size property
		set fontSize to 60 -- Default: medium
		
		if slideSize of aSlide is "small" then
			set fontSize to 40
		else if slideSize of aSlide is "large" then
			set fontSize to 80
		else if slideSize of aSlide is "xlarge" then
			set fontSize to 120
		end if
		
		-- Set transition effect
		if slideTrans of aSlide is not "none" then
			tell newSlide
				if slideTrans of aSlide is "dissolve" then
					set its transition properties to {transition effect:dissolve, transition duration:1.0}
				else if slideTrans of aSlide is "move" then
					set its transition properties to {transition effect:magic move, transition duration:1.0}
				else if slideTrans of aSlide is "wipe" then
					set its transition properties to {transition effect:wipe, transition duration:1.0}
				else if slideTrans of aSlide is "push" then
					set its transition properties to {transition effect:push, transition duration:1.0}
				else if slideTrans of aSlide is "fade" then
					set its transition properties to {transition effect:fade through color, transition duration:1.0}
				end if
			end tell
		end if

		-- Set text content and formatting
		tell newSlide
			-- For statement slides (or fallback)
			if slideType of aSlide is "statement" then
				-- Make sure body is showing
				set body showing to true
				
				-- Set the text content and properties
				set object text of default body item to slideTitle of aSlide
				set color of object text of default body item to textColor
				log "Applied textColor to body"
				set size of object text of default body item to fontSize
				
				-- For bullet slides
			else if slideType of aSlide is "bullets" then
				-- Set the title
				set object text of default title item to slideTitle of aSlide
				set color of object text of default title item to textColor
				
				-- Create bullet text from the list
				set bulletText to ""
				repeat with bulletPoint in bulletPoints of aSlide
					set bulletText to bulletText & bulletPoint & return
				end repeat
				
				-- Remove the last return character if any bullets exist
				if length of bulletText > 0 then
					set bulletText to text 1 thru ((length of bulletText) - 1) of bulletText
				end if
				
				-- Set the bullet points and properties
				set object text of default body item to bulletText
				set color of object text of default body item to textColor
				log "Applied textColor to body"
			
			-- For section slides
			else if slideType of aSlide is "section" then
				set object text of default title item to slideTitle of aSlide
				set color of object text of default title item to textColor
				if slideBody of aSlide is not "" then
					set object text of default body item to slideBody of aSlide
					set color of object text of default body item to textColor
				end if
			
			-- For agenda slides
			else if slideType of aSlide is "agenda" then
				set object text of default title item to slideTitle of aSlide
				set color of object text of default title item to textColor
				-- Build agenda items from bullet points
				set agendaText to ""
				repeat with agendaItem in bulletPoints of aSlide
					set agendaText to agendaText & agendaItem & return
				end repeat
				if length of agendaText > 0 then
					set agendaText to text 1 thru ((length of agendaText) - 1) of agendaText
				end if
				set object text of default body item to agendaText
				set color of object text of default body item to textColor
			
			-- For quote slides
			else if slideType of aSlide is "quote" then
				set object text of default body item to slideBody of aSlide
				set color of object text of default body item to textColor
				if slideTitle of aSlide is not "" then
					set object text of default title item to slideTitle of aSlide
					set color of object text of default title item to textColor
				end if
			
			-- For big fact slides
			else if slideType of aSlide is "bigfact" then
				-- Big Fact: text item 4 is big number, text item 2 is explanation
				set object text of text item 4 to slideTitle of aSlide
				set color of object text of text item 4 to textColor
				if slideBody of aSlide is not "" then
					set object text of text item 2 to slideBody of aSlide
					set color of object text of text item 2 to textColor
				end if
			
			-- For cover slides
			else if slideType of aSlide is "cover" then
				-- Cover: text item 4 = title, text item 5 = subtitle, text item 1 = author
				set object text of text item 4 to slideTitle of aSlide
				set color of object text of text item 4 to textColor
				if slideBody of aSlide is not "" then
					set object text of text item 5 to slideBody of aSlide
					set color of object text of text item 5 to textColor
				end if
				if slideAuthor of aSlide is not "" then
					set object text of text item 1 to slideAuthor of aSlide
					set color of object text of text item 1 to textColor
				end if
			end if
		end tell
	end repeat
end tell

display dialog "Created " & (count of slideList) & " slides. Check Script Editor log for details." buttons {"OK"} default button "OK"
