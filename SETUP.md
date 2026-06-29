# Setup Guide for pbi-dotnet-modular-monolith Skill Repository

## Overview

This repository contains the **pbi-dotnet-modular-monolith** skill — a comprehensive Claude Code skill for building clean, modular ASP.NET Core projects with DDD patterns and strict architectural boundaries.

The skill repository is designed as a **reference implementation** that depends on 3 external skill repositories via git submodules (no code duplication).

## Initial Setup

### 1. Clone with Submodules

```bash
git clone --recurse-submodules https://github.com/your-org/pbi-dotnet-modular-monolith.git
cd pbi-dotnet-modular-monolith
```

If you cloned without `--recurse-submodules`, initialize them now:

```bash
git submodule update --init --recursive
```

### 2. Verify Submodules

Check that all 3 dependencies are present:

```bash
git submodule status
```

Expected output:
```
 abc1234... lib/claude-git-pr-skill (hash...)
 def5678... lib/dotnet-skills (hash...)
 ghi9012... lib/code-review-skill (hash...)
```

### 3. Understand the Structure

```
pbi-dotnet-modular-monolith/
├── README.md                           ← Overview (start here)
├── pbi-dotnet-modular-monolith.md      ← Skill definition for Claude Code
├── CLAUDE.md                           ← Project standards (YAGNI, KISS, DRY, SPOT, SoC)
├── .gitmodules                         ← Submodule configuration
│
├── lib/                                ← External skill dependencies (submodules)
│   ├── claude-git-pr-skill/            → PR creation & git workflows
│   ├── dotnet-skills/                  → .NET CLI helpers & build utilities
│   └── code-review-skill/              → Code review & quality checks
│
└── .claude/                            ← Claude Code project config
    ├── settings.json                   ← User workspace settings
    ├── rules/                          ← Architecture rules
    ├── skills/                         ← Local skill definitions
    └── agents/                         ← Custom agent configurations
```

## Using the Skill

### In Claude Code (VSCode Extension or Web)

Invoke the skill directly:

```
/pbi-dotnet-modular-monolith
```

Claude will provide:
- Architecture templates
- Code patterns (services, endpoints, domain aggregates)
- DI registration boilerplate
- Testing strategies
- Checklists

### In Your Own Project

**Option A: Copy the Skill Definition**

Copy `pbi-dotnet-modular-monolith.md` into your project's `.claude/skills/` folder.

**Option B: Reference via Git**

If your project uses git submodules, add this repo as a dependency:

```bash
git submodule add https://github.com/your-org/pbi-dotnet-modular-monolith.git .claude/skills/pbi-dotnet-modular-monolith
```

Then reference it from your CLAUDE.md:

```markdown
# Your Project

This project follows the [pbi-dotnet-modular-monolith](/path/to/skill/pbi-dotnet-modular-monolith.md) standard.
```

## Updating Submodules

To pull the latest versions of dependency skills:

```bash
git submodule update --remote
git commit -am "chore: update skill dependencies"
git push
```

Or update a specific submodule:

```bash
cd lib/dotnet-skills
git pull origin main
cd ../..
git add lib/dotnet-skills
git commit -m "chore: update dotnet-skills to latest"
```

## Contributing

### Adding New Content

1. **Skill definition**: Edit `pbi-dotnet-modular-monolith.md`
2. **Documentation**: Update `README.md`
3. **Project standards**: Reference `CLAUDE.md`
4. **Examples/Templates**: Add to `.claude/skills/` or inline in markdown

### Updating Submodule Dependencies

If a submodule needs updating:

```bash
cd lib/<submodule-name>
git checkout main
git pull
cd ../..
git add lib/<submodule-name>
git commit -m "chore: update <submodule-name> dependency"
```

### Testing the Skill

Before merging:

1. Copy `pbi-dotnet-modular-monolith.md` to a test project
2. Invoke it in Claude Code
3. Verify templates generate valid .NET project structure
4. Check that the architecture rules are clear and actionable

## Troubleshooting

### Submodules Showing as Detached

If submodules are in a detached HEAD state:

```bash
git submodule foreach git checkout main
git submodule foreach git pull origin main
```

### Permission Denied on Submodule Clone

If you see `Permission denied (publickey)` when cloning submodules:

1. Ensure your SSH key is registered with GitHub
2. Use HTTPS instead of SSH:
   ```bash
   git config --global url."https://github.com/".insteadOf git://github.com/
   ```

### Submodule Shows as "Untracked Content"

Git sees uncommitted changes in a submodule. Resolve with:

```bash
git submodule foreach git status
git submodule update --force
```

## CI/CD Integration

### GitHub Actions Example

To automatically update submodules on a schedule:

```yaml
name: Update Submodules

on:
  schedule:
    - cron: '0 0 * * MON'  # Every Monday at midnight

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: recursive

      - name: Update submodules
        run: git submodule update --remote

      - name: Commit and push
        run: |
          git config user.name "Automation"
          git config user.email "automation@example.com"
          git add .gitmodules lib/
          git commit -m "chore: update submodule dependencies" || true
          git push
```

## Quick Reference

| Task | Command |
|------|---------|
| Clone with submodules | `git clone --recurse-submodules <url>` |
| Initialize submodules | `git submodule update --init --recursive` |
| Update all submodules | `git submodule update --remote` |
| Check submodule status | `git submodule status` |
| Update specific submodule | `cd lib/<name> && git pull origin main && cd ../..` |
| Remove a submodule | `git rm lib/<name>` then edit `.gitmodules` |

## FAQ

**Q: Why use git submodules instead of copying?**  
A: Submodules keep skills DRY — changes upstream automatically propagate, and you avoid maintaining duplicate code across projects.

**Q: Can I use this skill without cloning the submodules?**  
A: Yes, but you lose access to the integrated helpers. The core skill definition (`pbi-dotnet-modular-monolith.md`) works standalone.

**Q: How do I reference a submodule from my project?**  
A: Import it in your CLAUDE.md or link to its skill definition. Submodules are development-time dependencies, not production code.

**Q: What if a submodule has breaking changes?**  
A: Pin to a specific commit in `.gitmodules`, or check the submodule's CHANGELOG before updating.

---

**For more details**:
- Read [README.md](README.md) for skill overview
- Check [pbi-dotnet-modular-monolith.md](pbi-dotnet-modular-monolith.md) for the skill definition
- Review [CLAUDE.md](CLAUDE.md) for project standards
