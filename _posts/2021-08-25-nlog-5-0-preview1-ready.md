---
layout: post
title: NLog 5.0 - List of major changes
---

NLog 5.0 is a major version bump, and includes several breaking changes and lots of improvements.

## New Features

### NLog is now faster and lighter
The NLog mantra has been to come running with all guns loaded. But some guns are bigger than others, and their weight have
changed the running into a fast walk. New platforms have arrived that has a strong focus on only bringing the absolute
necessary and nothing else.

NLog now performs faster initialization because it now skips automatic scanning and loading of NLog-extensions,
unless it has been explicitly specified by the NLog.config. The extensions autoload feature was introduced with NLog 4.0,
but is now disabled by default with NLog 5.0. The autoload feature also doesn't work that great, when using packagereferences
which is the default for .NET Core platform. This means custom targets requires explicit `<add assembly="NLog.MyAssembly" />`,
or use the new ability to specify type with assembly-name: `<target type="MyTarget, NLog.MyAssembly" name="hello" />`.

NLog also skips initialization of NLog InternalLogger from environment variables and app.config. This also reduces the
impact on initialization time.

NLog-nuget-package has also been split into several isolated nuget-packages to reduce dependencies. The out-of-box
experience with NLog is affected by this, as now one must add extra nuget-package for database writing. This reduces
the number of System-dependencies, but also prevents false positive security risk warnings about DatabaseTarget
being able to execute SQL.

These references will no longer be added automatically, when wanting to use the NLog Logger in a .NET Framework-project:
- `<Reference Include="System.Data" />`
- `<Reference Include="System.Runtime.Serialization" />`
- `<Reference Include="System.ServiceModel" />`
- `<Reference Include="System.Transactions" />`

This also makes it easier for users running on other operating system platforms to navigate the NLog source-repository.
Several Windows specific dependencies have now been extracted into their own nuget-packages.

### NLog Layout for everything
NLog Layout logic is almost magical especially when creating string output, but less magical when handling simple output types.

This is the usual code when using `Layout` for an integer value:
```csharp
int eventId = 0;
string renderEventId = EventIdLayout.Render(logEvent);
if (string.IsNullOrEmpty(renderEventId) || !int.TryParse(renderEventId, out eventId))
{
    eventId = 42;   // fallback default value
}
```

This has now been improved with the introduction of `Layout<T>` that automatically handles parsing and fallback value,
and at the same time provides better performance than normal `Layout` when handling static values.
```csharp
int eventId = EventIdLayout.RenderValue(logEvent, defaultValue: 42);
```
This makes it easier for NLog Target developers to use NLog Layout everywhere without having to worry about handling
parsing and conversion issues.

NLog Targets that has been extracted from the default NLog-nuget-package has now also been updated to make use of the
new `Layout<T>`-features.

### NLog ScopeContext to replace MDC + MDLC + NDC + NDLC
NLog ScopeContext has been introduced to cater for Microsoft Extension Logging (MEL) [ILogger.BeginScope](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.ilogger.beginscope).
Instead of building dictionary-objects upfront to hold context-state, then creation of lookup-dictionary is deferred
until logging requires lookup of scope-properties. When using NLog as Logging Provider in MEL, then performance of
[ILogger.BeginScope](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.ilogger.beginscope) has
been improved dramatically.

These are the performance numbers when just using [ILogger.BeginScope](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.ilogger.beginscope) but no logevents are written.

| Test Name        | Time (ms) | Calls/sec | GC2 | GC1 | GC0  | CPU (ms) | Alloc (MB) |
|------------------|-----------|-----------|-----|-----|------|----------|------------|
| NLog v5.0        |     6.026 | 1.659.339 |   0 |   0 | 393  |    6.156 |    5.493,2 |
| NLog v4.7        |    20.144 |   496.415 |   0 |   0 | 1187 |   20.796 |   16.479,5 |

ScopeContext merges MDC and MDLC together, as it has been a long standing wish not to have two different ways of handling context-properties.
ScopeContext also includes NDC and NDLC to better support [ILogger.BeginScope](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.ilogger.beginscope)
way of pushing context-properties and nested context-state in a single call.

NLog Logger object also includes new methods `Logger.PushScopeProperty` and `Logger.PushScopeNested` to make it easy to update the NLog ScopeContext.

### NLog Layout stored as NLog Configuration Variables
NLog Configuration Variables now has support for other types of Layouts than `SimpleLayout`. This means a NLog Configuration Variable
can hold a `JsonLayout`, and it can be referenced by multiple targets.

