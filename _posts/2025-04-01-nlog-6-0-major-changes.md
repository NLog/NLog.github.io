---
layout: post
title: NLog 6.0 - List of major changes
---

NLog 6.0 is a major version release that introduces breaking changes, including the splitting into multiple NuGet packages, and other improvements to support AOT builds.

## Major changes

### NLog supports AOT

NLog has traditionally relied on reflection to dynamically discover requirements for target output.
But reflection does not always work well with build trimming, and before NLog marked itself to have trimming disabled.

NLog includes many features, each of these feature often introduce additional dependencies on the .NET library.
This can lead to overhead for AOT builds, as it must include and compile all the relevant source code.

NLog v6 attempts to reduce its footprint by extracting several features into separate nuget-packages:

- NLog.RegEx - Depends on System.Text.RegularExpressions which is a huge dependency for a logging library.
- NLog.Targets.ConcurrentFile - ConcurrentWrites using global mutex from operating system API.
- NLog.Targets.AtomicFile - ConcurrentWrites using atomic file-append from operating system API.
- NLog.Targets.Mail - Depends on System.Net.Mail.SmtpClient.
- NLog.Targets.Network - Depends on TCP and UDP Network Socket.
- NLog.Targets.Trace - Depends on System.Diagnostics.TraceListener.
- NLog.Targets.WebService - Depends on System.Net.Http.HttpClient.

NLog v6 also no longer supports automatic loading of `NLog.config`-file. This is because dynamic configuration 
loading, prevents build trimming of any NLog types, as the AOT-build cannot determine upfront what types
will be used by the `NLog.config`-file.

### NLog without automatic loading of NLog.config

NLog will no longer automatically load the NLog LoggingConfiguration, when creating the first NLog Logger by calling `LogManger.GetCurrentClassLogger()` or `LogManger.GetLogger()`.

Instead one must explicit load the `NLog.config` file at application-startup:
```csharp
var logger = NLog.LogManager.Setup().LoadConfigurationFromFile().GetCurrentClassLogger();
logger.Info("Hello World");
```

When using Microsoft HostBuilder with `UseNLog()`, then it will continue to automatically load the NLog LoggingConfiguration without having to make any changes.

.NET Framework will continue to probe NLog LoggingConfiguration from the `app.config` / `web.config`, so one can consider doing this:
```xml
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <configSections>
    <section name="nlog" type="NLog.Config.ConfigSectionHandler, NLog"/>
  </configSections>
  <nlog include="NLog.config" />
</configuration>
```

### NLog FileTarget without ConcurrentWrites

NLog FileTarget no longer uses `File.Move` by default, but instead rolls to the next filename.
This is to prevent file-locking issues with other background-applications, or if the log-file is
held open by file-viewer.

The new archive-logic:

- LogFile.txt (Oldest file)
- LogFile_1.txt
- LogFile_2.txt (Newest file)

The old archive-logic:

- LogFile.txt (Newest file)
- LogFile.1.txt (Oldest file)
- LogFile.2.txt

NLog FileTarget still support static archive logic with `File.Move`, but it must be explictly activated
by specifying `ArchiveFileName`.

NLog FileTarget no longer has the following options:

- ConcurrentWrites - Removed because of dependency on global mutex and exotic file-locks.
- EnableArchiveFileCompression - Removed because of dependency on compression-libraries.
- CleanupFileName - Removed because it is now implicit.
- FileNameKind - Removed because it is now implicit.
- ArchiveFileKind - Removed because it is now implicit.
- FileAttributes - Removed because of dependency on Windows-only API.
- ForceManaged - Removed because of dependency on Windows-only API.
- ConcurrentWriteAttempts - Removed together with ConcurrentWrites.
- ConcurrentWriteAttemptDelay - Removed together with ConcurrentWrites.
- ForceMutexConcurrentWrites - Removed together with ConcurrentWrites.
- NetworkWrites - Replaced by KeepFileOpen.
- ArchiveOldFileOnStartupAboveSize - Instead use ArchiveAboveSize / ArchiveOldFileOnStartup.
- ArchiveDateFormat - Marked as obsolete. Instead use new ArchiveSuffixFormat
- ArchiveNumbering - Marked as obsolete. Instead use new ArchiveSuffixFormat (Rolling is unsupported).

If one still requires these options, then one can use the new NLog.Targets.ConcurrentFile-nuget-package.

### NLog AtomicFileTarget without mutex

New AtomicFileTarget has been introduced, that supports atomic file-append with help from the operating system,
and supports both Windows and Linux (with help from Mono Posix) for NET8 (and newer).

Extends the standard FileTarget and adds support for `ConcurrentWrites = true`, but without using global mutex.

Linux users must use `dotnet publish` with `--configuration release --runtime linux-x64` to ensure
correct publish of the `Mono.Posix.NETStandard`-nuget-package dependency.

### NLog GZipFileTarget with GZipStream

New GZipFileTarget has been introduced, that writes directly to a compressed log-file using GZipStream.

Extends the standard FileTarget and adds support for `EnableArchiveFileCompression = true`, but only supports
GZip file compression.

