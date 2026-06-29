# Master Skills Index — BI Layouting Engine

**Universal Repository**: Loads all dotnet-skills from the Akka.NET ecosystem expertise base.

---

## 📋 How to Use This Index

1. Find the skill you need below
2. Read the corresponding `SKILL.md` file
3. All skills auto-load via this index reference
4. For architecture guidance: Always start with `CLAUDE.md` first

---

## 🏗️ Architecture Foundation

- **[CLAUDE.md](./CLAUDE.md)** — Universal .NET Modular Monolith template (START HERE for any new project)
- **[skill-dotnet-modular-monolith.md](./skill-dotnet-modular-monolith.md)** — Universal .NET Architecture Standard (Modular Monolith + DDD + Event-Driven)
- **[README.md](./README.md)** — Skill documentation and overview

---

## 🎯 Core Akka.NET Skills

### Akka.NET Patterns & Best Practices
- [akka-aspire-configuration](../bi-layouting-engine-skills/skills/akka-aspire-configuration/SKILL.md) — Configure Akka in Microsoft.Extensions ecosystem
- [akka-best-practices](../bi-layouting-engine-skills/skills/akka-best-practices/SKILL.md) — Async/cancellation, clustering, work distribution
- [akka-hosting-actor-patterns](../bi-layouting-engine-skills/skills/akka-hosting-actor-patterns/SKILL.md) — Actor lifecycle in ASP.NET Core
- [akka-management](../bi-layouting-engine-skills/skills/akka-management/SKILL.md) — Cluster management & discovery
- [akka-testing-patterns](../bi-layouting-engine-skills/skills/akka-testing-patterns/SKILL.md) — Unit & integration testing for actors

### Akka.NET Specialists (Agents)
- [akka-net-specialist](../bi-layouting-engine-skills/agents/akka-net-specialist.md)
- [dotnet-concurrency-specialist](../bi-layouting-engine-skills/agents/dotnet-concurrency-specialist.md)

---

## 🔧 .NET Infrastructure & Config

### Aspire & Orchestration
- [aspire-configuration](../bi-layouting-engine-skills/skills/aspire-configuration/SKILL.md) — .NET Aspire setup
- [aspire-integration-testing](../bi-layouting-engine-skills/skills/aspire-integration-testing/SKILL.md) — Full orchestration testing
- [aspire-mailpit-integration](../bi-layouting-engine-skills/skills/aspire-mailpit-integration/SKILL.md) — Email testing with Mailpit
- [aspire-service-defaults](../bi-layouting-engine-skills/skills/aspire-service-defaults/SKILL.md) — Default service config

### Configuration & Dependency Injection
- [microsoft-extensions-configuration](../bi-layouting-engine-skills/skills/microsoft-extensions-configuration/SKILL.md) — Config sources & patterns
- [microsoft-extensions-dependency-injection](../bi-layouting-engine-skills/skills/microsoft-extensions-dependency-injection/SKILL.md) — DI container patterns

---

## 📊 Data & Performance

### Database & ORM
- [efcore-patterns](../bi-layouting-engine-skills/skills/efcore-patterns/SKILL.md) — Entity Framework Core best practices
- [database-performance](../bi-layouting-engine-skills/skills/database-performance/SKILL.md) — Query optimization & indexing

### Testing Infrastructure
- [testcontainers](../bi-layouting-engine-skills/skills/testcontainers/SKILL.md) — Docker-based integration tests
- [snapshot-testing](../bi-layouting-engine-skills/skills/snapshot-testing/SKILL.md) — Verify library for snapshot comparisons
- [verify-email-snapshots](../bi-layouting-engine-skills/skills/verify-email-snapshots/SKILL.md) — Email snapshot testing

---

## 🎨 C# Language & Design

### Type Design & Patterns
- [csharp-api-design](../bi-layouting-engine-skills/skills/csharp-api-design/SKILL.md) — Public API design patterns
- [csharp-coding-standards](../bi-layouting-engine-skills/skills/csharp-coding-standards/SKILL.md) — Comprehensive C# standards
- [csharp-concurrency-patterns](../bi-layouting-engine-skills/skills/csharp-concurrency-patterns/SKILL.md) — Async/await, Task patterns
- [csharp-type-design-performance](../bi-layouting-engine-skills/skills/csharp-type-design-performance/SKILL.md) — Record types, structs, performance