```xml
<nlog>
    <variable name="myJson">
        <layout type="JsonLayout">
            <attribute name="shortdate" layout="${shortdate}" />
            <attribute name="message" layout="${message}" />
        </layout>
    </variable>
    <targets>
        <target type="console" layout="${myJson}" />
        <target type="file" layout="${myJson}" />
    </targets>
    <rules>
        <logger minLevel="Debug" writeTo="console,file" />
    </rules>
</nlog>
```

### Fluent API for NLog LoggingConfiguration
NLog has from the beginning supported configuration from both API and NLog.config. But the main focus has been to
provide an elegant experience with NLog.config. Lately other frameworks like Microsoft Extension Logging have shown
how the programmatically API can be just as elegant, and at the same time removing issues from dynamic type loading.

NLog has extended its `NLog.LogManager.Setup()` to make it easy to setup NLog Targets and filtering with NLog LoggingRules:
```c#
var logger = LogManager.Setup().LoadConfiguration(c =>
{
   c.ForLogger("*").FilterMinLevel(NLog.LogLevel.Info).WriteTo(new ConsoleTarget("logconsole")).WithAsync();
   c.ForLogger().WriteTo(new FileTarget("logfile") { FileName = "file.txt" }).WithAsync();
}).GetCurrentClassLogger();
```

NLog has very strong support for filtering, where multiple LoggingRules are redirecting to the same NLog target.
This is also possible with the new fluent API:

```c#
var logger = LogManager.Setup().LoadConfiguration(c =>
{
   var consoleTarget = c.ForTarget("console").WriteTo(new ConsoleTarget()).WithAsync();
   var fileTarget = c.ForTarget("logfile").WriteTo(new FileTarget() { FileName = "file.txt" }).WithAsync();

   // Suppress noise from Microsoft-classes, except from Microsoft.Hosting.Lifetime for startup detection
   c.ForLogger("Microsoft.Hosting.Lifetime*").FilterMinLevel(NLog.LogLevel.Info).WriteTo(consoleTarget);
   c.ForLogger("System*").WriteToNil(NLog.LogLevel.Warn);
   c.ForLogger("Microsoft*").WriteToNil(NLog.LogLevel.Warn);

   c.ForLogger().FilterMinLevel(NLog.LogLevel.Info).WriteTo(consoleTarget);
   c.ForLogger().FilterMinLevel(NLog.LogLevel.Debug).WriteTo(fileTarget);
}).GetCurrentClassLogger();
```

### NLog Callsite from caller member attributes
NLog already had support for caller member attributes through the NLog.Fluent-API. But it saved the CallSite-information into
`LogEventInfo.Properties`. This has now changed so it will use the method `LogEventInfo.SetCallerInfo`, so it is no longer
necessary to exclude the sometimes unwanted properties.

`${callsite}` no longer requires the capture of StackTrace to render the callsite, but can rely on the input from
`LogEventInfo.SetCallerInfo`. This means that `${callsite}` will have much less overhead when using API that uses
`LogEventInfo.SetCallerInfo`.

The old NLog.Fluent-API had some overhead, where it performed memory allocation even when the LogLevel was disabled. It also
had some overloads that didn't work well, when working with an isolated NLog LogFactory. Now the old NLog.Fluent-API has
been marked obsolete, and instead a new `LogEventBuilder` has been introduced in the standard NLog-namespace:

```c#
logger.ForErrorEvent()
      .Message("This is a test fluent message.")
      .Property("Test", "TraceWrite")
      .Log();
```

When using `LogEventBuilder` for logging, then it will automatically captures callsite details with very little overhead
with help from `C#` caller member attributes.

### LogFactory with Dependency Injection
NLog now includes better support for dependency injection, so instead of having a global object-factory-delegate
that affects all instances of NLog LogFactory:
```csharp
NLog.Config.ConfigurationItemFactory.Default.CreateInstance = (type) => System.Activator.CreateInstance(type);
```
Then NLog LogFactory now has an isolated ServiceRepository, where one can register own custom interface-implementations or
external `System.IServiceProvider`:
```csharp
NLog.LogManager.Setup().SetupExtensions(ext => ext.RegisterSingletonService<IMyInterface>(singletonInstance));
NLog.LogManager.Setup().SetupExtensions(ext => ext.RegisterServiceProvider((IServiceProvider)externalDependencyInjection));
```
External dependencies can now be resolved during Target- or Layout-initialization like this:
```csharp
protected override void InitializeTarget()
{
    var wantedDependency = ResolveService<IMyInterface>();
}
```
The challenge with dependency injection is that logging is expected to be working and running before dependency injection has been configured.
NLog tries to handle this by making `ResolveService()` throw exception when wanted dependency is not yet available.
When `InitializeTarget()` fails because of unresolved dependency, then NLog will automatically retry when expected type
becomes available in the NLog ServiceRepository. This means a simple console-target will always work, and targets with
dependency injection requirement will be lazy initialized with retry if necessary.

