# Lessig-Hardt Slide Generator

**Stop making slides. Start making statements.**

Remember Dick Hardt's legendary "Identity 2.0" talk at OSCON 2005? 256 slides in under 20 minutes. Each slide: one word, one idea, one heartbeat. The audience didn't just watch—they were *swept away*.

This tool lets you create that same hypnotic, rapid-fire presentation style from a simple text file.

## The Philosophy

Traditional slides are **boring**.

They're cluttered. They're slow. They make your audience read instead of listen.

Lessig-style presentations are different:

- **One idea per slide** — no clutter, no confusion
- **Giant typography** — readable from the back row
- **Rapid rhythm** — slides that move with your voice
- **Color as meaning** — not decoration

The result? Presentations that don't just inform—they *move* people.

## See It In Action

Your text file:
```
TITLE: We have
SIZE: large

TITLE: a problem
COLOR: red
SIZE: xlarge

TITLE: But
SIZE: medium

TITLE: we can fix it
COLOR: green
SIZE: xlarge
```

Becomes a presentation that *pulses* with your message.

## Installation

### One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/fkchang/lessig-hardt/main/install.sh | bash
```

### Manual Installation

```bash
git clone https://github.com/fkchang/lessig-hardt.git
cd lessig-hardt
./install.sh
```

### Requirements

- macOS (uses Keynote and AppleScript)
- [Keynote](https://www.apple.com/keynote/) (free from App Store)
- Xcode Command Line Tools (`xcode-select --install`)

## Quick Start

```bash
# Generate from a file
lessig_hardt my_talk.txt

# Or use the file picker
lessig_hardt
```

That's it. Your Keynote presentation appears, ready to captivate.

## Slide Types

### Statement (The Core)
The heartbeat of Lessig-style. One phrase. Full impact.
```
TITLE: Simple
COLOR: blue
SIZE: xlarge
```

### Cover
Your opening. Set the stage.
```
COVER: The Future of Everything
SUBTITLE: And Why It Matters
AUTHOR: Your Name
```

### Big Fact
When numbers speak louder than words.
```
BIGFACT: 10x
FACTTEXT: Faster than you thought possible
```

### Quote
Let someone else make your point.
```
QUOTE: The best way to predict the future is to invent it.
ATTRIBUTION: — Alan Kay
```

### Bullets
When you *must* list (use sparingly).
```
TITLE: Three Things
BULLETS:
- First thing
- Second thing
- Third thing
```

### Section & Agenda
Structure your narrative.
```
SECTION: Part One
SUBTITLE: The Problem

AGENDA: Today's Journey
- Where we are
- Where we're going
- How we get there
```

## Formatting

### Colors
```
COLOR: blue    # Key concepts, emphasis
COLOR: red     # Problems, warnings, passion
COLOR: green   # Solutions, success, hope
COLOR: black   # Neutral (default)
COLOR: white   # For dark themes
```

### Sizes
```
SIZE: xlarge   # 120pt — Maximum impact (1-2 words)
SIZE: large    # 80pt  — Strong emphasis
SIZE: medium   # 60pt  — Standard (default)
SIZE: small    # 40pt  — Longer phrases
```

### Transitions
```
TRANS: dissolve  # Smooth fade
TRANS: wipe      # Dramatic reveal
TRANS: push      # Slide in
TRANS: fade      # Through black
```

## Pro Tips

**Rhythm is everything.** Your slides should match your speaking cadence. One breath, one slide.

**Color sparingly.** When everything is emphasized, nothing is. Save red for what truly matters.

**Size for impact.** Your most important word? Make it huge. `SIZE: xlarge` is your exclamation point.

**Embrace the blank.** Pause between ideas. Let slides breathe. Silence is powerful.

## For Developers

### Setup

```bash
git clone https://github.com/fkchang/lessig-hardt.git
cd lessig-hardt

# Install test dependencies
gem install pdf-reader

# Compile AppleScript sources
rake compile
```

### Running Tests

```bash
rake test              # Run all tests
rake test_one[name]    # Run a single test (e.g., rake test_one[test_quote])
rake clean             # Clear test output
```

Tests use a self-documenting format with `#EXPECT:` assertions:

```
# Test: Quote slide with attribution
#EXPECT: pages=2
#EXPECT: page=2 contains="The best way to predict"

COVER: Test Presentation

QUOTE: The best way to predict the future is to invent it.
ATTRIBUTION: — Alan Kay
```

### Project Structure

```
├── bin/lessig_hardt                 # CLI entry point
├── slide_generator.applescript      # Main script (CLI/GUI)
├── slide_generator_lib.applescript  # Shared library
├── lib/pdf_assertions.rb            # Test framework
├── tests/                           # Test files with assertions
├── examples/                        # Example presentations
└── docs/                            # Additional documentation
    └── dsl-reference.md             # Detailed DSL reference
```

## The Secret

The magic isn't in the tool. It's in the *constraint*.

When you can only say one thing per slide, you're forced to know what that one thing *is*.

When your slides move fast, you can't hide behind them.

When there's nowhere to put filler, there's no filler.

These constraints don't limit you—they **free** you to communicate with clarity and power.

Now go make something that moves people.

---

## The Backstory

I've been using this presentation style since the mid-2000s, after seeing Dick Hardt's Identity 2.0 talk blow my mind at OSCON. The style is *incredibly* effective—but it was also incredibly tedious to create.

Each presentation meant hours in Keynote: click, type a word, adjust font size, set color, duplicate slide, repeat. For a 15-minute talk? That's 100+ slides. By hand. Every. Single. Time.

I tried org-reveal (Emacs org-mode to reveal.js)—great for quick slide decks, but it couldn't capture the Lessig/Hardt aesthetic. The typography was wrong. The rhythm was off. It felt like a compromise.

So I kept doing it manually. For years.

Then came LLMs.

Suddenly I realized: if I had a simple DSL, I could describe my presentation in plain text and let Claude or GPT help me draft the content. Instead of fighting with Keynote, I could focus on the *message*. The AI could help with the *words*.

This tool is the result. A simple text format that:
- Lets me sketch a talk in minutes
- Works beautifully with LLMs for brainstorming
- Compiles to real Keynote presentations with one command

What used to take hours now takes minutes. The constraint-based style that made these presentations powerful is now also what makes them fast to create.

*— Forrest Chang*

## License

MIT — Use it. Fork it. Present with it.
