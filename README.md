# vibe-skills

Agent skills that teach coding agents how to use [vibe](https://github.com/kexi/vibe), a Git worktree manager. The skills are distributed through the GitHub CLI and follow the [Agent Skills specification](https://agentskills.io/specification).

## Available skills

| Skill | Description |
| --- | --- |
| [`vibe`](skills/vibe/SKILL.md) | Create, inspect, enter, rename, and safely remove Git worktrees with the vibe CLI. It also covers trusted repository configuration, diagnostics, shell integration, and Claude Code worktree hooks. |

## Prerequisites

- [GitHub CLI](https://cli.github.com/) with the `gh skill` commands available
- [vibe](https://github.com/kexi/vibe) installed and available on `PATH`
- A supported coding agent, such as Codex, Claude Code, Cursor, Gemini CLI, or GitHub Copilot

## Installation

Install the `vibe` skill for the current user:

```console
gh skill install kexi/vibe-skills vibe --scope user
```

To install the skill only in the current project, omit `--scope user`:

```console
gh skill install kexi/vibe-skills vibe
```

Use `--agent` when you want to select a specific agent non-interactively:

```console
gh skill install kexi/vibe-skills vibe --agent codex --scope user
```

The latest GitHub Release is used by default. To keep an installation on a specific release, append its tag to the skill name:

```console
gh skill install kexi/vibe-skills vibe@v0.0.1 --scope user
```

## Updating

Check for an update without changing installed files:

```console
gh skill update vibe --dry-run
```

Run the update interactively:

```console
gh skill update vibe
```

Installations pinned to a release are not updated until they are unpinned.

## What the skill helps with

Once installed, your coding agent can use vibe for tasks such as:

- listing worktrees in a machine-readable format;
- creating named or temporary worktrees;
- entering a worktree or returning to the main worktree;
- renaming and safely cleaning up worktrees;
- reviewing `.vibe.toml` and `.vibe.local.toml` before trusting them;
- diagnosing vibe and shell-integration problems; and
- configuring Claude Code worktree hooks.

The skill deliberately requires explicit approval for destructive or security-sensitive operations such as deleting branches, forcing cleanup, trusting repository hooks, and modifying shell profiles.

## Development

Validate the skill locally with:

```console
gh skill publish --dry-run .
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for the development workflow and contribution guidelines.

## Releases

Every successful CI run on `main` publishes a GitHub Release tagged `v0.0.<build-number>`. The GitHub CLI resolves an unpinned installation from the latest release, so merged skill changes become available automatically.

## License

This project is available under the [MIT License](LICENSE).
