---
name: pr-description
description: Write GitHub Pull Request descriptions from branch commits. Use when user asks to write a PR description, create a PR summary, or document changes for a pull request. Analyzes git commits and diffs to produce structured PR documentation.
---

# PR Description Writer

Generate structured PR descriptions from branch commits.

## Workflow

1. Get commits: `git log --oneline origin/main..HEAD` (fallback to `HEAD~10..HEAD`)
2. Get each commit's details: `git show <hash> --stat --format="%H%n%s%n%b"`
3. Get each commit's diff: `git diff <hash>^..<hash>`
4. Write PR description following the output format below

## Output Format

### 1. Title
Single line. Use most meaningful commit subject or synthesize one. Keep short and technical.

### 2. Summary (2-5 bullets)
High-level changes. Each bullet concrete and verifiable.

### 3. Why (1-4 bullets)
Motivation, problem, or user impact. Tie to reliability, security, performance, DX, or product needs.

### 4. Commit-by-commit details
For EACH commit, add subsection with exact subject as heading:

**What:**
1-3 bullets describing concrete changes

**Why:**
1-2 bullets explaining motivation/tradeoffs

**Notes:** (optional) only for risk, migration, follow-up, or nuance

Rules:
- Preserve commit subject exactly as written
- If commit has a meaningful description use that
- If commit is noisy (formatting, rename), say so briefly
- Related commits: document each, keep later ones shorter ("follow-up", "fixup")

### 5. Testing
Checklist of what was done. If none provided, infer likely checks and label "Suggested".

### 6. Risk and rollout (2-6 bullets)
- What could break
- Where to watch
- Rollback plan (1 line)
- If breaking change, include BREAKING CHANGE callout

### 7. Screenshots/logs (optional)
Only if UI, behavior, or observability changed.

## Style
- Direct and technical. No marketing tone.
- No fluff or jokes.
- Short sentences. Prefer bullets over paragraphs.
- Do not invent facts. Say "Likely" or "Inferred" if uncertain.
