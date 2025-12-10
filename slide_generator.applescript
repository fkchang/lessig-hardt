-- Lessig-Hardt Slide Generator
-- Usage:
--   osascript slide_generator.scpt           (opens file picker)
--   osascript slide_generator.scpt file.txt  (uses provided file)

on run argv
    -- Load the shared library
    set scriptPath to (path to me as text)
    set scriptFolder to text 1 thru -((offset of ":" in (reverse of characters of scriptPath as text))) of scriptPath
    set libPath to scriptFolder & "slide_generator_lib.scpt"
    set slideLib to load script file libPath

    -- Get input file: from argument or file picker
    if (count of argv) > 0 then
        set inputFile to item 1 of argv
        set slideContent to read POSIX file inputFile as «class utf8»
    else
        set theFile to choose file with prompt "Select the text file containing your slides content:"
        set slideContent to read theFile as «class utf8»
    end if

    -- Generate presentation using shared library
    set result to slideLib's generatePresentation(slideContent)
    set slideCount to slideCount of result

    if (count of argv) > 0 then
        return "Created " & slideCount & " slides"
    else
        display dialog "Created " & slideCount & " slides." buttons {"OK"} default button "OK"
    end if
end run
