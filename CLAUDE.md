# CLAUDE.md — Universal .NET Project Template

**Use This For**: ANY new ASP.NET Core 10 project you create
**Architecture**: Modular Monolith with DDD + Event-Driven Communication  
**Reference**: `/pbi-dotnet-modular-monolith` (universal .NET standard for ALL projects)

---

## ⚠️ PLACEHOLDER INSTRUCTION

**`{ProjectName}` = Replace with your actual project name**

Example: Creating an order service?
- Find: `{ProjectName}`
- Replace All: `OrderService`

All file/folder names, namespaces, and class names will auto-update. Then delete this section.

---

## Core Engineering Rules (Non-Negotiable)

### 1. YAGNI (You Aren't Gonna Need It)
- **DELETE** unused abstractions immediately
- No hypothetical features or "future-proofing"
- Build for what exists NOW, refactor when patterns emerge

### 2. KISS (Keep It Simple, Stupid)
- Readable code > clever code
- Obvious > magic
- ❌ Nested ternary operators, terse names, over-clever implementations
- ✅ Simple loops, explicit types, straightforward error handling

### 3. DRY (Don't Repeat Yourself)
- **1 repetition**: No action
- **2 repetitions**: Watch for it
- **3+ repetitions**: MUST extract to shared function/class
- **Single Point of Truth**: Each concept in ONE place (config, types, rules)

### 4. SPOT (Single Point of Truth)
- Configuration → `appsettings.json` (never scattered)
- Business rules → Domain layer (never in endpoints)
- DTOs → Models project (never duplicated)
- Abstractions → Abstractions project (never in Services)

### 5. SoC (Separation of Concerns)
- Each class has ONE reason to change
- Endpoints don't fetch data → pass as injected service
- Services don't know about HTTP status codes → return domain models
- Domain layer has ZERO external dependencies

### 6. Acyclic Dependencies
- Module dependencies form a DAG (directed acyclic graph)
- ❌ Module A imports Module B AND Module B imports Module A
- Enforced by NetArchTest at build time

---

## Project Structure (Modular Monolith Template)

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

---

## Module Boundary Rules (Enforced)

### ✅ ALLOWED Dependencies

```csharp
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

### ❌ BLOCKED (Build will fail)

```csharp
Service A → Service B directly (no abstraction)
Endpoint → concrete Service (bypasses abstraction)
Module X → Module Y (cross-module coupling)
Domain → Infrastructure (domain is pure)
Circular: A → B → A (acyclic constraint)
```

---

## DI Registration Pattern (Program.cs)

```csharp
var builder = WebApplication.CreateBuilder(args);

// Register Abstractions → Implementations
builder.Services.AddScoped<IXxxService, XxxService>();
builder.Services.AddScoped<IRepository, Repository>();
builder.Services.AddSingleton<IAuthService, AuthService>();

// HTTP clients
builder.Services.AddHttpClient<IExternalApi, ExternalApiClient>()
    .AddHttpMessageHandler<ApiAuthHandler>();

// Cloud services (AWS, Azure, etc.)
builder.Services.AddAWSService<IAmazonDynamoDB>();
// OR
// builder.Services.AddAzureClients();

// Authentication
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddMicrosoftIdentityWebApi(builder.Configuration.GetSection("AzureAd"));

// Authorization
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy(Policies.ReadAccess, p => p.RequireRole(AppRoles.Reader));
});

// Logging
builder.Services.AddLogging(cfg => cfg.AddConsole());

var app = builder.Build();

// Middleware
app.UseMiddleware<CorrelationIdMiddleware>();
app.UseAuthentication();
app.UseAuthorization();

// Endpoints
app.MapXxxEndpoints();
app.MapHealthEndpoints();

