---
name: renamer
description: AI-powered file renaming by content analysis
---

# Rename Files by Content

Rename files intelligently using AI content analysis.

## Prerequisites

- renamed.to account
- CLI: `brew tap renamed-to/cli && brew install renamed`
- Auth: `renamed auth login`

## Commands

```bash
# Preview rename
renamed rename file.pdf

# Apply rename
renamed rename -a file.pdf

# Batch rename
renamed rename *.pdf

# Custom prompt
renamed rename -p "Format: YYYY-MM-DD_Company" file.pdf
```

## Supported Files

PDF, JPG, JPEG, PNG, TIFF

## Auth Check

```bash
renamed doctor
```

## Strategies

`by_date`, `by_issuer`, `by_type`, `by_date_issuer`, `by_date_type`, `by_issuer_type`, `by_all`

## Templates

`standard`, `date_first`, `company_first`, `minimal`, `detailed`, `department_focus`

## Fallback

If CLI unavailable, use MCP tools from `renamed-to/mcp.renamed.to`.