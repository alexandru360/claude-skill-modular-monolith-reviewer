# Quick Reference — pbi-dotnet-modular-monolith

## 📌 What Is This?

A **Claude skill repository** for building clean, modular .NET projects using DDD + strict architectural rules.

**Invoke in Claude Code**: `/pbi-dotnet-modular-monolith`

---

## 📚 Documentation Map

| File | Purpose | Read Time |
|------|---------|-----------|
| **[README.md](README.md)** | Complete skill overview | 5 min |
| **[pbi-dotnet-modular-monolith.md](pbi-dotnet-modular-monolith.md)** | Skill definition (Claude reads this) | Reference |
| **[SETUP.md](SETUP.md)** | How to clone, manage submodules | 3 min |
| **[CLAUDE.md](CLAUDE.md)** | Project standards (existing) | Reference |

---

## 🚀 Get Started in 30 Seconds

### Use the Skill
```
Type in Claude Code: /pbi-dotnet-modular-monolith
```

### Clone the Repo
```bash
git clone --recurse-submodules https://github.com/your-org/pbi-dotnet-modular-monolith.git
```

### Copy to Your Project
```bash
cp pbi-dotnet-modular-monolith.md your-project/.claude/skills/
```

---

## 🎯 Five Core Rules

| Rule | Means |
|------|-------|
| **YAGNI** | Delete unused abstractions immediately |
| **KISS** | Readable > clever; obvious in 2 minutes |
| **DRY** | Extract logic at 3+ repetitions |
| **SPOT** | One place for config, types, rules |
| **SoC** | Each class has ONE reason to change |

---

## 🏗️ Architecture at a Glance

```
Endpoint
  ↓
IService (Abstraction)
  ↓
Service (Implementation)
  ↓
IRepository (Abstraction)
  ↓
Repository + Domain Layer
```

✅ Acyclic  
✅ Testable  
✅ Clear boundaries  

---

## 💾 Dependency Submodules (No Duplication)

```
lib/
├── claude-git-pr-skill/   → PR creation & workflows
├── dotnet-skills/         → .NET CLI helpers
└── code-review-skill/     → Code review checks
```

**Why submodules?** Changes upstream automatically propagate. No copy-paste.

---

## ✅ Project Structure

```
src/
├── {ProjectName}.Abstractions/   ← Interfaces
├── {ProjectName}.Services/       ← Implementations
├── {ProjectName}.Models/         ← DTOs
├── {ProjectName}.Domain/         ← DDD logic
├── {ProjectName}.Infrastructure/ ← Data access
└── {ProjectName}/                ← API + DI
```

---

## 🔧 Common Commands

```bash
# Clone with dependencies
git clone --recurse-submodules <url>

# Update all submodules
git submodule update --remote

# Update one submodule
cd lib/dotnet-skills && git pull origin main && cd ../..

# Build & test .NET project
dotnet build
dotnet test
dotnet run --project src/{ProjectName}/
```

---

## 📝 Common Patterns

### Service Layer
```csharp
public sealed class XxxService(IRepository repo, ILogger<XxxService> log)
    : IXxxService
{
    public async Task<Dto?> GetAsync(string id, CancellationToken ct)
    {
        log.LogInformation("Getting {Id}", id);
        var entity = await repo.GetByIdAsync(id, ct);
        return entity is not null ? MapToDto(entity) : null;
    }
}
```

### Endpoint
```csharp
app.MapGet("/api/v1/features/{id}", async (string id, IXxxService svc, CancellationToken ct) =>
    await svc.GetAsync(id, ct) is var result
        ? Results.Ok(result)
        : Results.NotFound()
);
```

### DDD Aggregate
```csharp
public sealed class Feature : AggregateRoot
{
    public static Feature Create(string name)
    {
        if (string.IsNullOrWhiteSpace(name))
            throw new BusinessRuleViolation();
        return new Feature { Id = FeatureId.Create(), Name = name };
    }
}
```

---

## 🚨 Never Do This

❌ Service A → Service B directly (no abstraction)  
❌ Endpoint → concrete Service (bypass abstraction)  
❌ Domain → Infrastructure (keep domain pure)  
❌ Circular module imports (A → B → A)  
❌ Unused abstractions (YAGNI)  
❌ Hardcoded config (use appsettings.json)  
❌ Synchronous I/O (everything async + CancellationToken)  

---

## 📋 Pre-Commit Checklist

- [ ] No secrets in code (use appsettings.json)
- [ ] All external I/O is async with CancellationToken
- [ ] Services depend ONLY on Abstractions
- [ ] No copy-paste (extract at 3+ reps)
- [ ] Tests cover happy + error paths
- [ ] No `.Result` or `.Wait()`
- [ ] YAGNI: No unused abstractions
- [ ] KISS: Code is obvious
- [ ] DRY: No duplicated logic
- [ ] SPOT: Each concept in ONE place
- [ ] SoC: Each class has ONE reason to change
- [ ] Acyclic: No circular dependencies

---

## 🔗 Related Skills (Submodules)

- **claude-git-pr-skill** — Automate PR creation
- **dotnet-skills** — .NET CLI patterns
- **code-review-skill** — Quality gates

---

## ❓ FAQ

**Q: Can I use this without git submodules?**  
A: Yes. Copy `pbi-dotnet-modular-monolith.md` to your project. Submodules are optional helpers.

**Q: How often do submodules update?**  
A: Manually — `git submodule update --remote`. No automatic upgrades.

**Q: What if I disagree with YAGNI/KISS/DRY/SPOT/SoC?**  
A: These rules have saved teams from premature abstraction and tight coupling. Start with them; exceptions are rare.

**Q: Can I modify the skill?**  
A: Yes. Fork it, edit, and use locally. Or PR improvements upstream.

---

## 📞 Need Help?

1. **Skill overview** → Read [README.md](README.md)
2. **Cloning issues** → Check [SETUP.md](SETUP.md)
3. **Architecture questions** → See [CLAUDE.md](CLAUDE.md) or invoke the skill
4. **Code patterns** → Review [pbi-dotnet-modular-monolith.md](pbi-dotnet-modular-monolith.md)

---

**Last Updated**: 2026-06-29  
**Repository**: c:\Dev\_skills\_bi-layouting-engine  
**Skill Command**: `/pbi-dotnet-modular-monolith`
