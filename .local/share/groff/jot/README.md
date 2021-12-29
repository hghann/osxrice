    troff is the assembly language of text setting, lots of newlines

Cinap Lenrek, 9front.org

# Jot - a Pre-Processor for the Groff/Troff Typesetting System

## What is this?

Jot is a preprocessor for the Groff/Troff typesetting system. It takes
text in a markdown-esque syntax and outputs readable Groff/Troff code.
It's in early alpha right now, but I haven't been able to break it just
yet, so try it and tell me how quick it took you.

## Why Does This Exist?

When I wrote this software, I was going into my freshman year of college.
I wanted a text format I could take class notes with quickly.  I really
like [Markdown](https://daringfireball.net/projects/markdown/), but I
wanted it to output Postscript or PDF, not HTML, and I didn't want to
use LaTeX and/or Pandoc, both fantastic systems but far too large for
my small laptop.  I also wanted to use the fantastic EQN preprocessor
for my math courses - but existing markdown to groff outputs just compile
markdown, they don't allow one to inline markdown into their groff.

## What Does it Do?
Jot works similarly to Brian Kerningham's EQN package, which sections
off part of a Groff/Troff document used for a specific purpose.  In EQN,
everything in a sectioned off area is written in the EQN language,
a DSL made for expressing equations.

Similarly, Jot allows you to section off areas of a Groff/Troff document
and format them with a DSL, except in this case the DSL is a kind of
mini-markdown.  Jot allows you to make writable and grockable sections
of text quickly without having to manage indents or paragraphs.

An example jot document may look like this:

```
.TL
My Jot Document
.AU
@rvs314

.JS

# My Awesome Document
## Section One

I can now write in ***markdown***-kinda!
My paragraphs are seperated by empty lines, so I don't need to manage tags.

    Paragraphs that start with an indent are indented.
Whitespace is accepted here, any number/combination of spaces and tabs.

.JE
```

You can see what this example document looks like when compiled in the
examples directory as readme.ms.

### Current Features

* Whitespace-based paragraph seperators
* Whitespace-based indenting
* Bolding and Italics and Constant-Width
* Superscript and Subscript
* Lists
* Blockquotes
* Code Blocks
* Escaping, allowing one to use EQN or PIC without leaving jot
* ≅ 500 LOC

### Unplanned Features

* Complete Markdown compliance

### Why not CommonMark or GFM?

1. Both of those systems only output to HTML, while Groff outputs to many formats, meaning features may change based on output.
2. Those formats rely on markdown's HTML roots, which represent the data as a tree. (G/T)roff is a line-based language from its Unix roots, so things that may seem idiomatic in HTML (and therefore CommonMark or GFM) aren't so in Jot.
3. Keeping a simpler formatting system makes the codebase more hackable.

## Similar Projects

* [R Markdown](https://rmarkdown.rstudio.com/) A markdown(ish) to LaTeX/HTML converter
* [lowdown](https://kristaps.bsd.lv/lowdown/) A markdown to HTML5/Groff translator (not a preprocessor)
