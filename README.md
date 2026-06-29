# skill-dotnet-modular-monolith

> **Universal .NET Architecture Standard for Modular Monoliths**

A comprehensive Claude skill that guides implementation of clean, modular ASP.NET Core 10 projects using Domain-Driven Design (DDD), event-driven communication, and strict architectural boundaries.

## Overview

This skill provides:

- **Architecture templates** — Modular Monolith structure with DDD patterns
- **Code patterns** — Service layer, endpoints, domain aggregates, repositories
- **Quality enforcement** — NetArchTest-driven acyclic dependency validation
- **Engineering rules** — YAGNI, KISS, DRY, SPOT (Single Point of Truth), SoC (Separation of Concerns)
- **Testing strategies** — Unit, integration, and architecture tests
- **CLI reference** — Common .NET build, run, and test commands

## When to Use This Skill

Invoke `/skill-dotnet-modular-monolith` when:

- Creating a **new ASP.NET Core 10+ project** from scratch
- Establishing **architecture patterns** for a team
- Setting up **module boundaries** and dependency rules
- Implementing **DDD aggregates** or **event-driven communication**
- Enforcing **code quality standards** (YAGNI, KISS, DRY, SPOT, SoC)
- Reviewing **architecture compliance** across multiple services

## Key Principles

### Non-Negotiable Rules

| Rule | What It Means | Why |
|------|---------------|-----|
| **YAGNI** | Delete unused abstractions immediately | No hypothetical features or over-engineering |
| **KISS** | Readable code > clever code | Obvious > magic; readable in under 2 min |
| **DRY** | Extract at 3+ repetitions | Single Point of Truth for each concept |
| **SPOT** | Config, types, rules in ONE place | Never scattered across files |
| **SoC** | Each class has ONE reason to change | Prevents god objects and tight coupling |
| **Acyclic** | Dependencies form a DAG | No circular imports; enforced by NetArchTest |

### Module Structure

```
src/
├── {ProjectName}.Abstractions/   ← Interfaces ONLY
├── {ProjectName}.Services/       ← Implementations
├── {ProjectName}.Models/         ← DTOs
├── {ProjectName}.Domain/         ← DDD business logic
├── {ProjectName}.Infrastructure/ ← Data access, cloud APIs
└── {ProjectName}/                ← API endpoints + DI
```

### Dependency Flow (Acyclic)

```
Endpoint → IService (Abstraction) → Service → IRepository → Repository → Domain/APIs
```

✅ **Allowed**: Endpoint calls abstraction, abstraction hides concrete service  
❌ **Blocked**: Service imports Service, circular dependencies, Domain depends on Infrastructure

## Features

### 1. **Architecture Templates**
- Pre-built project structure (Modular Monolith, DDD, event-driven)
- Service, repository, endpoint patterns
- Dependency injection setup

### 2. **Code Patterns**
- Minimal APIs (ASP.NET Core endpoints)
- Service layer with logging and error handling
- DDD aggregates, value objects, domain events
- Business rule validation

### 3. **Quality Tools**
- NetArchTest setup for compile-time dependency validation
- Unit test templates (xUnit / MSTest)
- Integration test patterns (WebApplicationFactory)
- Logging best practices (structured, contextual)

### 4. **Engineering Standards**
- Naming conventions
- Error handling strategies
- CancellationToken usage (async best practice)
- Configuration management (appsettings.json)

## Dependencies

This skill builds on and references:

