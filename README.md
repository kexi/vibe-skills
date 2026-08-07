# vibe-skills

Agent skills for [vibe](https://github.com/kexi/vibe), distributed through GitHub CLI.

```console
gh skill install kexi/vibe-skills vibe --scope user
```

Enter the reproducible development environment with `nix develop`. The shell installs the Lefthook pre-commit hook automatically.

Every successful CI run on `main` publishes a GitHub Release tagged `v0.0.<build-number>`.