Another problem with logging and dependency injection is that logging is one of the lowest layers of the application.
Having the logging-layer making calls into the dependency-injection-layer can cause issue like call-recursion with stackoverflow
or deadlocks. Both issues are extremely annoying to debug and diagnose, so one should be very careful to ensure interfaces
are implemented with singleton-lifetime.

### Multiple type-aliases can be defined for use in NLog configuration
It's now possible to add multiple type-aliases for your targets, layouts, layout renderers and conditions.

For example, this is now allowed:

```c#
[Target("MyTarget")]
[Target("MyFancyTarget")]
public class MyTarget { ... }
```

The following attributes can now be defined multiple times for a class:

- `[Target]`
- `[Layout]`
- `[LayoutRenderer]`
- `[Filter]`

The following aliases are added in NLog: 
- The Mail Target has now the type-aliases Email, SMTP and SMTP-Client
- The Trace Target has now the type-alias TraceSystem
- `${Event-properties}` has now the type-alias `${Event-property}`
- `${logger}` has now the type-alias `${loggername}`

All type-aliases are also listed and searchable on https://nlog-project.org/config/

### Parsing of type-alias will now ignore dashes (-)
Dashes in type-alias names in targets, layout renderers, layouts, filters are ignored. For example: `${loggername}` could be written als `${logger-name}`, and ColoredConsole could be written als Colored-Console.

Reason: It's hard to maintain consistency between the different type-aliases. There where also some inconsistencies already. 
Also, when registering custom extensions, it is confusing to have type-aliases with only dashes as difference. For example: ${activityid} and ${activity-id}

## Breaking Changes

### Strong Version Changed
The major version has been bumped for the strong-version to v5.0.0.0 (from v4.0.0.0).

* **Impact:** .NET framework applications will have to be recompiled to use NLog 5.0.

* **Reason:** Major version must be bumped to protect application from runtime compile errors.