- **[claude-git-pr-skill](https://github.com/aidankinzett/claude-git-pr-skill)** — PR creation and git workflow automation
- **[dotnet-skills](https://github.com/Aaronontheweb/dotnet-skills.git)** — .NET CLI helpers and build utilities
- **[code-review-skill](https://github.com/awesome-skills/code-review-skill.git)** — Code review and quality checks

These are included as git submodules (no duplication).

## Quick Start

1. **Invoke the skill**:
   ```
   /skill-dotnet-modular-monolith
   ```

2. **Provide project details**:
   - Project name (e.g., `OrderService`)
   - Key features or domains
   - Authentication method (JWT, Azure AD, etc.)
   - External integrations (AWS, Azure, databases)

3. **Receive**:
   - Full project scaffold
   - Namespace references with placeholder replacements
   - DI registration boilerplate
   - Example endpoint, service, and aggregate
   - Test stubs

4. **Implement**:
   - Replace `{ProjectName}` placeholders
   - Add domain logic to aggregates
   - Implement repository interfaces
   - Wire up endpoints

## Checklist Before Every Commit

- [ ] No hardcoded secrets
- [ ] All external I/O is async with `CancellationToken`
- [ ] Services depend ONLY on Abstractions
- [ ] No copy-paste code (extract at 3+ repetitions)
- [ ] Tests cover happy + error paths
- [ ] No `.Result` or `.Wait()`
- [ ] YAGNI: No unused abstractions
- [ ] KISS: Code is obvious
- [ ] DRY: No duplicated logic
- [ ] SPOT: Each concept in ONE place
- [ ] SoC: Each class has ONE reason to change
- [ ] Acyclic: No circular module dependencies
- [ ] Architecture tests pass (NetArchTest)

## Example Commands

| Task | Command |
|------|---------|
| Build | `dotnet build` |
| Run | `dotnet run --project src/{ProjectName}/` |
| Test | `dotnet test` |
| Unit tests only | `dotnet test --filter Category!=Integration` |
| Clean | `dotnet clean && rm -rf **/bin **/obj` |

## Project Structure Details

### Abstractions Layer
```csharp
// src/{ProjectName}.Abstractions/Services/IXxxService.cs
public interface IXxxService
{
    Task<TDto?> GetAsync(string id, CancellationToken ct);
    Task<string> CreateAsync(CreateRequest request, CancellationToken ct);
    Task UpdateAsync(string id, UpdateRequest request, CancellationToken ct);
    Task DeleteAsync(string id, CancellationToken ct);
}
```

### Service Implementation
```csharp
// src/{ProjectName}.Services/Services/XxxService.cs
public sealed class XxxService(
    IRepository repository,
    ILogger<XxxService> logger)
    : IXxxService
{
    // Dependency injection via sealed class primary constructor
    // Logging with context
    // Async operations with CancellationToken
}
```

### Domain Layer (DDD)
```csharp
// src/{ProjectName}.Domain/Aggregates/FeatureAggregate.cs
public sealed class FeatureAggregate : AggregateRoot
{
    public static FeatureAggregate Create(string name)
    {
        // Factory method ensures validity on creation
        // Domain events for event sourcing
        // Business rule validation
    }
}
```

### Endpoints (Minimal APIs)
```csharp
// src/{ProjectName}/Endpoints/FeatureEndpoints.cs
public static class FeatureEndpoints
{
    public static void MapFeatureEndpoints(this WebApplication app)
    {
        var group = app.MapGroup("/api/v1/features")
            .RequireAuthorization();

        group.MapGet("/{id}", GetFeature);
        group.MapPost("/", CreateFeature);
    }
}
```

## File Organization

```
skill-dotnet-modular-monolith/
├── README.md                    ← This file
├── skill-dotnet-modular-monolith.md  ← Skill definition
├── templates/                   ← Reusable code snippets
│   ├── project-structure.md
│   ├── service-layer.cs
│   ├── endpoints.cs
│   ├── ddd-aggregate.cs
│   └── di-registration.cs
├── rules/                       ← Project rules enforced
│   ├── architecture.md
│   ├── code-quality.md
│   └── testing.md
├── .gitmodules                  ← Git submodule config
└── lib/                         ← Dependency skills (submodules)
    ├── claude-git-pr-skill/
    ├── dotnet-skills/
    └── code-review-skill/
```

## Contributing

When updating this skill:

1. Update templates to reflect current .NET best practices
2. Run architecture tests to validate examples
3. Ensure CLAUDE.md stays in sync with skill templates
4. Update submodules when dependencies change:
   ```bash
   git submodule update --remote
   ```

## License

This skill is part of the PBI project ecosystem and follows the same licensing terms.

---

**Last Updated**: 2026-06-29  
**For questions**: Refer to CLAUDE.md in project root or invoke the skill with your specific scenario.
