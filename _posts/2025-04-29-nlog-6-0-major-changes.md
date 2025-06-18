---
layout: post
title: NLog 6.0 - List of major changes
---

NLog 6.0 is a major version release, and introduces breaking changes to support AOT-builds by splitting into multiple nuget packages.

## Major changes

### NLog supports AOT

NLog v6 now supports Ahead-of-Time (AOT)-builds without warnings, and optimizes the support for build-trimming that was introduced with [NLog v5.2.2](https://nlog-project.org/2023/05/30/nlog-5-2-trim-warnings.html).

NLog has traditionally used reflection for dynamic discovery of target output requirements.
But reflection does not always work well with build-trimming, and before NLog marked itself to be completely excluded from any trimming.

NLog includes many features, and each feature often introduces additional dependencies on the .NET library.
This can lead to overhead for AOT builds, as it must include and compile all the relevant source code.

NLog v6 attempts to reduce its footprint by extracting several features into separate nuget-packages:

- [NLog.Targets.AtomicFile](https://www.nuget.org/packages/NLog.Targets.AtomicFile) - ConcurrentWrites using atomic file-append from operating system API.
- [NLog.Targets.ConcurrentFile](https://www.nuget.org/packages/NLog.Targets.ConcurrentFile) - ConcurrentWrites using global mutex from operating system API.
- [NLog.Targets.GZipFile](https://www.nuget.org/packages/NLog.Targets.GZipFile) - EnableArchiveFileCompression using GZipStream for writing GZip compressed log-files.
- [NLog.Targets.Mail](https://www.nuget.org/packages/NLog.Targets.Mail) - Depends on System.Net.Mail.SmtpClient.
- [NLog.Targets.Network](https://www.nuget.org/packages/NLog.Targets.Network) - Depends on TCP and UDP Network Socket, and adds support for Syslog and Graylog.
- [NLog.Targets.Trace](https://www.nuget.org/packages/NLog.Targets.Trace) - Depends on System.Diagnostics.TraceListener.
- [NLog.Targets.WebService](https://www.nuget.org/packages/NLog.Targets.WebService) - Depends on System.Net.Http.HttpClient.
- [NLog.RegEx](https://www.nuget.org/packages/NLog.RegEx) - Depends on System.Text.RegularExpressions which is a huge dependency for a logging library.

NLog v6 also no longer depends on `System.Xml.XmlReader`, but now includes its own basic XmlParser for loading `NLog.config` files.

NLog v6 still introduces an overhead when compared with just using `Console.WriteLine`,
but now reduced to 5 MByte in comparison to 14 MBytes with NLog v5. 

If the `NLog.config`-file had to be explicitly loaded, then the AOT-build could trim much more,
since right now the AOT-build cannot predict what types will be required by the `NLog.config`-file.
But disabling automatic loading of the `NLog.config`-file is a huge breaking change,
and would hurt lots of existing applications.

### NLog FileTarget and ArchiveSuffixFormat

NLog FileTarget has received a major rewrite to simplify the archive-logic. NLog FileTarget
no longer uses `File.Move` by default, but instead rolls to the next filename.
This is to prevent file-locking issues with other background-applications, or if the log-file is
held open by file-viewer.

The new archive-logic:

- LogFile.txt (Oldest file)
- LogFile_1.txt
- LogFile_2.txt (Newest file)

The old static archive-logic:

- LogFile.txt (Newest file)
- LogFile.1.txt (Oldest file)
- LogFile.2.txt

NLog FileTarget still support static archive logic with `File.Move`, but it must be explictly activated
by specifying `ArchiveFileName`. If not using `ArchiveFileName` but want to revert to old archive-logic
with `File.Move`, then just assign `ArchiveFileName="..."` to have the same value as `FileName="..."`.

NLog FileTarget no longer has the following archive-options:

- EnableArchiveFileCompression - Removed because of dependency on compression-libraries.
- ArchiveOldFileOnStartupAboveSize - Instead use ArchiveAboveSize / ArchiveOldFileOnStartup.
- ArchiveDateFormat - Marked as obsolete. Instead use new ArchiveSuffixFormat
- ArchiveNumbering - Marked as obsolete. Instead use new ArchiveSuffixFormat (Rolling is unsupported).
- ArchiveFileKind - Removed because it is now implicit.
- FileNameKind - Removed because it is now implicit.

The `ArchiveSuffixFormat`-option has been introduced to replace `{#}`, and instead of specifying 
`archiveFilename="LogFile_{##}.txt"` then one should specify `archiveFilename="LogFile.txt"` with `archiveSuffixFormat="_{1:yyyyMMdd}_{0:00}"`.
The `ArchiveSuffixFormat`-option specifies the filename-suffix to apply, when the archive-logic is rolling to the next file.
To make the suffix as predictable as possible to help simplify the file-wildcard-logic, then it has no NLog Layout-logic
and is just a simple `string.Format` with support for these place-holders:
- `{0}` - The archive sequence-number. Supports format option `{0:000}`.
- `{1}` - The archive created-datetime. Supports format option `{1:yyyyMMdd}` (Only works when also specifying `archiveFileName="..."`).

Old Configuration Example:
```xml
<target xsi:type="file" name="logfile"
        fileName="logfile.txt"
        archiveFilename="logfile_{#}.txt"
        archiveNumbering="Date"
        archiveEvery="Day"
        archiveDateFormat="yyyyMMdd" />
```
New Configuration Example:
```xml
<target xsi:type="file" name="logfile"
        fileName="logfile.txt"
        archiveFilename="logfile.txt"
        archiveEvery="Day"
        archiveSuffixFormat="_{1:yyyyMMdd}" />
```

Alternative options for replacing `EnableArchiveFileCompression = true`:
- Activate NTFS compression for the logging-folder.
- Setup cron-job / scheduled-task that performs ZIP-compression and cleanup of the logging-folder.
- Implement background task in the application, which monitors the logging-folder and performs ZIP-compression and cleanup.
- Use the new nuget-package [NLog.Targets.GZipFile](https://www.nuget.org/packages/NLog.Targets.GZipFile) where GZipFileTarget writes directly to a compressed log-file using `GZipStream`.

### NLog FileTarget without ConcurrentWrites

NLog FileTarget no longer supports `ConcurrentWrites`-option, where multiple processes running
on the same machine can write to the same file with help from global operating-system-mutex.

This feature was removed to simplify the NLog FileTarget, and not rely on features that was
only supported on certain operating system platforms. Still there is support for `KeepFileOpen` = true / false.

NLog FileTarget no longer has the following options:

- ConcurrentWrites - Removed because of dependency on global mutex and exotic file-locks.
- CleanupFileName - Removed because it is now implicit.
- FileAttributes - Removed because of dependency on Windows-only API.
- ForceManaged - Removed because of dependency on Windows-only API.
- ConcurrentWriteAttempts - Removed together with ConcurrentWrites.
- ConcurrentWriteAttemptDelay - Removed together with ConcurrentWrites.
- ForceMutexConcurrentWrites - Removed together with ConcurrentWrites.
- NetworkWrites - Replaced by KeepFileOpen.

Alternative options for replacing `ConcurrentWrites = true`:
- Use the new nuget-package [NLog.Targets.AtomicFile](https://www.nuget.org/packages/NLog.Targets.AtomicFile) where AtomicFileTarget uses atomic file-appends and supports Windows / Linux with NET8.
- Change to use `KeepFileOpen = false` where file is opened / closed when writing LogEvents. For better performance then consider to also use `<targets async="true">`.

There is also a new [NLog.Targets.ConcurrentFile](https://www.nuget.org/packages/NLog.Targets.ConcurrentFile)-nuget-package, which is
the original NLog FileTarget with all its features and complexity. It supports ConcurrentWrites using global mutex,
but the goal is that [NLog.Targets.ConcurrentFile](https://www.nuget.org/packages/NLog.Targets.ConcurrentFile)-nuget-package will become legacy,
but it might be helpful when upgrading to NLog v6.

### NLog AtomicFileTarget without mutex

New AtomicFileTarget has been introduced with [NLog.Targets.AtomicFile](https://www.nuget.org/packages/NLog.Targets.AtomicFile),
that supports atomic file-append with help from the operating system, and supports both Windows and Linux (with help from Mono Posix) for NET8 (and newer).

Extends the standard FileTarget and adds support for `ConcurrentWrites = true`, but without using global mutex.

Linux users must use `dotnet publish` with `--configuration release --runtime linux-x64` to ensure
correct publish of the `Mono.Posix.NETStandard`-nuget-package dependency.

### NLog GZipFileTarget with GZipStream

New GZipFileTarget has been introduced with [NLog.Targets.GZipFile](https://www.nuget.org/packages/NLog.Targets.GZipFile) nuget-package,
that writes directly to a compressed log-file using GZipStream.

Extends the standard FileTarget and adds support for `EnableArchiveFileCompression = true`, but only supports
GZip file compression.

The GZip File compression doesn't allow appending to existing GZip Archive without rewriting the entire GZip Archive.
Therefore these options are set by default `KeepFileOpen = true` and `ArchiveOldFileOnStartup = true`.

The GZip File compression has better handling of large log-files compared to the old `EnableArchiveFileCompression = true`,
where the old ZIP compression would stall the file-logging until completed.

### NLog DatabaseTarget supports AOT

NLog DatabaseTarget uses by default type-reflection for resolving DbConnection-factory from the `DbProvider`-option.

NLog DatabaseTarget now have a new constructor, where one can specify method-delegate when configuring from code:
```csharp
var databaseTarget = new NLog.Targets.DatabaseTarget(() => new Npgsql.NpgsqlConnection());
NLog.LogManager.Setup().LoadConfiguration(cfg => cfg.ForLogger().WriteTo(databaseTarget));
```

When specifying DbType for database-call-parameters, then NLog DatabaseTarget uses type-reflection to parse and
assign the DbType. NLog `DatabaseParameterInfo` now have a new constructor, where one can specify method-delegate:
```csharp
var databaseParameter = new DatabaseParameterInfo("@context",
    "${all-event-properties}",
    (p) => ((NpgsqlParameter)p).NpgsqlDbType = NpgsqlDbType.VarChar);
databaseTarget.Parameters.Add(databaseParameter);
```

When using these new constructors from the [NLog.Database](https://www.nuget.org/packages/NLog.Database)-nuget-package,
then it will not trigger AOT-build-warnings.

### NLog LogFactory FlushAsync

NLog LogFactory `Flush()` and `Shutdown()` are synchronous API methods, that schedules background worker-threads
to execute NLog Target Flush. This doesn't work well on platforms that simulates worker-threads,
by running everything on main thread.

Instead NLog LogFactory `FlushAsync`-method has been introduced that will support multi-threaded flush.

The NLog LogFactory now also implements `IDisposableAsync` which includes `FlushAsync` before closing. This allows the following:
```
await using var logFactory = NLog.LogManager.Setup().LoadConfigurationFromFile().LogFactory; // Automatic Shutdown()
```

The NLog LogFactory `Dispose()`-method has been changed to skip flush with help from worker-threads,
but will only perform synchronous NLog Target Close.

### NLog API with nullable references
NLog API has been updated to enable nullable, and has been compiled using C# v9 for all target-platforms.

NET3 introduced C# v8 with support for nullable reference types, that allows static analysis to avoid
NullReferenceException (NRE). NET5 introduced C# v9 with improved support for nullable generics.

This will improve the user-experience, when using the NLog API directly instead of NLog configuration files.

### NLog Logger API with ReadOnlySpan
NLog Logger API now supports `params ReadOnlySpan` and can skip `params object[]`-allocation, when many parameters
and LogLevel is not enabled.

NET9 introduced C# v13 that supports `params ReadOnlySpan`, which is now supported by NLog for NetStandard2.1.

NLog extends the optimization to completely skip the `params object[]`-allocation, when using message-templates
and it is not possible to defer the parsing of the message-template on background thread.

### Legacy NLog Logger API reduced priority
NLog Logger API has legacy methods from .NET Framework 1.0 without generics.

NET9 introduced C# v13 that supports `[OverloadResolutionPriority(-1)]` to change priority of methods, when other methods are available.

NLog Logger API will now promote the generic-methods and ReadOnlySpan-methods, instead of the legacy methods.
This will hopefully reduce the friction when finally cleaning up these legacy methods, when not being in use.

### NLog GelfTarget and GelfLayout

The [NLog.Targets.Network](https://www.nuget.org/packages/NLog.Targets.Network) nuget-package also includes support for the Graylog Extended Log Format (GELF).

The `GelfTarget` extends the standard `NetworkTarget` with the new `GelfLayout`.

It depends on the builtin NLog JSON serializer, but follows the 'standard' of prefixing all
custom property-names with underscore `_`.

```xml
<nlog>
  <extensions>
    <add assembly="NLog.Targets.Network" />
  </extensions>
  
  <targets async="true">
    <target xsi:type="Gelf" name="GelfTcp" address="tcp://localhost:12200" newLine="true" lineEnding="Null">
      <GelfField name="ThreadId" layout="${ThreadId}" />
    </target>
  </targets>

  <rules>
    <logger name="*" minlevel="Debug" writeTo="GelfTcp" />
  </rules>
</nlog>
``` 

Available `GelfTarget`-options that can be adjusted:
- GelfHostName
- GelfShortMessage
- GelfFullMessage
- IncludeEventProperties
- IncludeScopeProperties

### NLog SyslogTarget and SyslogLayout

The [NLog.Targets.Network](https://www.nuget.org/packages/NLog.Targets.Network) nuget-package also includes support for the Syslog Output Format.

The `SyslogTarget` extends the standard `NetworkTarget` with the new `SyslogLayout`.

The `SyslogLayout` supports both RFC-3164 (simple) + RFC-5424 (structured) logging output.

```xml
<nlog>
  <extensions>
    <add assembly="NLog.Targets.Network" />
  </extensions>
  
  <targets async="true">
    <target xsi:type="SysLog" name="SyslogTcp" address="tcp://localhost:514">
      <Rfc3164>false</Rfc3164>
      <Rfc5424>true</Rfc5424>
      <StructuredDataParam name="ThreadId" layout="${ThreadId}" />
    </target>
  </targets>

  <rules>
    <logger name="*" minlevel="Debug" writeTo="SyslogTcp" />
  </rules>
</nlog>
``` 

Available `SyslogLayout`-options that can be adjusted:
- SyslogAppName
- SyslogHostName
- SyslogMessage
- SyslogLevel
- SyslogFacility
- StructuredDataId
- IncludeEventProperties

### NLog NetworkTarget with NoDelay = true

The [NLog.Targets.Network](https://www.nuget.org/packages/NLog.Targets.Network) nuget-package includes support for configuring TCP_NODELAY.
The `NetworkTarget` will by default use `NoDelay = true` to turn off delayed ACK,
to avoid delays of 200ms because of nagle-algorithm.

Believe most users will not notice the overhead of additional ACK-packages, but will notice
a delay of 200ms.

### NLog NetworkTarget with SendTimeoutSeconds = 100

The [NLog.Targets.Network](https://www.nuget.org/packages/NLog.Targets.Network) nuget-package changes the default value of TCP SendTimeout
from waiting forever to 100 secs. 

The `NetworkTarget` should now react to the network-cable being unplugged and the TCP send-window being filled.

The `NetworkTarget` should now automatically attempt to reconnect when the endpoint suddenly becomes unresponsive.

### NLog NetworkTarget with SslCertificateFile

The [NLog.Targets.Network](https://www.nuget.org/packages/NLog.Targets.Network) nuget-package introduces the ability to specify custom SSL certificate from file.

The `NetworkTarget` now recognizes these new settings:
 - `Layout SslCertificateFile`
 - `Layout SslCertificatePassword`

The `NetworkTarget` can now perform SSL handshake with custom SSL certificate from file, without needing to register the certificate in the global operating-system cache.

### NLog.Schema for more intellisense

The [NLog.Schema](https://www.nuget.org/packages/NLog.Schema/) nuget-package now includes copy of NLog.xsd XML schema file to local project folder.

The NLog.Schema-nuget-package has been updated to also include Intellisense for NLog Targets / Layouts outside the default NLog-nuget-package.

When adding the NLog.Schema-nuget-package to the application-project that includes `NLog.config` XML-file, then Intellisense will work with this:
```xml
<nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.nlog-project.org/schemas/NLog.xsd NLog.xsd">
  <!-- configuration goes here --> 
</nlog>
```

Alternative one can enable "Automatically download DTDs and schemas" (Visual Studio Options), then Intellisense works with using direct URL:
```xml
<nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.nlog-project.org/schemas/NLog.xsd http://www.nlog-project.org/schemas/NLog.xsd">
  <!-- configuration goes here --> 
</nlog>
```

Notice Intellisense will only work in Visual Studio when using `xsi:type="..."`:
```xml
<target xsi:type="TypeName"/>
```
And not:
```xml
<target type="TypeName"/>
```

## Breaking changes

### Removed legacy Target-Frameworks
NetStandard 1.3 and NetStandard 1.5 has now been removed, since less relevant as most have moved to NetStandard 2.0 (or newer).

Removes platform support for:

- NET CoreApp 1.0 + 1.1
- UAP + UAP10.0 (UWP ver. 1)
- Tizen30

Descided to keep support for NET35 + NET45, since there are many nuget-packages with NLog Targets, that still depend on NET45.

### NLog Structured Message formatting without quotes

NLog v4.5 introduced support for message-templates, where it followed the Serilog approach by adding quotes around string-values:
```csharp
Logger.Info("Hello {World}", "Earth"); // Outputs Hello "Earth" with NLog v4.5
```

Microsoft Extension Logging decided not to implement that behavior, and now NLog also changes to not using quotes by default. Thus avoiding surprises when using NLog Logger directly instead as LoggingProvider for Microsoft Extension Logging.

To apply string-quotes for a single value:
```csharp
Logger.Info("Hello {@World}", "Earth"); // Outputs Hello "Earth" with NLog v6
```

It is possible to globally revert to old behavior:
```csharp
LogManager.Setup().SetupSerialization(s => s.RegisterValueFormatterWithStringQuotes());
```

### NLog Console without WriteLine
The Console for an application is usually a singleton, and there is an overhead for every write-operation.
The normal work-around is to send output to a queue, and let a background thread do the actual Console writing.
But if the application threads are running at full speed, then they can easily produce more output than the background thread can handle.

The NLog ConsoleTarget supports batch writing of multiple LogEvents in a single write-operation, when combined with
AsyncWrapperTarget (Ex. `<targets async="true">`). When enabled then it would double the performance of the Console-output.
This ability was introduced with NLog v4.6.8 and protected with the feature-flag `WriteBuffer`.

NLog v6 enables batch-writing and will not use `Console.WriteLine` by default.
The feature-flag has also changed name to `ForceWriteLine` (Default = false).
If depending on console redirection where output must reach `Console.WriteLine`,
then one can explicit assign `ForceWriteLine = true` for the NLog ConsoleTarget.

### NLog JsonLayout EscapeForwardSlash obsolete

NLog v5 changed `JsonLayout` to have the default value `EscapeForwardSlash = false`, and now NLog v6
marks the NLog `JsonLayout` `EscapeForwardSlash` as completely obsolete and no longer having any effect.

### NLog JsonLayout SuppressSpaces default true

The `JsonLayout` now have the new default value `SuppressSpaces = true`, 
since log-file-size / network-traffic-usage doesn't benefit from the extra spaces.

If the output from `JsonLayout` needs to be more human readable, then one can explictly assign
`SuppressSpaces = false` or `IndentJson = true`.

### NLog ColoredConsoleTarget with Errors in red

NLog `ColoredConsoleTarget` used the color Yellow for Errors and Magenta for Warnings.
This has now been changed to color Red for Errors and Yellow for Warnings.

This is to align with the normal color standards that most other systems seems to be using.

### NLog ColoredConsoleTarget without RegEx

RegularExpressions (RegEx) is a huge API, and a big dependency for a logging library,
so to reduce the footprint of NLog then RegEx support have been removed.

This means word-highlighting rules no longer can scan for word-matches using RegEx.
But logic has been implemented to continue support `IgnoreCase` and `WholeWords`
for the string-matching logic.

### NLog Replace LayoutRenderer without RegEx

RegularExpressions (RegEx) is a huge API, and a big dependency for a logging library,
so to reduce the footprint of NLog then RegEx support have been removed.

Logic has been implemented to continue support `IgnoreCase` and `WholeWords`
for the string-matching logic. 

This means the following has been removed for the `${replace}` LayoutRenderer:
- `bool RegEx`
- `bool CompileRegex`
- `string ReplaceGroupName`

If RegEx replace-logic is important then one can use the new nuget-package `NLog.RegEx`, which includes `${regex-replace}`.

### NLog InternalLogger without LogToTrace

NLog `InternalLogger.LogToTrace` has been removed. This reduces the NLog footprint by
removing references to `System.Diagnostics.Trace` and `System.Diagnostics.TraceListener`.

If it is important to redirect NLog InternalLogger output to `System.Diagnostics.Trace`,
then one can use NLog `InternalLogger.LogWriter` to assign a custom `StringWriter` that performs the forwarding.
Alternative one can setup custom subscriber to NLog `InternalLogger.InternalEventOccurred` event handler.

### NLog RequiredParameter attribute ignored

NLog have removed its validation of properties marked with `[RequiredParameter]`, where it would alert
when Target- or Layout-options was missing a value. NLog have now changed to nullable references,
so options that must have a value are not nullable and always have a value.

This means that authors of NLog Targets or Layouts should not rely on `[RequiredParameter]`,
but should instead perform their own validation of options during initialization. Ex:

```csharp
protected override void InitializeTarget()
{
    base.InitializeTarget();

    if (FileName is null || ReferenceEquals(FileName, Layout.Empty))
        throw new NLogConfigurationException("FileTarget FileName-property must be assigned.");
}
```

### NLog XmlParser replaces XmlReader

The .NET `System.Xml.XmlReader` is a heavy dependency that depend on HttpClient for loading external XML,
and depend on IL-code-generation to optimize type serialization. To reduce dependencies and minimize AOT-build-filesize,
then NLog now includes its own basic XML-parser.

It could have been nice if Microsoft could refactor `System.Xml.XmlReader`, so it only introduced a minimal AOT-footprint,
but that is probably too late.

The NLog XML-parser only provides basic XML support, but it should be able to load any XML file that was
working with NLog v5. 

### NLog SimpleLayout Immutable
NLog `SimpleLayout` have removed the setter-method for its `Text`-property, and is now a sealed class.

This is to simpilfy the NLog `SimpleLayout` API, and to make it clear that NLog will optimize based on the initial layout.

## Many other improvements

For full list of all changes: [NLog 6.0 Pull Requests](https://github.com/NLog/NLog/pulls?q=is%3Apr+is%3Amerged+milestone:%226.0%22)

- [Breaking Changes](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22breaking%20change%22+is%3Amerged+milestone:%226.0%22)
- [Breaking Behavior Changes](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22breaking%20behavior%20change%22+is%3Amerged+milestone:%226.0%22)
- [Features](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22Feature%22+is%3Amerged+milestone:%226.0%22)
- [Improvements](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22Enhancement%22+is%3Amerged+milestone:%226.0%22)
- [Performance](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22Performance%22+is%3Amerged+milestone:%226.0%22)

[Comments and feedback](https://github.com/NLog/NLog/issues/4931) are welcome.

## Credits
Additional thanks to all contributers, since last major release:

- [ana1250](https://github.com/ana1250)
- [Pavan8374](https://github.com/Pavan8374)
- [smnsht](https://github.com/smnsht)
- [RomanSoloweow](https://github.com/RomanSoloweow)
- [wadebaird](https://github.com/wadebaird)
- [hangy](https://github.com/hangy)
- [lavige777](https://github.com/lavige777)
- [jokoyoski](https://github.com/jokoyoski)
- [saltukkos](https://github.com/saltukkos)
- [nih0n](https://github.com/nih0n)
- [michaelplavnik](https://github.com/michaelplavnik)
- [Aaronmsv](https://github.com/Aaronmsv)
- [ShadowDancer](https://github.com/ShadowDancer)
- [Orace](https://github.com/Orace)
- [tvogel-nid](https://github.com/tvogel-nid)
- [martinzding](https://github.com/martinzding)
- [kurnakovv](https://github.com/kurnakovv)
- [dance](https://github.com/dance)
- [JohnVerheij](https://github.com/JohnVerheij)