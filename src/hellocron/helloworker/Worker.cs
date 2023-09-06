namespace helloworker
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private readonly IHostApplicationLifetime _hostApplicationLifetime;

        public Worker(ILogger<Worker> logger, IHostApplicationLifetime hostApplicationLifetime)
        {
            _logger = logger;
            _hostApplicationLifetime = hostApplicationLifetime;
        }

        protected override async Task<int> ExecuteAsync(CancellationToken stoppingToken)
        {
            try
            {
                //code = (int)ExitCode.Success;
                var now = DateTimeOffset.Now;
                var isEven = now.Minute % 2 == 0;

                _logger.LogInformation("... DoTheJob Worker - HelloWorker running at: {time}", now);
                await Task.Delay(5000, stoppingToken);

                if (isEven) { throw new Exception("DoTheJob Worker - Even is evil!"); }

                _logger.LogInformation("... OK ... DoTheJob Worker - HelloWorker TASK completed at: {time}", DateTimeOffset.Now);
                
                return 0;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Job failed");
                return 1;
            }
            finally
            {
                _hostApplicationLifetime.StopApplication();
            }
        }
    }
}