* **Workaround:** Upgrade to .NET Core where assembly strong version doesn't have the same meaning.
   Alternative one can make use of [binding-redirects](https://docs.microsoft.com/dotnet/framework/configure-apps/redirect-assembly-versions),
   as the NLog 5 API includes the NLog 4 API except for methods that has been deprecated for a long time.

### Obsolete methods have been removed
Lots of obsolete methods and properties in the NLog API has now been removed.

* **Impact:** Applications that depends on the deprecated NLog API will fail to compile and run.

* **Reason:** Removing obsolete logic reduces code complexity and code maintenance.

* **Workaround:** If unable to built with NLog 5 directly, then downgrade to latest NLog v4 and
  follow the guidelines from the obsolete-attribute. When having fixed the obsolete warnings then update to NLog 5.

### LoggingRule Filters DefaultAction changed to FilterResult.Ignore
Changed from `Neutral` default value:
```xml
<logger name="*" minLevel="Debug" writo="target">
    <filters defaultAction="Neutral">
        <when condition="'${exception:format=shorttype}' != ''" action="Log" />
    </filters>
</logger>
```
To `Ignore` as default value:
```xml
<logger name="*" minLevel="Debug" writo="target">
    <filters defaultAction="Ignore">
        <when condition="'${exception:format=shorttype}' != ''" action="Log" />
    </filters>
</logger>
```

* **Impact:** This means NO output, if using dynamic filters and not already using `defaulAction="Ignore"`.

* **Reason:** Better user experience for new users when trying to use filters, as it will have effect right away.

* **Workaround:** Explicit assign `defaultAction="Log"` on the `<filters>`-element, or rewrite conditions to use `action="Log"`.

### NLog.Extensions.Logging without any filter
NLog LoggingProvider no longer follows the Microsoft Logger filtering configuration.

* **Impact:** This means LOTS of unwanted output, if have been depending on Microsoft Logger filtering in appsettings.json.

* **Reason:** It is confusing to have two seperate systems for filtering logging output. New users might
think NLog is not working correctly after having configured NLog LoggingRules, because Microsoft LoggerFactory filters are interfering.

* **Workaround:** Explicit specify `RemoveLoggerFactoryFilter = false` for NLogProviderOptions when calling `UseNLog()` to enable old behavior,
where Microsoft LoggerFactory filters specified in appsetting.json also applies to NLog.

Alternatively the new `finalMinLevel`-option can be used to replicate the behavior of Microsoft Logging Filters:
```xml
<rules>
    <logger name="System.*" finalMinLevel="Warn" />
    <logger name="Microsoft.*" finalMinLevel="Warn" />
    <logger name="Microsoft.Hosting.Lifetime*" finalMinLevel="Info" />
    <logger name="*" minLevel="Debug" writeTo="console" />
</rules>
```

Notice it is also possible to have [NLog Configuration in appsetting.json](https://github.com/NLog/NLog.Extensions.Logging/wiki/NLog-configuration-with-appsettings.json).

### NLog.Extensions.Logging changes capture of EventId
NLog LoggingProvider will no longer capture `EventId`-struct + `EventId_Id`-number + `EventId_Name`, instead it will 
by default capture the properties `EventId` (integer) and `EventName` (string).

* **Impact:** `EventId_Id` and `EventId_Name` are no longer included by default. They have been replaced with the properties `EventId` and `EventName`.

* **Reason:** Avoid the overhead from capturing and boxing the EventId-struct. And provide more human readable names.

* **Workaround:** Adjust to the new property-names, or explicity specify NLogProviderOptions `CaptureEventId = Legacy` to enable old behavior.

### NLog Extensions assemblies will not load automatically

* **Impact:** NLog will no longer automatic scan and load assemblies where their filename starts with NLog.
  This means one must remember to explicitly add extensions to `<extensions>`-sections. NLog will now fail
  to load unrecognized targets and layouts, that depends on unreferenced external NLog extension assemblies.

* **Reason:** NLog initialization becomes slower when having to scan for assembly files. When using NLog in
  the cloud then the overhead from logging should be minimal. The automatic scanning also often failed on .NET Core
  platforms because it would not see assemblies coming from nuget-packages.

* **Workaround:** NLog extensions assemblies can be specified explicitly in the NLog.config:
  ```xml
  <nlog>
    <extensions>
      <add assembly="NLog.MyAssembly" /> 
    </extensions>
  </nlog>
  ```
  NLog 5.0 makes it possible to just specify the extension assembly-name directly in the type-alias:
  ```xml
    <nlog>
    <targets>
        <target type="MyTarget, NLog.MyAssembly" name="hello" />
    </targets>
  </nlog>
  ```
  NLog provides a method to force automatic loading of NLog extensions, before loading the NLog.config:
  ```c#
  NLog.LogManager.Setup().SetupExtensions(ext => ext.AutoLoadExtensions());
  ```
  Alternative one can update the NLog.config with the option `AutoLoadExtensions="true"`:
  ```xml
  <nlog autoloadExtensions="true">
  </nlog>
  ```

### NLog Targets extracted into their own nuget-packages
The following NLog targets has been extracted from the NLog-nuget-package to their own isolated nuget-packages:
- DatabaseTarget - [NLog.Database](https://www.nuget.org/packages/NLog.Database)-package
- OutputDebugStringTarget - [NLog.OutputDebugString](https://www.nuget.org/packages/NLog.OutputDebugString)-package
    - [DebugSystem](https://github.com/NLog/NLog/wiki/DebugSystem-target)-target is available for `System.Diagnostics.Debug`-output.
- PerformanceCounterTarget - [NLog.PerformanceCounter](https://www.nuget.org/packages/NLog.PerformanceCounter)-package
- ImpersonatingTargetWrapper - [NLog.WindowsIdentity](https://www.nuget.org/packages/NLog.WindowsIdentity)-package
- LogReceiverWebServiceTarget - [NLog.Wcf](https://www.nuget.org/packages/NLog.Wcf)-package

The following NLog layoutrenderers has been extracted from the NLog-nuget-package to their own isolated nuget-packages:
- PerformanceCounterLayoutRenderer - [NLog.PerformanceCounter](https://www.nuget.org/packages/NLog.PerformanceCounter)-package
- RegistryLayoutRenderer - [NLog.WindowsRegistry](https://www.nuget.org/packages/NLog.WindowsRegistry)-package
- WindowsIdentityLayoutRenderer - [NLog.WindowsIdentity](https://www.nuget.org/packages/NLog.WindowsIdentity)-package
- QueryPerformanceCounterLayoutRenderer - Dropped into the ocean of dead code.

* **Impact:** The default NLog-nuget-package will no longer provide the same number of targets and layoutrenderers.
  This means existing applications will have to be adjusted to reference the necessary nuget-packages and update
  their NLog.config to load the now external NLog extensions.

* **Reason:** The default NLog-nuget-package introduces a lot of dependencies for small console applications that just wants to
  write to the console. The DatabaseTarget also triggered alerts in static code analysis tools, since it allows execution
  of arbitary SQL statements, thus NLog was falsely highlighted as a security risk.

* **Workaround:** Consider creating a meta nuget-package with your favorite collection of NLog-nuget-packages,
  and change your projects to depend on this.

### Deprecated NLog.Extended nuget-package
NLog.Extended nuget-package will no longer be released. The MSMQ-target has been extracted into its own nuget-package.

* **Impact:** NLog.Extended-nuget-package will no longer be compatible with latest NLog and should be removed.

* **Reason:** NLog.Extended was intended as a swiss-army-knife of exotic targets and layouts. But it was discovered
  that it introduced too many unwanted dependencies when just wanting to use a single target.

* **Workaround:** Change from NLog.Extended nuget-package to the specific NLog-nuget-package needed.

### Deprecated NLog.Config nuget-package
NLog.Config nuget-package will no longer be released.

* **Impact:** NLog.Config-nuget-package will no longer be compatible with latest NLog and should be removed.

* **Reason:** NLog.Config-nuget-package stopped working properly when Microsoft refactored the nuget-package-system to
  support `<packagereference>`. Microsoft disabled the ability for a nuget-package to inject a default NLog.config into the
  project directory when one didn't exist. Instead it became overwrite always, so when deploying an application with dependency
  on NLog.config-nuget-package, then it would unexpectedly reset the NLog.config.

* **Workaround:** Manually create the NLog.config file and add it to the application-project. Manually add NLog.Schema-package
  for intellisense in NLog.config.

### Xamarin, Windows Phone and Silverlight platforms have been removed
NLog have now removed Xamarin platform specific builds for iOS and Android. Instead they will rely on the .NET Standard-builds.
Windows Phone and Silverlight has also been removed together with the Xamarin-platforms as they shared a lot of the same
platform restrictions and are now obsolete.

* **Impact:** Xamarin platforms will no longer have special restrictions, but will have all the features from the .NET Standard-build.
  This also means it can access features like global mutex in the operating system (Now disabled by default), that will cause the
  application to fail on the restricted mobile platforms. This also means the Android platform will no longer automatically load
  NLog.config from assets-folder. This also mean that NLog 5 cannot be used in LOB Silverlight or Windows Phone applications.

* **Reason:** The Xamarin platforms have now embraced the .NET Standard-API, so it is no longer necessary with platform specific builds.
  Removing platform specific logic reduces code complexity and code maintenance. Windows Phone and Silverlight are no longer supported
  by Microsoft and have reached end of the line.

* **Workaround:** Because all features in the .NET Standard build are not supported on all platforms, then one should ensure not to
  explicitly enable FileTarget ConcurrentWrites-option as it will enable use of operating system global mutex,
  which is not available on Xamarin Mobile platforms and will make the application fail.

  Instead of using assets-folder on Android, then change to Embedded Resource, and load NLog-config from application-assembly (Works for both iOS and Android):
  ```csharp
  NLog.LogManager.Setup().LoadConfigurationFromAssemblyResource(typeof(App).GetTypeInfo().Assembly);
  ```

### .NET Framework v4.0 platform replaced by .NET Framework v3.5
NLog have removed direct support for .NET Framework v4.0, instead it will fallback to .NET Framework v3.5.

* **Impact:** There is very little difference between NLog for .NET Framework v3.5 and NLog for .NET Framework v4.

* **Reason:** Removing platforms that are no longer supported by Microsoft reduces code complexity and code maintenance.
  There is suddenly also one less platform to execute continuous integration builds with unit-tests.

* **Workaround:** Application rebuild will automatically fallback to NLog for .NET Framework 3.5 that will work just fine.
  Alternative update the application from .NET Framework v4.0 to something newer.

### Automatic loading of NLog.config now first check for exe.nlog
NLog will now first check for `Application.exe.nlog` at startup, before using `NLog.config`

* **Impact:** `NLog.config` will be ignored if application specific `.exe.nlog`-file is found.

* **Reason:** Fixing bug that was introduced long time ago, but required major version bump to revert the behavior.

* **Workaround:** Decide on whether to use `Application.exe.nlog` or `NLog.config` and remove the other.

### NLog Configuration will have KeepVariablesOnReload enabled by default
NLog Configuration Variables assigned at runtime will now automatically survive when using `autoReload="true"`.

* **Impact:** NLog Configuration Variables assigned from API will no longer be reset on reload `NLog.config`.

* **Reason:** Better user experience when using `autoReload="true"` and updating NLog Configuration Variables at runtime.

* **Workaround:** Explictly configure `KeepVariablesOnReload="false"` in NLog.config

### Layout and LayoutRenderer are now threadsafe by default
NLog now always expects Layout and LayoutRenderer to be threadsafe, and will no longer check the `[ThreadSafe]`-class-attribute.

* **Impact:** NLog Targets will no longer attempt to protect against 3rd Party Layout-logic that might not be threadsafe.

* **Reason:** The `[ThreadSafe]`-class-attribute was intended as a temporary workaround, to avoid breaking stuff with NLog ver. 4.5.3
  Having to apply special class-attributes to get the expected performance is not very user-friendly.

* **Workaround:** Explicitly configure the Target-option `LayoutWithLock="true"` if target is using 3rd Party Layout-logic
  that is not threadsafe.

### Default Layout for NLog Targets has been updated
Changed from this default value:
```
${longdate}|${level:uppercase=true}|${logger}|${message}
```
To this new default value:
```
${longdate}|${level:uppercase=true}|${logger}|${message:withexception=true}
```

* **Impact:** NLog targets that have not explicit assigned default layout will now also include exception-details.

* **Reason:** Better user experience when using default configuration. When using NLog to diagnose problems then
  exception information is often important.

* **Workaround:** Explicit assign the Layout-property on the target if other output is wanted.

### Default Format for NLog Exception layoutrenderer has been updated
Change from this default value:
```
${exception:format=message}
```
To this new default value:
```
${exception:format=tostring,data}
```

* **Impact:** Locations where `${exception}` is used without specifying format will now perform `Exception.ToString()`, 
  instead of just rendering Exception.Message

* **Reason:** Better user experience when using default configuration. When using NLog to diagnose problems then
  all exception information is usually important.

* **Workaround:** Explicit specify `${exception:format=message}` to only get the `Exception.Message`.

### NLog InternalLogger will not initialize itself from app.config or environment variables

* **Impact:** NLog InternalLogger will no longer activate itself based on appsettings or environment variables.

* **Reason:** NLog initialization becomes slower when having to check for environment variables or app.config.
  When using NLog in the cloud then overhead from logging should be minimal.

* **Workaround:** NLog InternalLogger can be enabled from NLog.config as always:
  ```xml
  <nlog internalLogToConsole="true" internalLogLevel="Debug">
  </nlog>
  ```
  NLog InternalLogger can be enabled from code as always:
  ```c#
  NLog.Common.InternalLogger.LogToConsole = true;
  NLog.Common.InternalLogger.LogLevel = LogLevel.Debug;
  ```
  NLog InternalLogger can be initialized from environment-variables from code:
  ```c#
  NLog.LogManager.Setup().SetupInternalLogger(log => log.SetupFromEnvironmentVariables());
  ```

### Removed obsolete method Target.Write(AsyncLogEventInfo[]) and OptimizeBufferReuse is always true

* **Impact:** NLog extensions targets that depends on batch writing LogEvents using the method `Write(AsyncLogEventInfo[] logEvent)`
  will no longer work. The `OptimizeBufferReuse` performance optimization will now always be enabled for all NLog extensions targets.
  Custom NLog Targets that uses `Target.RenderLogEvent()` instead of `Layout.Render()` will experience a performance boost.

* **Reason:** NLog 4.4.2 introduced the ability to reuse the same array-buffer to reduce memory allocation along with better performance for FileTarget.
  NLog 4.5 activated the optimization for all other targets, as it had proven itself stable. NLog 5.0 now removes the ability
  to fallback to legacy mode reduces code complexity and code maintenance.

* **Workaround:** NLog extensions target that depends on the removed method `Target.Write(AsyncLogEventInfo[])` should instead override
  this method: `Target.Write(IList<AsyncLogEventInfo>)`

### ScopeContext changes MappedDiagnosticContext (MDC) to use AsyncLocal
NLog ScopeContext is a reimplementation of MappedDiagnosticContext (MDC) and MappedDiagnosticLogicalContext (MDLC), that reduces
the overhead from capturing context-state. NLog no longer creates a mapped-dictionary upfront, but just stores the
context-state on an async stack, until actual logging requires scope-property lookup.

* **Impact:** NLog MappedDiagnosticContext (MDC) will change from [AllocateDataSlot](https://docs.microsoft.com/en-us/dotnet/api/system.threading.thread.allocatedataslot)
  to [AsyncLocal](https://docs.microsoft.com/en-us/dotnet/api/system.threading.asynclocal-1) when using .NET Core or .NET Framework v4.6.
  When using older platforms like .NET Framework v4.5 or v3.5 then it will change to [CallContext](https://docs.microsoft.com/en-us/dotnet/api/system.runtime.remoting.messaging.callcontext).
  NLog MappedDiagnosticLogicalContext (MDLC) will change from [CallContext](https://docs.microsoft.com/en-us/dotnet/api/system.runtime.remoting.messaging.callcontext)
  to [AsyncLocal](https://docs.microsoft.com/en-us/dotnet/api/system.threading.asynclocal-1) when using .NET Framework v4.6 just like on .NET Core.

* **Reason:** NLog MappedDiagnosticContext (MDC) was implemented to capture context-state and correlate a series of logging events.
  MappedDiagnosticLogicalContext (MDLC) extended the MDC feature to also support async Task-state. It has been a long standing wish
  to merge MDC and MDLC into one, because having both caused confusion. This advanced logging feature was not used by many,
  and there was an additional overhead from creating the context-state, especially when no relevant logging between context state changes.
  The NLog Logging Provider for Microsoft Extension Logging (MEL) [ILogger.BeginScope](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.ilogger.beginscope)
  used the NLog MDLC for storing context-state, and so the overhead from handling context-state was now hitting lots of users.
  The expected behavior that logging had minimal overhead, was no longer true when using MDC / MLDC.

* **Workaround:** MappedDiagnosticContext (MDC) and MappedDiagnosticLogicalContext (MDLC) still exists with all their API-methods,
  but they have been redirected to the new NLog ScopeContext. Many of the old API-methods introduces a huge overhead compared to using
  the NLog ScopeContext directly. NLog Logger object now also provides the methods `Logger.PushScopeProperty` and `Logger.PushScopeNested`
  for easier availability.

### MappedDiagnosticContext (MDC), MappedDiagnosticLogicalContext (MDLC), GlobalDiagnosticContext (GDC) now case-insensitive
NLog have changed the default dictionary comparer to StringComparer.OrdinalIgnoreCase.

* **Impact:** Property lookup with key `RequestId` will now match item-key `requestid`. This also means it will also overwrite independent
  of casing. Notice that LogEventInfo.Properties is still case-sensitive, but `${event-properties}` will now ignore casing on property lookup by default.

* **Reason:** Making it easier to lookup a single property without having to ensure all code-locations are using exact same casing.

* **Workaround:** Instead just add a prefix (or suffix) to make it easier to distinguish the properties, when needing to store
  two different `requestid` values.

### FileTarget KeepFileOpen = true by default
FileTarget will now keep file handles open by default, and will not release file handle after each write.

* **Impact:** External applications that tries to acquire exclusive file-locks for the log-file will now fail,
  instead of possibly blocking the application. Ex. `File.OpenText` or `File.ReadAllText` will now fail with
  `System.IO.IOException: The process cannot access the file`.

* **Reason:** Avoid unexpected behavior caused by external applications (ex. malware scanner) suddenly taking over file handles,
  thus blocking the application from logging so log-events are lost. Keeping the file open also gives much
  better performance, than to open/close the file handle for each write.

* **Workaround:** Explicitly specify `KeepFileOpen=false` to enforce old behavior similar to log4net/log4j MinimalLock.
  But if the problem comes from external application no longer being able to acquire exclusive file-lock, then it is better
  to fix the external application to use `FileShare.ReadWrite`.

### FileTarget ConcurrentWrites = false by default
FileTarget will now by default not attempt to use operating system global mutexes for synchronized file-access between multiple applications on the same machine.

* **Impact:** If multiple application instances on the same machine uses the same NLog FileTarget file-path with KeepFileOpen=true,
  then it will lead to failure if not having explictly configured ConcurrentWrites=true. This means IIS applications where multiple
  AppDomain application instances can be used, should check that ConcurrentWrites=true is explictly enabled. If using
  KeepFileOpen=false, then it will use the operating system file-locks for synchronization, and then ConcurrentWrites=true
  is only needed if making use of static-filename-archive-logic.

* **Reason:** NLog FileTarget was initially built for Desktop applications, Windows Services and IIS running on the Windows platform,
  where global mutex is available even for restricted users. This is not the case for Xamarin platforms and UWP, where use of
  global mutex will cause application failure. Because Xamarin platforms now use .NET Standard-build by default, then this "dangerous" feature
  has been disabled by default for better compatibility. ConcurrentWrites=true also introduces a performance overhead, which is unnecessary for most
  applications.

* **Workaround:** For best performance one should use FileTarget KeepFileOpen=true and ensure each application-instance doesn't share filepath
  with other application instances. One should only configure FileTarget ConcurrentWrites=true when absolutely certain that
  multiple application instances must write to the same file-path, which is the case for application running on IIS.

### FileTarget Encoding default value changed to UTF8
Instead of using Encoding.Default then FileTarget will now use Encoding.UTF8

* **Impact:** FileTarget will now by default write using UTF8 encoding.

* **Reason:** Better user experience when using JsonLayout together with FileTarget. Also make it easier
  to read files coming from different locations and environments like the cloud.

* **Workaround:** Explicit assign `Encoding` on the FileTarget.

### FileTarget will include BOM by default for UTF16 and UTF32 encoding
When the encoding requires a BOM preamble for proper parsing, then FileTarget will now include it by default.

* **Impact:** When not having configured FileTarget WriteBom-option, then it will automatically become
  true for UTF16 and UTF32 encoding.

* **Reason:** Better user experience when using default configuration. Most file viewers will fail to handle these file encodings without correct BOM.

* **Workaround:** Explicit assign `WriteBom` on the FileTarget.

### NetworkTarget will Discard by default on overflow
NetworkTarget behaves asynchronous and never had any throttle of network requests pending.
With `KeepConnection = true` then network requests would be put in a pending-queue without
any upper limit. With `KeepConnection=false` then network connections would be created
without any upper limit.

This could cause the application to experience out-of-memory issues, which is not wanted
from the logging framework by default. For `KeepConnection = true` there has been
introduced a new setting `OnQueueOverflow` with default value Discard. For `KeepConnection = false`
the existing setting `OnConnectionOverflow` is now by default Discard.

* **Impact:** LogEvents might be lost during high loads, where network cannot keep up.

* **Reason:** Better user experience by not taking the application down during high loads.

* **Workaround:** Explicit assign `OnQueueOverflow` and `OnConnectionOverflow` to use `Grow` or `Block`.

### JsonLayout MaxRecursionLimit default value changed to 1
JsonLayout will by default perform reflection of property-values and output direct object-properties.

* **Impact:** When enabling `IncludeEventProperties` then it will automatically output first level object-properties.

* **Reason:** Better user experience when using default configuration. When using JSON for structured logging,
  then one expects to see the object-properties.

* **Workaround:** Explicit assign `MaxRecursionLimit="0"` on the JsonLayout.

### JsonLayout EscapeForwardSlash default value changed to false
JsonLayout will now by default not escape URL-values when rendering JSON. 

* **Impact:** Forward slashes `/` will no longer be escaped by default

* **Reason:** Better user experience as it aligns the NLog JSON Serializer with the default behavior of others.

* **Workaround:** Explicit assign `EscapeForwardSlash="true"` on the JsonLayout.

### JsonLayout always includes decimal point for floating-point types
JsonLayout will now by default add decimal point for properties of the type `decimal`, `double` and `float`.

* **Impact:** Instead of writing double default value as `0` then it will become `0.0`

* **Reason:** Better user experience as it aligns the NLog JSON Serializer with JSON.NET, and many JSON-parsers (ElasticSearch)
  deduces the datatype from the format of the property-values.

* **Workaround:** Stop using decimal types for properties where you don't want decimal point in JSON.

### CallSite-renderer will automatically clean async callstacks
`${callsite}` will now enable CleanNamesOfAnonymousDelegates and CleanNamesOfAsyncContinuations by default.

* **Impact:** `${callsite}` rendering will now attempt to extract and log the actual method, instead of the async-delegate.

* **Reason:** Better user experience when using default configuration, and doing logging in async-methods.

* **Workaround:** Explicit assign `CleanNamesOfAnonymousDelegates` and `CleanNamesOfAsyncContinuations` when using `${callsite}`.

### The Simplelayout.ToString() has been changed
The ToString won't add aditional quotes.

For example:

```
Layout l = "a";
l.ToString();
```

In NLog 4 this results in `'a'` and in NLog 5 this results in `a`.

* **Impact:** There are maybe changes needed when parsing the ToString value of a `Layout`

* **Reason:** The additional quotes won't has any value, it could be confusing and also it's a good practive that the ToString value could be parsed by the Layout again. 

* **Workaround:** Add quotes manually when needed. 


## Many other improvements

For a full list of all the enhancements and performance improvements: [NLog 5.0 PullRequests](https://github.com/NLog/NLog/pulls?q=is%3Apr+is%3Amerged+milestone:%225.0%20%28new%29%22)
