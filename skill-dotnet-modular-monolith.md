# skill-dotnet-modular-monolith

> Universal .NET Architecture Standard — Modular Monolith with DDD + Event-Driven Communication

## What This Skill Does

Provides a comprehensive template, patterns, and architectural guidance for building **clean, scalable ASP.NET Core 10 projects** using:

- **Modular Monolith** structure (separate layers, acyclic dependencies)
- **Domain-Driven Design (DDD)** (aggregates, value objects, domain events, business rules)
- **Event-Driven Communication** (between modules and services)
- **Strict Quality Rules** (YAGNI, KISS, DRY, SPOT, SoC, acyclic dependencies)
- **Dependency Injection** patterns for testability
- **Minimal APIs** for ASP.NET Core endpoints
- **Unit & Integration Testing** strategies

## When to Use

✅ **Use this when**:
- Creating a **new ASP.NET Core project** from scratch
- Setting up **module boundaries** and dependency rules
- Implementing **DDD patterns** (aggregates, value objects, events)
- Enforcing **code quality standards** across a team
- Building **event-driven microservices** that started as a monolith
- Reviewing **architecture compliance** of existing services

❌ **Don't use for**:
- Quick scripts or prototypes (overkill)
- Migrating existing projects without architecture redesign
- Projects not using .NET (wrong tech stack)

## Key Principles (Non-Negotiable)

### YAGNI — You Aren't Gonna Need It
- **DELETE** unused abstractions immediately
- No hypothetical features or "future-proofing"
- Build for what exists NOW, refactor when patterns emerge

### KISS — Keep It Simple, Stupid
- Readable code > clever code
- Obvious > magic
- ❌ Nested ternary operators, terse names, over-clever implementations
- ✅ Simple loops, explicit types, straightforward error handling

### DRY — Don't Repeat Yourself
- **1 repetition**: No action
- **2 repetitions**: Watch for it
- **3+ repetitions**: MUST extract to shared function/class
- **Single Point of Truth**: Each concept in ONE place (config, types, rules)

### SPOT — Single Point of Truth
- Configuration → `appsettings.json` (never scattered)
- Business rules → Domain layer (never in endpoints)
- DTOs → Models project (never duplicated)
- Abstractions → Abstractions project (never in Services)

### SoC — Separation of Concerns
- Each class has ONE reason to change
- Endpoints don't fetch data → pass as injected service
- Services don't know about HTTP status codes → return domain models
- Domain layer has ZERO external dependencies

### Acyclic Dependencies
- Module dependencies form a DAG (directed acyclic graph)
- ❌ Module A imports Module B AND Module B imports Module A
- Enforced by NetArchTest at build time

## Project Structure

```
src/
├── {ProjectName}.Abstractions/              ← Interfaces ONLY
│   ├── Services/IXxxService.cs
│   ├── Repositories/IRepository.cs
│   └── Models/Requests, Responses/
│
├── {ProjectName}.Services/                  ← Implementations
│   ├── Services/XxxService.cs
│   ├── Repositories/XxxRepository.cs
│   ├── ExternalApis/ExternalApiClient.cs
│   └── Authorization/UserRoleService.cs
│
├── {ProjectName}.Models/                    ← DTOs (no logic)
│   ├── Authorization/
│   ├── Requests/
│   └── Responses/
│
├── {ProjectName}.Domain/                    ← Business logic (DDD)
│   ├── Aggregates/EntityAggregate.cs
│   ├── ValueObjects/EntityId.cs
│   ├── DomainEvents/EntityCreatedEvent.cs
│   └── BusinessRules/IBusinessRule.cs
│
├── {ProjectName}.Infrastructure/            ← Data access, AWS, APIs
│   ├── Persistence/DbContext.cs
│   ├── ExternalApis/HttpClients
│   ├── Cloud/CloudService.cs
│   └── Configuration/
│
└── {ProjectName}/                           ← Main API (Endpoints + DI)
    ├── Endpoints/FeatureEndpoints.cs
    ├── Middleware/CorrelationIdMiddleware.cs
    ├── Authorization/Policies.cs
    └── Program.cs
```

## Dependency Flow (Acyclic)

```
Endpoint 
  ↓
IService (Abstraction from {ProjectName}.Abstractions)
  ↓
Service (Implementation from {ProjectName}.Services)
  ↓
IRepository (Abstraction)
  ↓
Repository (Implementation)
  ↓
Domain layer or external APIs
```

### ✅ ALLOWED
- Endpoint → IService abstraction
- Service → IRepository abstraction
- Repository → external APIs or database
- Service → Domain events or domain models

### ❌ BLOCKED (Build will fail)
- Service A → Service B directly (no abstraction)
- Endpoint → concrete Service (bypasses abstraction)
- Module X → Module Y (cross-module coupling)
- Domain → Infrastructure (domain is pure)
- Circular: A → B → A (acyclic constraint)

## Code Patterns

### Service Layer
```csharp
public sealed class XxxService(
    IRepository repository,
    IExternalApi externalApi,
    ILogger<XxxService> logger)
    : IXxxService
{
    public async Task<FeatureDto?> GetAsync(string id, CancellationToken ct)
    {
        logger.LogInformation("Fetching feature {FeatureId}", id);
        try
        {
            var entity = await repository.GetByIdAsync(id, ct);
            return entity is not null ? MapToDto(entity) : null;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error fetching feature {FeatureId}", id);
            throw;
        }
    }
}
```

