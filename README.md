# aca-jobs
Running scheduled jobs on Azure Container Apps.

Three ways
* as ACA job
* using DAPR binding
* hosting Functions on ACA (cron binding not available in public preview)


## Build and local tests

```
cd src\hellocron\hellocontroller

dapr run --app-id dothejob --app-port 7220 --dapr-http-port 3500 --app-ssl --components-path ../daprconfig -- dotnet run --launch-profile https

```

Build Docker container for the API

```shell
cd src\hellocron

docker build . --tag hello-controller:0.1.2 --file .\hellocontroller\Dockerfile --no-cache

docker run -p 8080:80 --detach hello-controller:0.1.2 

curl -iv http://localhost:8080/DoTheJob

```

Build Docker container for the worker

```shell
cd src\hellocron

docker build . --tag hello-worker:3.4.5 --file .\helloworker\Dockerfile --no-cache

docker run --detach hello-worker:3.4.5

docker ps

docker log <containerid>
```

## Provision the test infrastructure

```shell
az login --tenant <TID>
az account set --subscription <SID>
```

```
cd infra/aca

sh deploy.sh
```

## Push apps to the registry

Worker - Tag and Push the images to the registry.


```shell
cd src\hellocron

# Tag
docker tag hello-worker:3.4.5 acajobs.azurecr.io/hello-worker:3.4.5

# Login
az acr login --name acajobs 

# Push
docker push acajobs.azurecr.io/hello-worker:3.4.5

az acr repository list --name acajobs -o table

```

API

```shell
cd src\hellocron

# Tag
docker tag hello-controller:0.1.2 acajobs.azurecr.io/hello-controller:0.1.2

# Login
az acr login --name acajobs

# Push
docker push acajobs.azurecr.io/hello-controller:0.1.2
```

## Deploy the demo app and the job

```
cd aca/infra

sh deploy.sh

```
