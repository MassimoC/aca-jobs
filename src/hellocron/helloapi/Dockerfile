FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["helloapi/helloapi.csproj", "helloapi/"]
RUN dotnet restore "helloapi/helloapi.csproj"
COPY . .
WORKDIR "/src/helloapi"
RUN dotnet build "helloapi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "helloapi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "helloapi.dll"]