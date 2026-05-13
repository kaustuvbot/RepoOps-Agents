---
name: pdf-split
description: Split PDFs by content, bookmarks, or page count
---

# PDF Split

Split PDF documents using AI-powered content analysis.

## Prerequisites

- renamed.to account
- CLI: `brew tap renamed-to/cli && brew install renamed`
- Auth: `renamed auth login`

## Commands

```bash
# Split by AI content analysis (default)
renamed pdf-split file.pdf

# Split every N pages
renamed pdf-split file.pdf --mode every-n --every 5

# Split by bookmarks
renamed pdf-split file.pdf --mode bookmarks

# With custom output directory
renamed pdf-split file.pdf -o ~/output/

# With AI instructions
renamed pdf-split file.pdf --prompt "Split at chapter boundaries"

# JSON output
renamed pdf-split file.pdf --json
```

## Modes

| Mode | Description |
|------|-------------|
| `smart` | AI-powered content analysis (default) |
| `every-n` | Fixed page intervals |
| `bookmarks` | Split by PDF bookmarks |

## Fallback

If CLI unavailable, use MCP tools from `renamed-to/mcp.renamed.to`.