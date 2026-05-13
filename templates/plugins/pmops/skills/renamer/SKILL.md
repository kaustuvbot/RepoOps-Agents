---
name: renamer
description: Rename files intelligently using AI content analysis. Use when the user wants to rename files based on their content, batch rename documents, or organize file names.
---

# Rename Files by Content

Rename files using AI content analysis.

## Tool Selection

**Prefer CLI** (`renamed` via Bash) when available — richer output and more options.
**Fallback to MCP** (`mcp__renamed-to__rename`) if CLI unavailable.

## Prerequisites

1. Check CLI: `renamed --version`
   - Install: `brew tap renamed-to/cli && brew install renamed` or `npm install -g @renamed-to/cli`
2. Check auth: `renamed doctor` or `mcp__renamed-to__status`
   - If not auth: `renamed auth login`

## CLI Reference

```
renamed rename [options] <files...>

Options:
  -a, --apply                 Apply the rename (preview by default)
  -o, --output-dir <dir>      Output directory
  -p, --prompt <instruction>  Custom AI instruction for filename format
  -s, --strategy <name>       Folder organization strategy
  -t, --template <name>       Predefined filename template
  -l, --language <code>       Output language (en, de, fr, es, ...)
  --overwrite                 Overwrite existing files
  --on-conflict <mode>        fail (default), skip, or suffix
  --json                      Machine-readable JSON output
```

**Strategies:** `by_date`, `by_issuer`, `by_type`, `by_date_issuer`, `by_date_type`, `by_issuer_type`, `by_all`, `root`, `follow_custom_prompt`

**Templates:** `standard`, `date_first`, `company_first`, `minimal`, `detailed`, `department_focus`

## Workflow

### Single File

1. Preview: `renamed rename invoice.pdf`
2. Show user the suggested name
3. If approved: `renamed rename -a invoice.pdf`

### Batch

1. Preview: `renamed rename *.pdf`
2. Show preview table to user
3. If approved: `renamed rename -a *.pdf`

## Supported Files

PDF, JPG, JPEG, PNG, TIFF

## Error Handling

- CLI not found: Install via brew or npm
- Not authenticated: `renamed auth login`
- Unsupported file type: Only PDF, JPG, JPEG, PNG, TIFF supported
- File too large: Max 25MB per file

## Tips

- Always preview before applying
- For large batches: `renamed rename --json *.pdf`
- In git repo: consider `git mv` to preserve history
- Use `--on-conflict suffix` for batches with name collisions