The GZip File compression doesn't allow appending to existing GZip Archive without rewriting the entire GZip Archive.
Therefore these options are set by default `KeepFileOpen = true` and `ArchiveOldFileOnStartup = true`.

The GZip File compression has better handling of large log-files compared to the old `EnableArchiveFileCompression = true`,
where the old ZIP compression would stall the file-logging until completed.

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

### NLog GelfTarget and GelfLayout

The NLog.Targets.NetworkTarget nuget-package also includes support for the Graylog Extended Log Format (GELF).

The `GelfTarget` extends the standard `NetworkTarget` with the new `GelfLayout`.

It depends on the builtin NLog JSON serializer, but follows the 'standard' of prefixing all
custom property-names with underscore `_`.

## NLog SyslogTarget and SyslogLayout

The NLog.Targets.NetworkTarget nuget-package also includes support for the Syslog Output Format.

The `SyslogTarget` extends the standard `NetworkTarget` with the new `SyslogLayout`.

The `SyslogLayout` supports both RFC-3164 (simple) + RFC-5424 (structured) logging output.

### NLog NetworkTarget with NoDelay = true

The NLog.Targets.NetworkTarget nuget-package includes support for configuring TCP_NODELAY.
The `NetworkTarget` will by default use `NoDelay = true` to turn off delayed ACK,
to avoid delays of 200ms because of nagle-algorithm.

Believe most users will not notice the overhead of additional ACK-packages, but will notice
a delay of 200ms.

### NLog NetworkTarget with SendTimeoutSeconds = 100

The NLog.Targets.NetworkTarget nuget-package changes the default value of TCP SendTimeout
from waiting forever to 100 secs. 

The `NetworkTarget` should now react to the network-cable being unplugged and the TCP send-window being filled.

The `NetworkTarget` should now automatically attempt to reconnect when the endpoint suddenly becomes unresponsive.

### NLog NetworkTarget with SslCertificateFile

The NLog.Targets.NetworkTarget nuget-package introduces the ability to specify custom SSL certificate from file.

The `NetworkTarget` now recognizes these new settings:
 - `Layout SslCertificateFile`
 - `Layout SslCertificatePassword`

The `NetworkTarget` can now perform SSL handshake with custom SSL certificate from file, without needing to register the certificate in the global operating-system cache.

## Breaking changes

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

### NLog JsonLayout EscapeForwardSlash obsolete

NLog v5 changed `JsonLayout` to have the default value `EscapeForwardSlash = false`, and now NLog v6
marks the NLog `JsonLayout` `EscapeForwardSlash` as completely obsolete and no longer having any effect.

### NLog JsonLayout SuppressSpaces default true

The `JsonLayout` has now have a new default value for `SuppressSpaces = true`, 
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

NLog `InternalLogger.LogToTrace` has been remnoved. This reduces the NLog footprint by
removing references to `System.Diagnostics.Trace` and `System.Diagnostics.TraceListener`.

If it is important to redirect NLog InternalLogger output to `System.Diagnostics.Trace`,
then one can use NLog `InternalLogger.LogWriter` to assign a custom `StringWriter` that performs the forwarding.
Alternative one can setup custom subscriber to NLog `InternalLogger.InternalEventOccurred` event handler.

### NLog XmlParser replaces XmlReader

The .NET `System.Xml.XmlReader` is a heavy dependency that both loads XML using HttpClient, and support
code generation to optimize serialization for types. To reduce dependencies and minimize AOT-build-filesize,
then NLog now includes its own XML-parser.

The NLog XML-parser only provides basic XML support, but it should be able to load any XML file that was
working with NLog v5. 

### NLog EventLog with more Layout
Use Layout for Log + MachineName + MaxMessageLength + MaxKilobytes

### NLog SimpleLayout Immutable
NLog `SimpleLayout` have removed the setter-method for its `Text`-property.

This is to simpilfy the NLog `SimpleLayout` API, and to make it clear that NLog will optimize based on the initial layout.

### Minimal Logger-API
Not ready yet, and post-poned because major breaking change, which makes it harder to test first NLog v6-Preview.

### Logger API with string interpolation
Not ready yet, and post-poned because waiting for minimal Logger-API

Idea is to skip string interpolation, when LogLevel is not enabled.

### Logger API with ReadOnlySpan params
Not ready yet, and post-poned because waiting for minimal Logger-API

Idea is to skip params array-allocation, when LogLevel is not enabled.

And if structured-logging then skip params allocation, but only rely on properties-dictionary.

### NLog Nullable References
Not ready yet, and post-poned because waiting for minimal Logger-API

## Many other improvements

For full list of all changes: [NLog 6.0 Pull Requests](https://github.com/NLog/NLog/pulls?q=is%3Apr+is%3Amerged+milestone:%226.0%22)

- [Breaking Changes](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22breaking%20change%22+is%3Amerged+milestone:%226.0%22)
- [Breaking Behavior Changes](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22breaking%20behavior%20change%22+is%3Amerged+milestone:%226.0%22)
- [Features](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22Feature%22+is%3Amerged+milestone:%226.0%22)
- [Improvements](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22Enhancement%22+is%3Amerged+milestone:%226.0%22)
- [Performance](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22Performance%22+is%3Amerged+milestone:%226.0%22)
