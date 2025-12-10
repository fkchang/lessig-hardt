# Lessig-Hardt Slide Generator

Generate Keynote presentations from simple text files using a minimal DSL (Domain Specific Language). Inspired by the presentation styles of Lawrence Lessig and Dick Hardt.

## What is Lessig/Hardt Style?

This presentation style emphasizes:
- **One idea per slide** - minimal text, maximum impact
- **Large typography** - easily readable from anywhere in the room
- **Rapid pacing** - many slides, quick transitions
- **Color for meaning** - semantic use of color to reinforce concepts

## Quick Start

1. Create a text file with your slide content:
```
TITLE: Hello
COLOR: blue
SIZE: xlarge

TITLE: World
COLOR: green
SIZE: xlarge
```

2. Run the generator:
```bash
# With a file (CLI mode)
bin/lessig_hardt slides.txt

# Without a file (opens file picker)
bin/lessig_hardt
```

3. A new Keynote presentation opens with your slides

## Slide Types

### Statement (Default)
Simple centered text - the core of Lessig-style presentations.
```
TITLE: Your message here
COLOR: blue
SIZE: large
```

### Bullets
Title with bullet points for lists.
```
TITLE: Key Points
BULLETS:
- First point
- Second point
- Third point
```

### Section
Section divider with title and subtitle.
```
SECTION: Part 1
SUBTITLE: Introduction
```

### Agenda
Meeting or presentation agenda.
```
AGENDA: Today's Topics
- First topic
- Second topic
- Third topic
```

### Quote
Quotation with attribution.
```
QUOTE: The best way to predict the future is to invent it.
ATTRIBUTION: — Alan Kay
```

### Big Fact
Highlight a key statistic or number.
```
BIGFACT: 10x
FACTTEXT: Faster with automation
```

## Formatting Options

### Colors
```
COLOR: blue    # Emphasis, key concepts
COLOR: red     # Warnings, negative points
COLOR: green   # Positive messages, solutions
COLOR: black   # Default
COLOR: gray    # Subtle, secondary text
COLOR: white   # For dark backgrounds (manual setup)
```

### Sizes
```
SIZE: small    # 40pt - longer text
SIZE: medium   # 60pt - default
SIZE: large    # 80pt - emphasis
SIZE: xlarge   # 120pt - maximum impact
```

### Transitions
Requires compiled `.scpt` format (included).
```
TRANS: dissolve
TRANS: fade
TRANS: wipe
TRANS: push
TRANS: move
```

## Files

| File | Purpose |
|------|---------|
| `bin/lessig_hardt` | Main entry point |
| `slide_generator.scpt` | Compiled AppleScript (handles CLI and GUI) |
| `slide_generator_lib.scpt` | Shared library |
| `text_format_dsl.md` | Complete DSL reference |
| `examples/` | Sample slide files |
| `tests/` | Test files with assertions |

## Development

```bash
rake compile    # Recompile AppleScript sources
rake test       # Run all tests with PDF assertions
rake test_one[name]  # Run single test and open PDF
rake clean      # Remove test output
```

## Known Limitations

Due to Keynote's AppleScript restrictions:
- **Background colors** cannot be set programmatically
- **Text positioning** (top/bottom) not accessible
- Transitions only work with compiled `.scpt` format

## Examples

See the `examples/` directory for sample presentations:
- `basic_statement.txt` - Simple statement slides
- `bullet_slides.txt` - Slides with bullet points
- `all_slide_types.txt` - Demonstrates all slide types
- `with_transitions.txt` - Using transition effects

## Requirements

- macOS
- Keynote

## License

MIT License - feel free to use and modify.
