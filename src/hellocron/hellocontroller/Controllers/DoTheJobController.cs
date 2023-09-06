using Dapr.Client;
using Google.Api;
using Microsoft.AspNetCore.Mvc;

namespace hellocontroller.Controllers
{
    [ApiController]
    [Route("DoTheJob")]
    public class DoTheJobController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
            { "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching" };

        private readonly ILogger<DoTheJobController> _logger;
        private readonly DaprClient _daprClient;


        public DoTheJobController(ILogger<DoTheJobController> logger, DaprClient daprClient)
        {
            _logger = logger;
            _daprClient = daprClient;
        }

        [HttpPost]
        public async Task<SignalsBag> DoTheJob()
        {
            var now = DateTimeOffset.Now;
            var isEven = now.Minute % 2 == 0;

            _logger.LogInformation("... DoTheJob Controller - running at: {time}", now);
            await Task.Delay(5000);
            if (isEven) { throw new Exception("DoTheJob Controller - Even is evil!"); }

            _logger.LogInformation("... OK ... DoTheJob Controller - TASK completed at: {time}", DateTimeOffset.Now);
            return new SignalsBag { TemperatureC=39 };
        }

        [HttpGet]
        public async Task<String> GetTheString()
        {
            _logger.LogInformation("... DoTheJob Controller - GetTheString running at: {time}", DateTimeOffset.Now);
            await Task.Delay(1);

            return  "hello world";
        }
    }
}