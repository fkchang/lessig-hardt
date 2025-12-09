# Enhanced Plain Text Format Guide

## Overview

This guide explains how to create slides for your presentation using the enhanced plain text format. This format allows you to create slides by specifying only what you need to change from the defaults, making it efficient for creating minimalist Lessig/Hardt style presentations.

## Basic Structure

The only required element for each slide is a `TITLE:` line. Everything else is optional:

```
TITLE: Your slide text here
```

Slides are separated when a new `TITLE:` line is encountered.

## Properties and Default Values

### Basic Properties

| Property | Description | Options | Default | Status |
|----------|-------------|---------|---------|--------|
| `TITLE:` | The text for the slide | Any text | *(required)* | ✅ Implemented |
| `COLOR:` | The color of the text | blue, red, green, black, gray, white | black | ✅ Implemented |
| `SIZE:` | The font size | small, medium, large, xlarge | medium | ✅ Implemented |
| `BULLETS:` | Switches to bullet list slide | followed by `- ` lines | *(none)* | ✅ Implemented |
| `TRANS:` | Transition effect | dissolve, move, wipe, push, fade | none | ✅ Compiled .scpt |
| `BG:` | The background color | white, black, gray, blue, green, red | white | ❌ Keynote limitation |
| `POS:` | Text position (Statement slides only) | center, top, bottom | center | ❌ Keynote limitation |

### Slide Type Keywords

| Keyword | Creates | Additional Properties | Status |
|---------|---------|----------------------|--------|
| `SECTION:` | Section slide | `SUBTITLE:` for subtitle | ✅ Implemented |
| `AGENDA:` | Agenda slide | `- ` lines for items | ✅ Implemented |
| `QUOTE:` | Quote slide | `ATTRIBUTION:` for author | ✅ Implemented |
| `BIGFACT:` | Big Fact slide | `FACTTEXT:` for explanation | ✅ Implemented |

## Slide Types

### Statement Slides (Default)
Statement slides display a single centered text block. This is the default when you only use `TITLE:`.

### Title & Bullets Slides
When you add `BULLETS:` after a title, the slide switches to a "Title & Bullets" layout with the title at the top and bullet points below.

```
TITLE: Key Benefits
COLOR: blue
BULLETS:
- First benefit point
- Second benefit point
- Third benefit point
```

**Rules for bullets:**
- Each bullet must start with `- ` (dash followed by space)
- Bullets must appear after the `BULLETS:` line
- The `COLOR:` property applies to both title and bullet text
- A new `TITLE:` line ends bullet collection and starts a new slide

## Font Sizes

| Size | Point Size | Best For |
|------|------------|----------|
| small | 40pt | Longer phrases or multiple lines |
| medium | 60pt | Standard slides |
| large | 80pt | Most slides in Lessig style |
| xlarge | 120pt | One or two word slides for impact |

**Note:** The `SIZE:` property only applies to Statement slides. Title & Bullets slides use the master slide's default sizing.

## Color Combinations

### White Background (Default)
- Blue text - Section titles and key concepts
- Red text - Warnings or negative concepts
- Green text - Positive concepts, solutions, and refrains
- Black text - Standard content

### Black Background
- White text - Standard content (automatic when BG is dark)
- Green text - Positive concepts, solutions, and refrains
- Red text - Warnings or alerts

## Examples

### Minimal Example
```
TITLE: AI
COLOR: blue
SIZE: xlarge

TITLE: won't take your job

TITLE: someone using AI will
COLOR: red
```

### Title & Bullets Example
```
TITLE: Three Key Principles
COLOR: blue
BULLETS:
- Keep it simple
- Move fast
- Learn from feedback

TITLE: Next Steps
COLOR: green
BULLETS:
- Review the proposal
- Gather team input
- Schedule kickoff meeting
```

### Section Slide Example
```
SECTION: Part 1
SUBTITLE: Introduction and Background
```

### Agenda Slide Example
```
AGENDA: Today's Topics
- Project overview
- Technical deep dive
- Q&A session
```

### Quote Slide Example
```
QUOTE: Stay hungry, stay foolish.
ATTRIBUTION: — Steve Jobs
```

### Big Fact Slide Example
```
BIGFACT: 10x
FACTTEXT: Faster development with AI assistance
```

### Using Background Colors ❌ (Keynote AppleScript Limitation)
```
TITLE: Key Warning
COLOR: white
BG: red
```
**Note:** Keynote's AppleScript interface does not allow setting slide background colors programmatically. Background color must be set manually or by using a theme with the desired backgrounds.

### Positioning Content ❌ (Keynote AppleScript Limitation)
```
TITLE: Bottom Text
POS: bottom

TITLE: Top Header
POS: top
```
**Note:** Vertical text positioning requires Keynote properties not accessible via AppleScript.

### Setting Transitions ❌ (Keynote AppleScript Limitation)
```
TITLE: Dramatic Reveal
TRANS: wipe

TITLE: Smooth Fade
TRANS: fade
```
**Note:** Transition effects require compiled AppleScript format for multi-word enumeration constants.

## Tips for Lessig/Hardt Style

1. **Use size for emphasis**:
   - Use `SIZE: xlarge` for the most impactful, one-word slides
   - Use `SIZE: large` for most content
   - Reserve `SIZE: medium` or `SIZE: small` for more detailed slides

2. **Color coding for meaning**:
   - Use `COLOR: red` for warnings or negative concepts
   - Use `COLOR: green` for solutions or positive statements
   - Use `COLOR: blue` for key concepts or section titles

3. **Background contrast** (manual step required):
   - Keynote's AppleScript doesn't support setting backgrounds
   - After generating slides, manually change backgrounds in Keynote for dark slides
   - Or use a Keynote theme that has dark slide masters built-in

4. **Create visual rhythm**:
   - Group similar concepts with consistent formatting
   - Use a recurring phrase or theme as a reset point with consistent formatting

5. **Keep it minimal**:
   - Embrace the default values when possible
   - Only specify properties that deviate from defaults
