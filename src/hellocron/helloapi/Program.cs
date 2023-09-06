using Microsoft.Extensions.Logging;

var builder = WebApplication.CreateBuilder(args);
var _logger = LoggerFactory.Create(config =>
{
    config.AddConsole();
}).CreateLogger("Program");

// Add services to the container.
builder.Services.AddDaprClient();
builder.Services.AddControllers();

var app = builder.Build();

// Configure the HTTP request pipeline.

app.MapPost("/dothejob", async context =>
{
    _logger.LogInformation("HelloAPI running at: {time}", DateTimeOffset.Now);
    await Task.Delay(5000);
    _logger.LogInformation("HelloAPI TASK completed at: {time}", DateTimeOffset.Now);
    await context.Response.WriteAsync("Task completed!");
});

app.Run();

