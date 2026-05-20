---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work - guides completion of development work by presenting structured options for merge, PR, or cleanup
---

# Finishing a Development Branch

## Overview

Guide completion of development work by presenting clear options and handling chosen workflow.

**Core principle:** Verify tests, component contract gates, and feature gates → update Cutiepie state → present options → execute choice → clean up.

**Announce at start:** "I'm using the finishing-a-development-branch skill to complete this work."

## The Process

### Step 1: Verify Tests

**Before presenting options, verify tests pass:**

```bash
# Run project's test suite
npm test / cargo test / pytest / go test ./...
```

**If tests fail:**
```
Tests failing (<N> failures). Must fix before completing:

[Show failures]

Cannot proceed with merge/PR until tests pass.
```

Stop. Don't proceed to Step 2.

**If tests pass:** Continue to Step 2.

### Step 2: Update Cutiepie State

If this is a Cutiepie-managed project, update durable project state before presenting merge/PR options.

Check for:

- `.cutiepie/FRD.md` or `docs/cutiepie/FRD.md`
- `.cutiepie/PLAN.md` or `docs/cutiepie/PLAN.md`
- `.cutiepie/CAVEATS.md` or `docs/cutiepie/CAVEATS.md`
- `.cutiepie/CONFIG.md` or `docs/cutiepie/CONFIG.md`
- `~/.cutiepie/memory/<project-slug>/MEMORY.md`
- `~/.cutiepie/memory/<project-slug>/FAILURES.md`

For each completed feature/component slice:

1. Verify the automated component contract gates passed, not just unit tests.
2. Verify the feature acceptance gate passed before marking the feature complete.
3. Update FRD progress/status for the feature and touched components.
4. Record meaningful deviations from the plan in the plan, caveats, or memory.
5. Update CONFIG.md and the settings/config owner for any hyperparameters or tunables added, removed, renamed, or changed.
6. Append durable implementation notes to `~/.cutiepie/memory/<project-slug>/MEMORY.md`:
   - feature/component completed
   - feature acceptance gate command/result
   - component contract gate command/result
   - settings/config changes
   - design decisions made during implementation
   - deviations from `.cutiepie/PLAN.md` or `docs/cutiepie/PLAN.md`
   - follow-ups
7. If repeated failure patterns occurred, use `capturing-failure-modes` before ending the session.

After a coherent feature/component slice is completed and state is updated, suggest clearing or compacting before starting another large slice so the next session can restart from `.cutiepie/` artifacts, recent commits, and `~/.cutiepie/memory`.

Derive `<project-slug>` from git remote when available, otherwise use the directory name.

### Step 3: Determine Base Branch

```bash
# Try common base branches
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

Or ask: "This branch split from main - is that correct?"

### Step 4: Present Options

Present exactly these 4 options:

```
Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**Don't add explanation** - keep options concise.

### Step 5: Execute Choice

#### Option 1: Merge Locally

```bash
# Switch to base branch
git checkout <base-branch>

# Pull latest
git pull

# Merge feature branch
git merge <feature-branch>

# Verify tests on merged result
<test command>

# If tests pass
git branch -d <feature-branch>
```

Then: Cleanup worktree (Step 6)

#### Option 2: Push and Create PR

```bash
# Push branch
git push -u origin <feature-branch>

# Create PR
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed>

## Test Plan
- [ ] <verification steps>
EOF
)"
```

Then: Cleanup worktree (Step 6)

#### Option 3: Keep As-Is

Report: "Keeping branch <name>. Worktree preserved at <path>."

**Don't cleanup worktree.**

#### Option 4: Discard

**Confirm first:**
```
This will permanently delete:
- Branch <name>
- All commits: <commit-list>
- Worktree at <path>

Type 'discard' to confirm.
```

Wait for exact confirmation.

If confirmed:
```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

Then: Cleanup worktree (Step 6)

### Step 6: Cleanup Worktree

**For Options 1, 2, 4:**

Check if in worktree:
```bash
git worktree list | grep $(git branch --show-current)
```

If yes:
```bash
git worktree remove <worktree-path>
```

**For Option 3:** Keep worktree.

## Quick Reference

| Option | Merge | Push | Keep Worktree | Cleanup Branch |
|--------|-------|------|---------------|----------------|
| 1. Merge locally | ✓ | - | - | ✓ |
| 2. Create PR | - | ✓ | ✓ | - |
| 3. Keep as-is | - | - | ✓ | - |
| 4. Discard | - | - | - | ✓ (force) |

## Common Mistakes

**Skipping test verification**
- **Problem:** Merge broken code, create failing PR
- **Fix:** Always verify tests before offering options

**Skipping Cutiepie state updates**
- **Problem:** Next session starts from stale FRD/PLAN/memory
- **Fix:** Update FRD progress and `~/.cutiepie/memory/<project-slug>/MEMORY.md` before presenting completion options

**Open-ended questions**
- **Problem:** "What should I do next?" → ambiguous
- **Fix:** Present exactly 4 structured options

**Automatic worktree cleanup**
- **Problem:** Remove worktree when might need it (Option 2, 3)
- **Fix:** Only cleanup for Options 1 and 4

**No confirmation for discard**
- **Problem:** Accidentally delete work
- **Fix:** Require typed "discard" confirmation

## Red Flags

**Never:**
- Proceed with failing tests
- Mark Cutiepie components complete without passing automated component contract gates
- Mark Cutiepie features complete without a passing automated feature acceptance gate
- Merge without verifying tests on result
- Delete work without confirmation
- Force-push without explicit request

**Always:**
- Verify tests before offering options
- Update Cutiepie FRD progress and memory when applicable
- Present exactly 4 options
- Get typed confirmation for Option 4
- Clean up worktree for Options 1 & 4 only

## Integration

**Called by:**
- **subagent-driven-development** (Step 7) - After all tasks complete
- **executing-plans** (Step 5) - After all batches complete

**Pairs with:**
- **using-git-worktrees** - Cleans up worktree created by that skill
