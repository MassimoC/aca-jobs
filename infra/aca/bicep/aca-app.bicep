param appName string
param acaEnvironmentName string
param location string = resourceGroup().location


param image string = 'hello-controller'
param tag string = '0.0.1'

param minReplicas int =1
param maxReplicas int =1

resource acaEnvironment 'Microsoft.App/managedEnvironments@2022-03-01' existing =  {
  name: acaEnvironmentName
}

resource daprComponent 'Microsoft.App/managedEnvironments/daprComponents@2022-10-01' = {
  name: 'dothejob'
  parent: acaEnvironment
  properties: {
    componentType: 'bindings.cron'
    version: 'v1'
    metadata: [
      {
        name: 'schedule'
        value: '@every 30s'
      }
      {
        name: 'direction'
        value: 'input'
      }
    ]
    scopes: [
      'dothejob'
    ]
  }
}

resource containerApp 'Microsoft.App/containerApps@2022-10-01' = {
  name: appName
  location: location
  properties: {
    environmentId: acaEnvironment.id
    configuration: {
      activeRevisionsMode:'Single'
      dapr:{
        enabled: true
        appId:'dothejob'
        appProtocol: 'http'
        appPort:80
        logLevel:'debug'
      }
    }
    template: {
      containers: [
        {
          image: 'acajobs.azurecr.io/${image}:${tag}'
          name: appName
          resources:{
            cpu: json('0.5')
            memory:'1Gi'
          }
        }
      ]
      scale:{
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
  dependsOn: [
    daprComponent
  ] 
}
