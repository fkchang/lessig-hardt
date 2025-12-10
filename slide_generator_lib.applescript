-- Lessig-Hardt Slide Generator Library
-- Shared code for parsing DSL and creating Keynote slides
-- Used by both GUI and CLI versions

-- Parse slide content from text
on parseSlideContent(slideContent)
    set slideList to {}
    set currentSlide to {slideTitle:"", slideColor:"black", slideSize:"medium", slideType:"statement", bulletPoints:{}, slideBG:"white", slidePos:"center", slideTrans:"none", slideBody:"", slideAuthor:""}
    set slideLines to paragraphs of slideContent
    set collectingBullets to false

    repeat with i from 1 to count of slideLines
        set currentLine to item i of slideLines

        if currentLine starts with "TITLE: " then
            if slideTitle of currentSlide is not "" then
                copy currentSlide to end of slideList
                set currentSlide to {slideTitle:"", slideColor:"black", slideSize:"medium", slideType:"statement", bulletPoints:{}, slideBG:"white", slidePos:"center", slideTrans:"none", slideBody:"", slideAuthor:""}
            end if
            set slideTitle of currentSlide to text 8 thru end of currentLine
            set collectingBullets to false

        else if currentLine starts with "COLOR: " then
            set slideColor of currentSlide to text 8 thru end of currentLine
            set collectingBullets to false

        else if currentLine starts with "SIZE: " then
            set slideSize of currentSlide to text 7 thru end of currentLine
            set collectingBullets to false

        else if currentLine starts with "BG: " then
            set slideBG of currentSlide to text 5 thru end of currentLine
            set collectingBullets to false

        else if currentLine starts with "POS: " then
            set slidePos of currentSlide to text 6 thru end of currentLine
            set collectingBullets to false

        else if currentLine starts with "TRANS: " then
            set slideTrans of currentSlide to text 8 thru end of currentLine
            set collectingBullets to false

        else if currentLine starts with "SECTION: " then
            if slideTitle of currentSlide is not "" or slideBody of currentSlide is not "" then
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
            if slideTitle of currentSlide is not "" or slideBody of currentSlide is not "" then
                copy currentSlide to end of slideList
                set currentSlide to {slideTitle:"", slideColor:"black", slideSize:"medium", slideType:"statement", bulletPoints:{}, slideBG:"white", slidePos:"center", slideTrans:"none", slideBody:"", slideAuthor:""}
            end if
            set slideTitle of currentSlide to text 9 thru end of currentLine
            set slideType of currentSlide to "agenda"
            set collectingBullets to true

        else if currentLine starts with "QUOTE: " then
            if slideTitle of currentSlide is not "" or slideBody of currentSlide is not "" then
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
            if slideTitle of currentSlide is not "" or slideBody of currentSlide is not "" then
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
            set slideType of currentSlide to "bullets"
            set collectingBullets to true

        else if collectingBullets and currentLine starts with "- " then
            copy (text 3 thru end of currentLine) to end of bulletPoints of currentSlide

        end if
    end repeat

    -- Add the last slide if it has content
    if slideTitle of currentSlide is not "" or slideBody of currentSlide is not "" then
        copy currentSlide to end of slideList
    end if

    return slideList
end parseSlideContent

-- Convert color name to RGB
on colorNameToRGB(colorName)
    if colorName is "blue" then
        return {0, 0, 65535}
    else if colorName is "red" then
        return {65535, 0, 0}
    else if colorName is "green" then
        return {0, 65535, 0}
    else if colorName is "gray" then
        return {32768, 32768, 32768}
    else if colorName is "white" then
        return {65535, 65535, 65535}
    else
        return {0, 0, 0} -- black default
    end if
end colorNameToRGB

-- Convert size name to font size
on sizeNameToFontSize(sizeName)
    if sizeName is "small" then
        return 40
    else if sizeName is "large" then
        return 80
    else if sizeName is "xlarge" then
        return 120
    else
        return 60 -- medium default
    end if
end sizeNameToFontSize

-- Create slides in Keynote from parsed slide list
on createKeynoteSlides(slideList)
    tell application "Keynote"
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
                set newSlide to make new slide at end of slides of newDoc
            end if

            -- Get color and size
            set textColor to my colorNameToRGB(slideColor of aSlide)
            set fontSize to my sizeNameToFontSize(slideSize of aSlide)

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
                if slideType of aSlide is "statement" then
                    set body showing to true
                    set object text of default body item to slideTitle of aSlide
                    set color of object text of default body item to textColor
                    set size of object text of default body item to fontSize

                else if slideType of aSlide is "bullets" then
                    set object text of default title item to slideTitle of aSlide
                    set color of object text of default title item to textColor
                    set bulletText to ""
                    repeat with bulletPoint in bulletPoints of aSlide
                        set bulletText to bulletText & bulletPoint & return
                    end repeat
                    if length of bulletText > 0 then
                        set bulletText to text 1 thru ((length of bulletText) - 1) of bulletText
                    end if
                    set object text of default body item to bulletText
                    set color of object text of default body item to textColor

                else if slideType of aSlide is "section" then
                    set object text of default title item to slideTitle of aSlide
                    set color of object text of default title item to textColor
                    if slideBody of aSlide is not "" then
                        set object text of default body item to slideBody of aSlide
                        set color of object text of default body item to textColor
                    end if

                else if slideType of aSlide is "agenda" then
                    set object text of default title item to slideTitle of aSlide
                    set color of object text of default title item to textColor
                    set agendaText to ""
                    repeat with agendaItem in bulletPoints of aSlide
                        set agendaText to agendaText & agendaItem & return
                    end repeat
                    if length of agendaText > 0 then
                        set agendaText to text 1 thru ((length of agendaText) - 1) of agendaText
                    end if
                    set object text of default body item to agendaText
                    set color of object text of default body item to textColor

                else if slideType of aSlide is "quote" then
                    -- Quote layout: text item 4 = quote text, text item 1 = attribution
                    set object text of text item 4 to slideBody of aSlide
                    set color of object text of text item 4 to textColor
                    if slideTitle of aSlide is not "" then
                        set object text of text item 1 to slideTitle of aSlide
                        set color of object text of text item 1 to textColor
                    end if

                else if slideType of aSlide is "bigfact" then
                    set object text of text item 4 to slideTitle of aSlide
                    set color of object text of text item 4 to textColor
                    if slideBody of aSlide is not "" then
                        set object text of text item 2 to slideBody of aSlide
                        set color of object text of text item 2 to textColor
                    end if

                else if slideType of aSlide is "cover" then
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

        return newDoc
    end tell
end createKeynoteSlides

-- Main entry point: parse content and create slides
on generatePresentation(slideContent)
    set slideList to parseSlideContent(slideContent)
    set newDoc to createKeynoteSlides(slideList)
    return {slideCount:(count of slideList), document:newDoc}
end generatePresentation
