# CLAUDE.md - Lessig/Hardt Slide Generator

## Project Overview

AppleScript-based tool that generates Keynote presentations from a simple text DSL format. Designed for creating minimalist Lessig/Hardt style presentations.

## Architecture

```
bin/lessig_hardt           - Main entry point (bash wrapper)
slide_generator_lib.scpt   - Shared library (parsing + slide creation)
slide_generator.scpt       - Unified script (handles CLI and GUI modes)
*.applescript              - Source files (compile with rake compile)
lib/pdf_assertions.rb      - PDF testing framework
tests/*.txt                - Test files with #EXPECT assertions
Rakefile                   - Build and test automation
```

The unified script handles both modes:
- With file argument: CLI mode, no dialogs
- Without argument: GUI mode, file picker dialog

## Working Features

### Basic Properties
- `TITLE:` - slide text (required for statement slides)
- `COLOR:` - text color (blue, red, green, black, gray, white)
- `SIZE:` - font size (small/40pt, medium/60pt, large/80pt, xlarge/120pt)
- `BULLETS:` - switches to Title & Bullets slide layout
- `TRANS:` - transitions (dissolve, move, wipe, push, fade) - requires compiled .scpt

### Slide Type Keywords
- `COVER:` + `SUBTITLE:` + `AUTHOR:` - Title/cover slides (uses Keynote's default first slide)
- `SECTION:` + `SUBTITLE:` - Section header slides
- `AGENDA:` + `- items` - Agenda slides
- `QUOTE:` + `ATTRIBUTION:` - Quote slides
- `BIGFACT:` + `FACTTEXT:` - Big fact/statistic slides

## Keynote AppleScript Limitations Discovered

These features are **parsed by the DSL** but **cannot be applied** due to Keynote's AppleScript limitations:

| Feature | Limitation |
|---------|------------|
| `BG:` (background color) | `background color` property is **read-only** on slides and shapes |
| `POS:` (text position) | `vertical alignment` property not accessible via AppleScript |
| `BUILD:` (bullet animations) | Build/animation APIs not exposed in AppleScript dictionary |
| `TRANS:` (transitions) | Works in compiled `.scpt` format (now included) |

## Debugging Keynote AppleScript

When working with AppleScript automation for macOS apps, use `osascript` to discover what's actually possible vs. what the documentation claims.

### 1. Test Compilation vs. Runtime

```bash
# Test if syntax compiles (catches multi-word enum issues)
osacompile -o /dev/null script.applescript 2>&1

# Run and capture errors
osascript script.applescript 2>&1
```

### 2. Discover Object Properties

```bash
osascript << 'EOF'
tell application "Keynote"
    set newDoc to make new document
    tell slide 1 of newDoc
        log (properties as text)
    end tell
    close newDoc saving no
end tell
EOF
```

This reveals what properties are actually exposed (vs. what documentation claims).

### 3. Enumerate Available Layouts

```bash
osascript << 'EOF'
tell application "Keynote"
    set newDoc to make new document
    repeat with m in slide layouts of newDoc
        log name of m
    end repeat
    close newDoc saving no
end tell
EOF
```

### 4. Explore Text Items in a Slide Layout

Different layouts have different text item indices. Use this to find which index corresponds to which field:

```bash
osascript << 'EOF'
tell application "Keynote"
    set newDoc to make new document

    -- Find the layout you want to explore
    set targetMaster to missing value
    repeat with m in slide layouts of newDoc
        if name of m is "Big Fact" then
            set targetMaster to m
        end if
    end repeat

    delete slide 1 of newDoc
    set newSlide to make new slide with properties {base layout:targetMaster} at end of slides of newDoc

    tell newSlide
        log "=== Text items ==="
        set idx to 1
        repeat with ti in text items
            try
                set object text of ti to "Item " & idx
                log "Text item " & idx & ": set successfully"
            on error errMsg
                log "Text item " & idx & ": " & errMsg
            end try
            set idx to idx + 1
        end repeat
    end tell

    export newDoc to POSIX file "/tmp/layout_explore.pdf" as PDF
    close newDoc saving no
end tell
EOF
open /tmp/layout_explore.pdf
```

This sets each text item to "Item N" so you can visually identify which index controls which field.

### 5. Test Property Writability

```bash
osascript << 'EOF'
tell application "Keynote"
    set newDoc to make new document
    tell slide 1 of newDoc
        try
            set its background color to {0, 0, 0}
            log "Success"
        on error errMsg
            log "Failed: " & errMsg
        end try
    end tell
    close newDoc saving no
end tell
EOF
```

**Key insight:** Many properties are readable but not writable. Always test writes.

### 6. Check AppleScript Dictionary (if sdef available)

```bash
# Requires Xcode for sdef tool, otherwise:
cat /Applications/Keynote.app/Contents/Resources/Keynote.sdef | grep -i "build\|animation"
```

## File Encoding Warning

AppleScript files use MacRoman encoding for special characters like `«class utf8»` (chevrons).

**Problem:** Text editors and tools that assume UTF-8 will corrupt these characters, causing "Expected expression but found unknown token" errors.

**Solution:** Use `LC_ALL=C sed` for edits to preserve byte encoding:

```bash
LC_ALL=C sed -i '' 's/old/new/' script.applescript
```

**Do NOT use:** Standard text editor save, or tools that re-encode files.

For major changes, use Python with binary mode to preserve encoding:

```python
with open('script.applescript', 'rb') as f:
    content = f.read()
content = content.replace(b'old', b'new')
with open('script.applescript', 'wb') as f:
    f.write(content)
```

## Testing Framework

Tests use PDF content assertions to verify generated slides contain expected text.

### Running Tests

```bash
rake test           # Run all tests
rake test_one[name] # Run single test and open PDF
rake compile        # Recompile all AppleScript sources
rake clean          # Remove test output
```

### Writing Tests

Test files are DSL files with `#EXPECT:` comment lines defining assertions:

```
# Test: Description of what this tests
#EXPECT: pages=3
#EXPECT: page=1 contains="Title Text"
#EXPECT: page=2 contains="Body Content"
#EXPECT: page=3 not_contains="Forbidden Text"

COVER: Title Text
SUBTITLE: Subtitle

TITLE: Body Content
```

### Assertion Types

| Assertion | Description |
|-----------|-------------|
| `pages=N` | Verify total page count |
| `page=N contains="text"` | Page N contains text (whitespace-normalized) |
| `page=N not_contains="text"` | Page N does NOT contain text |

### How It Works

1. `rake test` generates PDFs from test files using `slide_generator_cli.scpt`
2. Uses `pdf-reader` gem to extract text from each page
3. Compares against `#EXPECT:` assertions in the test file
4. Reports pass/fail with details on assertion failures

**Note:** PDF text extraction can insert spurious spaces within words due to how Keynote spaces characters. The assertion framework normalizes whitespace (removes all spaces) before comparison for robustness.

## Rake Tasks

| Task | Description |
|------|-------------|
| `rake` or `rake test` | Run all tests with PDF assertions |
| `rake test_one[name]` | Run single test, show assertions, open PDF |
| `rake compile` | Compile all .applescript to .scpt |
| `rake clean` | Remove test_output directory |
| `rake generate[file]` | Generate presentation from file |

## Possible Workarounds for Limitations

### Background Colors
- Use a Keynote theme with dark slide masters pre-built
- Manually set backgrounds after generation
- Create a JXA (JavaScript for Automation) solution instead of AppleScript

### Build Animations
- Must be added manually in Keynote after generation
- Keynote AppleScript dictionary does not expose build creation

### Text Position
- Create custom master slides with text boxes positioned differently
- Use different master slide names in the script

## Rebuilding

After editing any `.applescript` file, recompile:
```bash
rake compile
```

Library must be compiled first since other scripts depend on it.
