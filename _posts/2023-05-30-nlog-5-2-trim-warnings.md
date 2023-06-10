---
layout: post
title: NLog 5.2 without trim warnings
---

NLog v5.2 changes the recommended way for explicit registration of NLog extensions.
Already now the automatic scanning for assemblies containing NLog extensions was disabled with NLog v5.
Instead NLog users are encouraged to explicitly specify what NLog extensions to load.

NLog extensions are normally loaded by just specifying the assembly-name, and then NLog will dynamically
load the assembly, and NLog will then use reflection to enumerate the types inside the assembly.

When using NET trimming to strip away all unreferenced code, then dynamic assembly loading will not work well.
Dynamically loaded assemblies might reference code that have been stripped from the application. To prevent
all these issues then NET trimming will make build warnings about such possible pitfalls. Thus previous versions
of NLog are reported as being unsafe for NET trimming, because of the ability to dynamically load assemblies.

NLog v5.2 now recommends that one registers the individual NLog extension types like this:
```csharp
NLog.LogManager.Setup().SetupExtensions(ext => {
	ext.RegisterTarget<MyCustomTarget>();
	ext.RegisterLayout<MyCustomLayout>();
	ext.RegisterLayoutRenderer<MyCustomLayoutRenderer>();
});
```

`NLog.Web.AspNetCore` and `NLog.Extensions.Logging` have been updated to automatically register
their NLog extensions the recommended way when calling `UseNLog()` or `AddNLog()`.

If one needs the NLog Logger in ASP.NET Core before the HostBuilder has been created, then
`LoadConfigurationFromAppSettings()` will ensure to register NLog extensions before loading the NLog
configuration:
```charp
var logger = NLog.LogManager.Setup().LoadConfigurationFromAppSettings().GetCurrentClassLogger();
```

NLog v5.2 will no longer perform any assembly loading and scanning during initialization, unless explicitly requested
by the user. NLog will also automatically skip requests for assembly loading, when it detects that assembly types are already registered.
This means NLog will skip the `<extensions>`-section when NLog detects relevant types are already registered the recommended way.

When enabling NET trimming on application publish, then make sure that NLog-configuration file, doesn’t depend on `<extensions>`-section and dynamic assembly loading.
The NET trimming build-warnings about dynamic assembly loading issue has been suppressed in NLog v5.2, since it is no longer used unless explictly requested.
The next major version of NLog will extract all logic for dynamic assembly loading into a separate nuget-package.

## Obsoleted methods that conflicts with application trimming

NLog v5.2 marks several methods as obsolete, to move towards the following goals:

- Move all dynamic assembly loading logic from `ConfigurationItemFactory` into `Setup()` extensions methods. Later moved into separate NLog-nuget-package with next major version.
- Move all file loading logic from `LogManager` / `LogFactory` into `Setup()` extensions methods. Later moved into separate NLog-nuget-package with next major version.
- Promote the `Setup()` extensions methods, instead of having many different static-methods.

The following methods has been marked obsolete on `ConfigurationItemFactory`, with redirection to `Setup()` extensions methods:

- `ConfigurationItemFactory(params Assembly[] assemblies)`-Constructor
- `ConfigurationItemFactory.CreateInstance`-Method for legacy dependency-injection replaced by Register-extension-methods with custom factory-method.
- `ConfigurationItemFactory.RegisterItemsFromAssembly`-Method for explicit assembly loading replaced by extension methods.
- `ConfigurationItemFactory.AssemblyLoading`-EventHandler together with `AssemblyLoadingEventArgs`
- `ConfigurationItemFactory.PreloadAssembly`-Method for explicit assembly loading replaced by extension methods.
- `ConfigurationItemFactory.RegisterType`-Method for explicit assembly loading replaced by extension methods.
- `ConfigurationItemFactory.RegisterType`-Method for explicit assembly loading replaced by extension methods.
- `INamedItemFactory`-Interface prevents correct trimming annotations.
- `INamedItemFactory ConfigurationItemFactory.Targets`-Property prevents correct trimming annotations.
- `INamedItemFactory ConfigurationItemFactory.Layouts`-Property prevents correct trimming annotations.
- `INamedItemFactory ConfigurationItemFactory.LayoutRenderers`-Property prevents correct trimming annotations.
- `INamedItemFactory ConfigurationItemFactory.AmbientProperties`-Property prevents correct trimming annotations.
- `INamedItemFactory ConfigurationItemFactory.TimeSources`-Property prevents correct trimming annotations.
- `INamedItemFactory ConfigurationItemFactory.Filters`-Property prevents correct trimming annotations.
- `INamedItemFactory ConfigurationItemFactory.ConditionMethods`-Property prevents correct trimming annotations.