await app.RunAsync();
```

---

## Endpoint Pattern (Minimal APIs)

```csharp
public static class FeatureEndpoints
{
    public static void MapFeatureEndpoints(this WebApplication app)
    {
        var group = app.MapGroup("/api/v1/features")
            .RequireAuthorization(Policies.ReadAccess);

        group.MapGet("/{id}", GetFeature);
        group.MapPost("/", CreateFeature);
        group.MapPut("/{id}", UpdateFeature);
        group.MapDelete("/{id}", DeleteFeature);
    }

    private static async Task<IResult> GetFeature(
        string id,
        IXxxService service,
        CancellationToken ct)
    {
        try
        {
            var result = await service.GetAsync(id, ct);
            return result is not null 
                ? Results.Ok(result) 
                : Results.NotFound();
        }
        catch (Exception ex)
        {
            return Results.Problem(detail: ex.Message, statusCode: 500);
        }
    }

    private static async Task<IResult> CreateFeature(
        CreateFeatureRequest request,
        IXxxService service,
        CancellationToken ct)
    {
        try
        {
            var id = await service.CreateAsync(request, ct);
            return Results.Created($"/api/v1/features/{id}", new { id });
        }
        catch (ValidationException ex)
        {
            return Results.BadRequest(ex.Message);
        }
    }

    private static async Task<IResult> UpdateFeature(
        string id,
        UpdateFeatureRequest request,
        IXxxService service,
        CancellationToken ct)
    {
        try
        {
            await service.UpdateAsync(id, request, ct);
            return Results.NoContent();
        }
        catch (NotFoundException)
        {
            return Results.NotFound();
        }
    }

    private static async Task<IResult> DeleteFeature(
        string id,
        IXxxService service,
        CancellationToken ct)
    {
        try
        {
            await service.DeleteAsync(id, ct);
            return Results.NoContent();
        }
        catch (NotFoundException)
        {
            return Results.NotFound();
        }
    }
}
```

---

## Service Layer Pattern

```csharp
public sealed class XxxService(
    IRepository repository,
    IExternalApi externalApi,
    ILogger<XxxService> logger)
    : IXxxService
{
    public async Task<FeatureDto?> GetAsync(
        string id,
        CancellationToken ct)
    {
        logger.LogInformation("Fetching feature {FeatureId}", id);
        
        try
        {
            // Try cache/repository first
            var entity = await repository.GetByIdAsync(id, ct);
            if (entity is not null)
                return MapToDto(entity);

            // Fetch from external source if needed
            var external = await externalApi.GetAsync(id, ct);
            if (external is not null)
            {
                var newEntity = Entity.Create(external);
                await repository.AddAsync(newEntity, ct);
                return MapToDto(newEntity);
            }

            return null;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error fetching feature {FeatureId}", id);
            throw;
        }
    }

    public async Task<string> CreateAsync(
        CreateFeatureRequest request,
        CancellationToken ct)
    {
        logger.LogInformation("Creating feature with name {Name}", request.Name);
        
        try
        {
            var entity = Entity.Create(request.Name, request.Description);
            await repository.AddAsync(entity, ct);
            return entity.Id;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error creating feature");
            throw;
        }
    }

    private FeatureDto MapToDto(Entity entity)
    {
        return new FeatureDto 
        { 
            Id = entity.Id, 
            Name = entity.Name,
            Description = entity.Description
        };
    }
}
```

---

## Domain Layer Pattern (DDD)

```csharp
public sealed class FeatureAggregate : AggregateRoot
{
    private string _name;
    private string _description;

    private FeatureAggregate() { }

    public static FeatureAggregate Create(string name, string description)
    {
        if (string.IsNullOrWhiteSpace(name))
            throw new BusinessRuleValidationException(
                new NameCannotBeEmptyRule());

        var aggregate = new FeatureAggregate
        {
            Id = FeatureId.Create(),
            _name = name,
            _description = description
        };

        aggregate.AddDomainEvent(
            new FeatureCreatedDomainEvent(aggregate.Id, name));

        return aggregate;
    }

