# CLAUDE.md - Lessig/Hardt Slide Generator

## Project Overview

AppleScript-based tool that generates Keynote presentations from a simple text DSL format. Designed for creating minimalist Lessig/Hardt style presentations.

## Working Features

- `TITLE:` - slide text (required)
- `COLOR:` - text color (blue, red, green, black, gray, white)
- `SIZE:` - font size (small/40pt, medium/60pt, large/80pt, xlarge/120pt)
- `BULLETS:` - switches to Title & Bullets slide layout

## Keynote AppleScript Limitations Discovered

These features are **parsed by the DSL** but **cannot be applied** due to Keynote's AppleScript limitations:

| Feature | Limitation |
|---------|------------|
| `BG:` (background color) | `background color` property is **read-only** on slides and shapes |
| `POS:` (text position) | `vertical alignment` property not accessible via AppleScript |
| `TRANS:` (transitions) | Multi-word enums like `magic move` only work in compiled `.scpt` format |

## Technique: Exploring AppleScript Capabilities

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
cat > /tmp/test.applescript << 'ENDSCRIPT'
tell application "Keynote"
    activate
    set newDoc to make new document
    tell slide 1 of newDoc
        get properties
    end tell
end tell
ENDSCRIPT
osascript /tmp/test.applescript 2>&1 | tr ',' '\n'
```

This reveals what properties are actually exposed (vs. what documentation claims).

### 3. Test Property Writability

```bash
cat > /tmp/test.applescript << 'ENDSCRIPT'
tell application "Keynote"
    activate
    set newDoc to make new document
    tell slide 1 of newDoc
        try
            set its background color to {0, 0, 0}
            log "Success"
        on error errMsg
            log "Failed: " & errMsg
        end try
    end tell
end tell
ENDSCRIPT
osascript /tmp/test.applescript 2>&1
```

**Key insight:** Many properties are readable but not writable. Always test writes.

### 4. Heredoc for Quick Tests

Use bash heredocs to create test scripts without file encoding issues:

```bash
cat > /tmp/test.applescript << 'ENDSCRIPT'
-- Your AppleScript here
ENDSCRIPT
osascript /tmp/test.applescript 2>&1
```

The `'ENDSCRIPT'` (quoted) prevents shell variable expansion.

## File Encoding Warning

AppleScript files use MacRoman encoding for special characters like `«class utf8»` (chevrons).

**Problem:** Text editors and tools that assume UTF-8 will corrupt these characters, causing "Expected expression but found unknown token" errors.

**Solution:** Use `LC_ALL=C sed` for edits to preserve byte encoding:

```bash
LC_ALL=C sed -i '' 's/old/new/' script.applescript
```

**Do NOT use:** Standard text editor save, or tools that re-encode files.

## Possible Workarounds for Limitations

### Background Colors
- Use a Keynote theme with dark slide masters pre-built
- Manually set backgrounds after generation
- Create a JXA (JavaScript for Automation) solution instead of AppleScript

### Transitions
- Save the .applescript as compiled .scpt from Script Editor
- Or apply transitions manually after generation

### Text Position
- Create custom master slides with text boxes positioned differently
- Use different master slide names in the script

## File Structure

```
slide_generator.applescript  - Main generator script
text_format_dsl.md          - DSL documentation for users
CLAUDE.md                   - This file (for LLMs)
```