The following methods has been marked obsolete on `LogManager` / `LogFactory`, with redirection to `Setup()` extension methods:

- `LogManager.LoadConfiguration(string configFile)`-Method replaced by `LogManager.Setup().LoadConfigurationFromFile(...)`
- `LogManager.ConfigurationReloaded`-EventHandler replaced by `LogManager.ConfigurationChanged`-EventHandler
- `LogManager.GetCandidateConfigFilePaths()`-Method replaced by chaining `LogManager.Setup().LoadConfigurationFromFile(...)`
- `LogManager.SetCandidateConfigFilePaths()`-Method replaced by chaining `LogManager.Setup().LoadConfigurationFromFile(...)`
- `LogManager.ResetCandidateConfigFilePath()`-Method replaced by chaining `LogManager.Setup().LoadConfigurationFromFile(...)`

The following methods has been marked obsolete on `SimpleConfigurator`, with redirection to `Setup()` extension methods:

- `SimpleConfigurator.ConfigureForConsoleLogging`-Method replaced by `LogManager.Setup().LoadConfiguration(c => c.ForLogger().WriteToConsole())`
- `SimpleConfigurator.ConfigureForFileLogging`-Method replaced by `LogManager.Setup().LoadConfiguration(c => c.ForLogger().WriteToFile(fileName))`
- `SimpleConfigurator.ConfigureForTargetLogging`-Method replaced by `LogManager.Setup().LoadConfiguration(c => c.ForLogger().WriteTo(target))`

The following methods has been marked obsolete on `XmlLoggingConfiguration`, with redirection to `Setup()` extension methods:

- `XmlLoggingConfiguration.GetCandidateConfigFilePaths()`-Method replaced by chaining `LogManager.Setup().LoadConfigurationFromFile(...)`
- `XmlLoggingConfiguration.SetCandidateConfigFilePaths()`-Method replaced by chaining `LogManager.Setup().LoadConfigurationFromFile(...)`
- `XmlLoggingConfiguration.ResetCandidateConfigFilePath()`-Method replaced by chaining `LogManager.Setup().LoadConfigurationFromFile(...)`

The following methods has been marked obsolete on `LayoutRenderer`, with redirection to `Setup()` extension methods:

- `Target.Register`-Method replaced by `LogManager.Setup().SetupExtensions(ext => ext.RegisterTarget<T>())`-extension-method
- `Layout.Register`-Method replaced by `LogManager.Setup().SetupExtensions(ext => ext.RegisterLayout<T>())`-extension-method
- `LayoutRenderer.Register`-Method replaced by `LogManager.Setup().SetupExtensions(ext => ext.RegisterLayoutRenderer<T>())`-extension-method

For normal NLog users these changes should not give any noise. The more advanced NLog users and maintainers of NLog-extension-libraries,
are encouraged to move away from the obsoleted methods, and provide alternative way without using dynamic assembly loading.

If having questions or problems about these changes, then one is wellcome to open [GitHub Issue](https://github.com/NLog/NLog/issues)

## Dependency Injection without CreateInstance

NLog `ConfigurationItemFactory.CreateInstance` has for a long time been the default way to handle [dependency injection](https://github.com/NLog/NLog/wiki/Dependency-injection-with-NLog).
It allows override of how to create instance of class-type, and parse input-dependencies as constructor parameters.

The `CreateInstance`-delegate has now been marked obsolete, as it doesn't work well with annotations for application trimming.

NLog v5 introduced the ability to acquire dependencies during `InitializeTarget`-method with help from `ResolveService<T>`-method.

NLog v5.2 now also introduces the ability to register extensions together with a custom factory-method:
```csharp
NLog.LogManager.Setup().SetupExtensions(ext => ext.RegisterTarget<MyTarget>(() => new MyTarget(someDependency));
```
