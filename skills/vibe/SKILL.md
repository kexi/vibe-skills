---
name: vibe
description: Manage Git worktrees with the vibe CLI. Use when creating, reusing, entering, listing, renaming, or removing worktrees; navigating back to the main worktree; reviewing or trusting .vibe.toml configuration; diagnosing shell integration; or configuring Claude Code worktree hooks.
---

# Vibe

Use `vibe` instead of assembling `git worktree` commands manually. Preserve the user's branch strategy and repository instructions.

## Check availability

Run `vibe --version`. If unavailable, stop and tell the user to install it from <https://github.com/kexi/vibe>. Do not silently substitute a different worktree manager.

Run `vibe <command> --help` before using unfamiliar or version-dependent flags.

## Account for shell behavior

Treat `start`, `scratch`, `jump`, `rename`, `clean`, and `home` as navigation commands. With the shell wrapper installed, they can change the interactive shell's current directory.

Assume agent command tools start a fresh shell for each invocation. A directory change usually does not persist into the next tool call. After creating or selecting a worktree:

1. Run `vibe list --json`.
2. Select the entry by its `branch` field.
3. Pass its `path` explicitly as the working directory for later commands.

Capture stderr when streams are separated. Vibe reserves stdout for its shell-navigation protocol and emits human output, including `list --json`, on stderr. Never evaluate captured navigation output yourself.

## Choose a workflow

### Inspect worktrees

Run:

```console
vibe list --json
```

Prefer JSON over the human table. Entries contain `branch`, `path`, `current`, and `scratch`.

### Create a named worktree

Run:

```console
vibe start <branch>
vibe start <branch> --base <ref>
```

Use `--base` only when creating a new branch from a specific branch, tag, or commit. Add `--track` only when upstream tracking is intended.

Use these controls when appropriate:

- `--dry-run`: preview the operation.
- `--reuse`: reuse an existing branch.
- `--no-hooks`: skip pre-start and post-start hooks.
- `--no-copy`: skip configured copying.
- `--copy-untracked`: copy untracked, non-ignored files too.
- `--copy-modified`: copy locally modified tracked files too.

Do not use `--force` unless the user explicitly approves skipping confirmation or overwriting a conflicting worktree.

### Create a temporary worktree

Run `vibe scratch` to create a `scratch/<timestamp>` branch. Promote it later with:

```console
vibe rename <new-name>
```

Use `vibe rename --dry-run <new-name>` when the resulting branch or path is uncertain.

### Enter an existing worktree

Run `vibe jump <branch>`. Vibe supports exact, partial, and fuzzy branch matching. Supply the full branch name when automation must be deterministic.

### Return without removing

Run `vibe home` to return to the main worktree while preserving the current secondary worktree.

### Remove a worktree

Run `vibe clean` only from the secondary worktree the user wants removed. Check `git status` first and report material uncommitted changes.

- Use `--keep-branch` when the branch must remain.
- Use `--delete-branch` only with explicit user approval.
- Never combine `--keep-branch` and `--delete-branch`.
- Do not use `--force` or `--allow-default-branch` without explicit user approval.

Do not assume the default branch behavior; inspect `vibe clean --help` and the effective configuration.

## Handle repository configuration safely

Run `vibe config` to show effective settings and `vibe verify` to inspect trust status and hash history.

Before `vibe trust`:

1. Read `.vibe.toml` and `.vibe.local.toml` if present.
2. Review hooks and scripts as arbitrary code execution.
3. Explain material effects to the user.
4. Obtain approval before trusting when approval has not already been given.

Run `vibe untrust` to remove trust.

## Diagnose and maintain the installation

- Run `vibe doctor` for known environment and stale-wrapper problems.
- Run `vibe upgrade --check` to check for an available update without applying one.
- Run `vibe shell-setup --shell <shell>` only when the user asks to configure shell integration. Treat its stdout as setup code and show it before changing a shell profile.

## Integrate Claude Code worktree hooks

Prefer the documented Claude Code integration from the installed vibe version. Inspect `vibe start --help`, `vibe clean --help`, and the upstream documentation before editing hook configuration. The worktree-hook flags are an internal protocol; do not invoke them as ordinary interactive flags.

## Preserve safety boundaries

- Keep destructive actions within the user's stated scope.
- Resolve exact worktree paths with `vibe list --json` before cleanup.
- Never infer approval for branch deletion, forced overwrite, default-branch operations, hook trust, or shell-profile edits.
- Use dry runs and read-only inspection when the intended target is ambiguous.