### DDD Aggregate
```csharp
public sealed class FeatureAggregate : AggregateRoot
{
    public static FeatureAggregate Create(string name, string description)
    {
        if (string.IsNullOrWhiteSpace(name))
            throw new BusinessRuleValidationException(new NameCannotBeEmptyRule());

        var aggregate = new FeatureAggregate
        {
            Id = FeatureId.Create(),
            Name = name,
            Description = description
        };

        aggregate.AddDomainEvent(new FeatureCreatedDomainEvent(aggregate.Id, name));
        return aggregate;
    }
}
```

### Minimal API Endpoint
```csharp
public static class FeatureEndpoints
{
    public static void MapFeatureEndpoints(this WebApplication app)
    {
        var group = app.MapGroup("/api/v1/features")
            .RequireAuthorization(Policies.ReadAccess);

        group.MapGet("/{id}", GetFeature);
        group.MapPost("/", CreateFeature);
    }

    private static async Task<IResult> GetFeature(
        string id,
        IXxxService service,
        CancellationToken ct)
    {
        var result = await service.GetAsync(id, ct);
        return result is not null ? Results.Ok(result) : Results.NotFound();
    }
}
```

### Dependency Injection (Program.cs)
```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddScoped<IXxxService, XxxService>();
builder.Services.AddScoped<IRepository, Repository>();
builder.Services.AddHttpClient<IExternalApi, ExternalApiClient>();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddMicrosoftIdentityWebApi(builder.Configuration.GetSection("AzureAd"));

builder.Services.AddAuthorization(options =>
{
    options.AddPolicy(Policies.ReadAccess, p => p.RequireRole(AppRoles.Reader));
});

var app = builder.Build();
app.UseMiddleware<CorrelationIdMiddleware>();
app.UseAuthentication();
app.UseAuthorization();
app.MapFeatureEndpoints();
await app.RunAsync();
```

## Testing

### Unit Tests (Domain Logic)
```csharp
[TestClass]
public class FeatureAggregateTests
{
    [TestMethod]
    public void Create_WithValidData_CreatesSuccessfully()
    {
        var feature = FeatureAggregate.Create("Test", "Description");
        Assert.IsNotNull(feature);
        Assert.AreEqual("Test", feature.Name);
    }

    [TestMethod]
    public void Create_WithEmptyName_ThrowsBusinessRuleException()
    {
        Assert.ThrowsException<BusinessRuleValidationException>(
            () => FeatureAggregate.Create("", "Description"));
    }
}
```

### Integration Tests
```csharp
[TestClass]
public class FeatureEndpointTests : IAsyncLifetime
{
    private WebApplicationFactory<Program> _factory;
    private HttpClient _client;

    public async Task InitializeAsync()
    {
        _factory = new WebApplicationFactory<Program>();
        _client = _factory.CreateClient();
        await Task.CompletedTask;
    }

    [TestMethod]
    public async Task GetFeature_WithValidId_Returns200()
    {
        var response = await _client.GetAsync("/api/v1/features/feature-1");
        Assert.AreEqual(System.Net.HttpStatusCode.OK, response.StatusCode);
    }

    public async Task DisposeAsync() => await _factory.DisposeAsync();
}
```

## Code Quality Checklist

Before committing, verify:

- [ ] No hardcoded secrets (all in `appsettings.json` or env vars)
- [ ] All external I/O is async with `CancellationToken`
- [ ] Services depend ONLY on Abstractions (never other Services)
- [ ] No copy-paste code (extract at 3+ repetitions)
- [ ] Tests cover happy path + error cases
- [ ] No `.Result` or `.Wait()` anywhere
- [ ] **YAGNI**: No unused abstractions or premature features
- [ ] **KISS**: Code is obvious without long comments
- [ ] **DRY**: No duplicated logic/config/types
- [ ] **SPOT**: Each concept in ONE place
- [ ] **SoC**: Each class has ONE reason to change
- [ ] **Acyclic**: No circular module dependencies
- [ ] Architecture tests pass (NetArchTest if implemented)

## Commands

| Task | Command |
|------|---------|
| Build | `dotnet build` |
| Run | `dotnet run --project src/{ProjectName}/` |
| Test All | `dotnet test` |
| Test Unit Only | `dotnet test --filter Category!=Integration` |
| Clean | `dotnet clean && rm -rf **/bin **/obj` |

## Dependencies

This skill references:

1. **[claude-git-pr-skill](https://github.com/aidankinzett/claude-git-pr-skill)** — PR creation automation
2. **[dotnet-skills](https://github.com/Aaronontheweb/dotnet-skills.git)** — .NET CLI helpers
3. **[code-review-skill](https://github.com/awesome-skills/code-review-skill.git)** — Code quality checks

All included as git submodules (no duplication).

## Common Mistakes to Avoid

### ❌ Creating abstractions for one-off implementations
If you only have ONE implementation, don't create an interface. Wait until you need a second.

### ❌ Putting business logic in endpoints
Services should return domain models, not HTTP-specific objects.

### ❌ Circular dependencies between modules
If Module A needs something from Module B, create an abstraction in a shared Abstractions layer.

### ❌ Mutable entities
Domain aggregates should be immutable or explicitly manage state changes via methods.

### ❌ No logging
Log at decision points (cache hit, external API call, error). Include context (IDs, values).

### ❌ Synchronous external calls
Every external I/O (database, HTTP, file system) must be async with `CancellationToken`.

### ❌ Global state or static methods in services
Inject dependencies. Makes testing and composition predictable.

## Golden Rule

**Code should be obvious in under 2 minutes of reading. If not, simplify it.**

---

**For the full reference**: See CLAUDE.md in the project root or README.md for detailed examples and workflows.
