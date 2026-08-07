# Contributing to vibe-skills

Thank you for helping improve the agent skills for vibe. Contributions should keep the instructions accurate, safe, and useful across supported coding agents.

## Before you start

- Search existing issues and pull requests before starting overlapping work.
- For a substantial behavior change, open an issue first so the intended agent behavior can be discussed.
- Install [Nix](https://nixos.org/download/) with flakes enabled.
- Install vibe if you need to verify commands against the CLI itself.

## Set up the development environment

Clone the repository and enter its reproducible development shell:

```console
git clone https://github.com/kexi/vibe-skills.git
cd vibe-skills
nix develop
```

The development shell provides the validation tools used by CI and automatically installs the Lefthook pre-commit hook.

## Repository structure

```text
.
├── skills/
│   └── vibe/
│       └── SKILL.md       # Skill metadata and agent instructions
├── .github/workflows/
│   └── ci.yml             # Validation and release automation
├── flake.nix              # Reproducible development tools
└── lefthook.yml           # Local pre-commit checks
```

Each skill lives in `skills/<skill-name>/SKILL.md`. The `name` in the YAML frontmatter must match the directory name, and `description` should clearly identify the situations that trigger the skill.

## Editing a skill

When changing `SKILL.md`:

- write direct, actionable instructions for an agent;
- keep commands consistent with the currently released vibe CLI;
- distinguish safe inspection from operations that modify or remove data;
- require explicit user approval for destructive, forced, or trust-related actions;
- account for agent command runners that start a fresh shell for each command; and
- avoid assuming a particular branch strategy, shell, operating system, or coding agent unless the instruction requires one.

If you add a new skill, use the standard layout `skills/<skill-name>/SKILL.md` and include valid `name` and `description` frontmatter. Keep supporting files inside the same skill directory when possible.

## Validation

Run the skill validator after changing skill content:

```console
gh skill publish --dry-run .
```

Before opening a pull request, run the same checks as CI:

```console
nix flake check --all-systems
gh skill publish --dry-run .
pinact run --check --verify
actionlint
gitleaks git --redact --no-banner .
```

Lefthook runs the checks relevant to staged files when you commit. CI repeats the full validation on every pull request and on pushes to `main`.

For behavior changes, also test representative prompts with a supported coding agent. Confirm that the agent chooses the intended vibe command, preserves the user's repository state, and asks before security-sensitive or destructive actions.

## Commits and pull requests

Use [Semantic Commit Messages](https://gist.github.com/joshbuchea/6f47e1734b7f24d205e3212c7c570bdf). Examples include:

```text
feat: document a new vibe workflow
fix: require approval before branch deletion
docs: clarify local validation steps
```

Keep commits focused and explain why the change is needed in the commit message or pull request. A pull request should include:

- a concise description of the behavior or documentation changed;
- the motivation for the change;
- the validation commands that were run; and
- example prompts or agent behavior when the change affects skill execution.

Do not update release tags manually. After a pull request is merged, a successful CI run on `main` creates the next `v0.0.<build-number>` GitHub Release automatically.

## Security

Do not include credentials, tokens, private repository details, or other secrets in examples, fixtures, commits, or pull requests. If you discover a security issue, report it privately to the repository owner instead of opening a public issue.

## License

By contributing, you agree that your contributions are licensed under the repository's [MIT License](LICENSE).
