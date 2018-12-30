FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 59198
EXPOSE 44312

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["docker/github-circleci-kubernetes/HelloWorld/HelloWorld.csproj", "docker/github-circleci-kubernetes/HelloWorld/"]
RUN dotnet restore "docker/github-circleci-kubernetes/HelloWorld/HelloWorld.csproj"
COPY . .
WORKDIR "/src/HelloWorld"
RUN dotnet build "docker/github-circleci-kubernetes/HelloWorld/HelloWorld.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "docker/github-circleci-kubernetes/HelloWorld/HelloWorld.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "HelloWorld.dll"]