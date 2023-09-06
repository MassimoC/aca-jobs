FROM mcr.microsoft.com/dotnet/runtime:7.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["helloworker/helloworker.csproj", "helloworker/"]
RUN dotnet restore "helloworker/helloworker.csproj"
COPY . .
WORKDIR "/src/helloworker"
RUN dotnet build "helloworker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "helloworker.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "helloworker.dll"]