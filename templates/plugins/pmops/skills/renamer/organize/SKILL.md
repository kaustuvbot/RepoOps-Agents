---
name: organize
description: Full directory organization workflow
---

# Organize Files

Complete directory workflow combining PDF splitting, AI renaming, and watch mode.

## Prerequisites

- renamed.to account
- CLI: `brew tap renamed-to/cli && brew install renamed`
- Auth: `renamed auth login`

## Workflow

1. Scan directory with `Glob` to inventory files
2. Split multi-document PDFs if needed
3. Preview and apply renames via `renamed rename`
4. Show summary of completed actions
5. Offer watch mode for automatic processing

## Commands

```bash
# Preview all renames
renamed rename --preview ~/path/*

# Apply all renames
renamed rename -a ~/path/*

# Watch mode for automatic processing
renamed watch ~/inbox -o ~/output

# Split PDFs with wait
renamed pdf-split file.pdf --wait
```

## Tips

- For large directories: process in batches of ~10 files
- Always preview before applying changes
- Check authentication with `renamed doctor` if needed

## Fallback

If CLI unavailable, use MCP tools from `renamed-to/mcp.renamed.to`.