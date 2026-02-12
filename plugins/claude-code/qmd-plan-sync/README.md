# qmd-plan-sync

A Claude Code plugin that automatically runs `qmd update` when plan files (`.claude/plans/*.md`) are written or edited.

## Prerequisites

- [qmd](https://github.com/tobi/qmd) installed and available on your `PATH`
- `jq` installed (used to parse hook input)
- You have to manually add the plans folder to the qmd collections before this script can work

## Installation

### Via marketplace (recommended)

Add the marketplace and install the plugin:

```bash
/plugin marketplace add lucianghinda/agentic-skills
/plugin install qmd-plan-sync@agentic-skills
```

### Via local path (development)

```bash
claude --plugin-dir /path/to/qmd-plan-sync
```

## How it works

The plugin registers a `PostToolUse` hook that fires after `Write`, `Edit`, or `MultiEdit` tool calls. The hook script:

1. Reads the tool call JSON from stdin
2. Extracts `file_path` from `tool_input`
3. Checks if the file matches `.claude/plans/*.md`
4. If yes, runs `qmd update`
5. Exits 0 in all cases (non-blocking)

Non-plan file edits are ignored. If `qmd` is not installed, the hook silently exits.

By default, the hook matches files under `.claude/plans/`. If you've customized Claude Code's `plansDirectory` setting, set `QMD_PLANS_DIR` to match:

```bash
export QMD_PLANS_DIR=".my-custom-plans"
```

Set `QMD_PLAN_SYNC_VERBOSE=1` to see qmd output on stderr for debugging.

## Verification

1. Install the plugin (via marketplace or `--plugin-dir`)
2. Enter plan mode and trigger a plan file write
3. To confirm `qmd update` ran, set `QMD_PLAN_SYNC_VERBOSE=1` and check stderr, or run `qmd update` manually
4. Verify non-plan file edits do **not** trigger qmd
