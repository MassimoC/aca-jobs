// Parameters

param appName string
param acaEnvironmentName string
param location string = resourceGroup().location

param image string = 'hello-worker'
param tag string = '3.4.5'


@description('Specifies the maximum number of retries before failing the job.')
param replicaRetryLimit	int = 0
@description('Specifies the maximum number of seconds a Container Apps job replica is allowed to run.')
param replicaTimeout	int = 30


// parameters for Scheduled Jobs
param triggerType string = 'Schedule'
@description('Specifies the Cron formatted repeating schedule ("* * * * *") of a Cron Job.')
param cronExpression	string = '*/1 * * * *'
@description('Specifies the minimum number of successful replica completions before overall Container Apps job completion.')
param replicaCompletionCount	int = 1
@description('Specifies the number of parallel replicas of a Container Apps job that can run at a given time.')
param parallelism	int = 1


resource acaEnvironment 'Microsoft.App/managedEnvironments@2022-03-01' existing =  {
  name: acaEnvironmentName
}

resource job 'Microsoft.App/jobs@2023-05-01' = {
  name: toLower(appName)
  location: location
  properties: {
    configuration: {
      scheduleTriggerConfig: triggerType == 'Schedule' ? {
        cronExpression: cronExpression
        replicaCompletionCount: replicaCompletionCount
        parallelism: parallelism
      } : null
      replicaRetryLimit: replicaRetryLimit
      replicaTimeout: replicaTimeout
      triggerType: triggerType
    }
    environmentId: acaEnvironment.id
    template: {
      containers: [
        {
          image: 'acajobs.azurecr.io/${image}:${tag}'
          name: appName
          resources: {
            cpu: json('0.5')
            memory:'1Gi'
          }
        }
      ]
    }
  }
}

// Outputs
output id string = job.id
output name string = job.name