### Code Quality
- [crap-analysis](../bi-layouting-engine-skills/skills/crap-analysis/SKILL.md) — Change Risk Anti-Patterns scoring
- [project-structure](../bi-layouting-engine-skills/skills/project-structure/SKILL.md) — Solution & project organization

---

## 🛠️ Tooling & Debugging

### Code Analysis & Instrumentation
- [ilspy-decompile](../bi-layouting-engine-skills/skills/ilspy-decompile/SKILL.md) — Decompile & analyze IL
- [opentelementry-dotnet-instrumentation](../bi-layouting-engine-skills/skills/opentelementry-dotnet-instrumentation/SKILL.md) — Observability instrumentation
- [roslyn-incremental-generator-specialist](../bi-layouting-engine-skills/agents/roslyn-incremental-generator-specialist.md) — Source generators

### Local Development
- [dotnet-devcert-trust](../bi-layouting-engine-skills/skills/dotnet-devcert-trust/SKILL.md) — HTTPS development certificates
- [local-tools](../bi-layouting-engine-skills/skills/local-tools/SKILL.md) — dotnet-tools installation

### Documentation & Release
- [docfx-specialist](../bi-layouting-engine-skills/agents/docfx-specialist.md) — DocFX documentation generator
- [marketplace-publishing](../bi-layouting-engine-skills/skills/marketplace-publishing/SKILL.md) — NuGet package publishing

---

## 📧 Templating & Email

- [mjml-email-templates](../bi-layouting-engine-skills/skills/mjml-email-templates/SKILL.md) — MJML email template design
- [playwright-blazor](../bi-layouting-engine-skills/skills/playwright-blazor/SKILL.md) — E2E testing Blazor apps
- [playwright-ci-caching](../bi-layouting-engine-skills/skills/playwright-ci-caching/SKILL.md) — Playwright performance in CI

---

## 🔄 Reactive & Streaming

### Rx.NET & R3
- [r3-reactive-extensions](../bi-layouting-engine-skills/skills/r3-reactive-extensions/SKILL.md) — R3 reactive patterns
- [serialization](../bi-layouting-engine-skills/skills/serialization/SKILL.md) — JSON, protobuf, message serialization

---

## 📦 Package & Dependency Management

- [package-management](../bi-layouting-engine-skills/skills/package-management/SKILL.md) — NuGet & version management

---

## ⏱️ Utilities

- [slopwatch](../bi-layouting-engine-skills/skills/slopwatch/SKILL.md) — Performance timing & benchmarking
- [dotnet-benchmark-designer](../bi-layouting-engine-skills/agents/dotnet-benchmark-designer.md) — BenchmarkDotNet optimization
- [dotnet-performance-analyst](../bi-layouting-engine-skills/agents/dotnet-performance-analyst.md) — Performance profiling

---

## 🎯 Quick Start by Task

**Building a new .NET API?**
→ Start with `CLAUDE.md` → `/skill-dotnet-modular-monolith` → [csharp-coding-standards](../bi-layouting-engine-skills/skills/csharp-coding-standards/SKILL.md)

**Need async patterns?**
→ [csharp-concurrency-patterns](../bi-layouting-engine-skills/skills/csharp-concurrency-patterns/SKILL.md)

**Testing microservices?**
→ [testcontainers](../bi-layouting-engine-skills/skills/testcontainers/SKILL.md) + [aspire-integration-testing](../bi-layouting-engine-skills/skills/aspire-integration-testing/SKILL.md)

**Using Akka.NET actors?**
→ [akka-best-practices](../bi-layouting-engine-skills/skills/akka-best-practices/SKILL.md) + [akka-testing-patterns](../bi-layouting-engine-skills/skills/akka-testing-patterns/SKILL.md)

**Debugging performance?**
→ [dotnet-performance-analyst](../bi-layouting-engine-skills/agents/dotnet-performance-analyst.md) agent

**Working with databases?**
→ [efcore-patterns](../bi-layouting-engine-skills/skills/efcore-patterns/SKILL.md) + [database-performance](../bi-layouting-engine-skills/skills/database-performance/SKILL.md)

---

**Last Updated**: 2026-06-29  
**Source**: https://github.com/Aaronontheweb/dotnet-skills.git
