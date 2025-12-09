-- Lessig-Hardt Slide Generator - CLI Version
-- Usage: osascript slide_generator_cli.scpt /path/to/slides.txt
-- Uses shared library for parsing and slide creation

on run argv
    if (count of argv) < 1 then
        log "Usage: osascript slide_generator_cli.scpt /path/to/slides.txt"
        error "No input file specified"
    end if

    -- Load the shared library
    set scriptPath to (path to me as text)
    set scriptFolder to text 1 thru -((offset of ":" in (reverse of characters of scriptPath as text))) of scriptPath
    set libPath to scriptFolder & "slide_generator_lib.scpt"
    set slideLib to load script file libPath

    -- Read input file
    set inputFile to item 1 of argv
    set slideContent to read POSIX file inputFile as «class utf8»

    -- Generate presentation using shared library
    set result to slideLib's generatePresentation(slideContent)
    set slideCount to slideCount of result

    return "Created " & slideCount & " slides"
end run
