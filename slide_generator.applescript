-- Lessig-Hardt Slide Generator - GUI Version
-- This script converts a simple text file into a Keynote presentation
-- Uses shared library for parsing and slide creation

-- Load the shared library
set scriptPath to (path to me as text)
set scriptFolder to text 1 thru -((offset of ":" in (reverse of characters of scriptPath as text))) of scriptPath
set libPath to scriptFolder & "slide_generator_lib.scpt"
set slideLib to load script file libPath

-- User selects the text file containing slide content
set theFile to choose file with prompt "Select the text file containing your slides content:"
set slideContent to read theFile as «class utf8»

-- Generate presentation using shared library
set result to slideLib's generatePresentation(slideContent)
set slideCount to slideCount of result

display dialog "Created " & slideCount & " slides." buttons {"OK"} default button "OK"