    public void Update(string name, string description)
    {
        CheckRule(new NameCannotBeEmptyRule());
        
        _name = name;
        _description = description;
        
        AddDomainEvent(
            new FeatureUpdatedDomainEvent(Id, name));
    }

    protected void CheckRule(IBusinessRule rule)
    {
        if (rule.IsBroken())
            throw new BusinessRuleValidationException(rule);
    }
}

public sealed class FeatureId : TypedIdValueBase
{
    public static FeatureId Create() => new(Guid.NewGuid());
}

public class NameCannotBeEmptyRule : IBusinessRule
{
    public bool IsBroken => string.IsNullOrWhiteSpace(_name);
    public string Message => "Feature name cannot be empty";
}
```

---

## Testing Strategy

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

### Integration Tests (Full Flow)

```csharp
[TestClass]
public class FeatureEndpointTests : IAsyncLifetime
{
    private WebApplicationFactory<Program> _factory;
    private HttpClient _client;

    public async Task InitializeAsync()
    {
        _factory = new WebApplicationFactory<Program>()
            .WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    services.RemoveAll<IExternalApi>();
                    services.AddSingleton(MockExternalApi());
                });
            });
        _client = _factory.CreateClient();
        await Task.CompletedTask;
    }

    [TestMethod]
    public async Task GetFeature_WithValidId_Returns200()
    {
        var response = await _client.GetAsync("/api/v1/features/feature-1");
        Assert.AreEqual(System.Net.HttpStatusCode.OK, response.StatusCode);
    }

    [TestMethod]
    public async Task CreateFeature_WithValidData_Returns201()
    {
        var request = new { name = "New Feature", description = "Test" };
        var content = new StringContent(
            JsonSerializer.Serialize(request),
            Encoding.UTF8,
            "application/json");

        var response = await _client.PostAsync("/api/v1/features", content);
        Assert.AreEqual(System.Net.HttpStatusCode.Created, response.StatusCode);
    }

    public async Task DisposeAsync() => await _factory.DisposeAsync();
}
```

---

## Code Quality Checklist (Before Every Commit)

- [ ] No hardcoded secrets (all in `.env` / appsettings.json)
- [ ] All external I/O is async with CancellationToken
- [ ] Logging at decision points (especially errors with context)
- [ ] Services depend ONLY on Abstractions (never other Services)
- [ ] No copy-paste code (extract if seen 3+ times)
- [ ] Tests cover happy path + error cases
- [ ] No `.Result` or `.Wait()` anywhere
- [ ] **YAGNI**: No unused abstractions or premature features
- [ ] **KISS**: Code is obvious without needing long comments
- [ ] **DRY**: No duplicated logic/config/types
- [ ] **SPOT**: Each concept in ONE place (config, types, rules)
- [ ] **SoC**: Each class has ONE reason to change
- [ ] **Acyclic**: No circular module dependencies
- [ ] Architecture tests pass (NetArchTest if implemented)

---

## Commands (Template)

| Task       | Command                            | Notes                          |
|------------|------------------------------------|--------------------------------|
| Build      | `dotnet build`                     | Compile entire solution        |
| Run        | `dotnet run --project src/{ProjectName}/` | Start API locally |
| Test       | `dotnet test`                      | Run all tests                  |
| Test Unit  | `dotnet test --filter Category!=Integration` | Unit tests only |
| Clean      | `dotnet clean && rm -rf **/bin **/obj` | Remove build artifacts |

---

## When in Doubt

1. **Check the universal standard**: `/pbi-dotnet-modular-monolith`
2. **Apply YAGNI/KISS/DRY/SPOT**: Simplicity wins every time
3. **Inject abstractions**: Never direct service calls between modules
4. **Add structured logging**: Context + decision points
5. **Write tests first**: Unit + integration

**Golden Rule**: Code should be obvious in under 2 minutes of reading. If not, simplify it.

