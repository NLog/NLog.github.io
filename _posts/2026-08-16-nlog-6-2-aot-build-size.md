---
layout: post
title: NLog 6.2 reduces AOT build size
---

## TypeConverter is legacy

NLog v6.2 removes the legacy TypeConverter support for AOT builds, and reducing filesize by approximately 1 MB for AOT-builds.

NLog used the TypeConverter to convert strings to objects, when loading configuration files. NLog already has built-in support for the common string-to-object conversions, making the general-purpose TypeConverter less needed.

## FileTarget with FileLifecycleHooks

FileTarget now supports `FileLifecycleHooks`, providing extension points for customizing the lifecycle of log files and the target itself.

Lifecycle hooks can be used to:

- **Customize initialization** — Run custom logic when the FileTarget is initialized.
- **Customize file streams** — Wrap the underlying stream to add encryption, compression, buffering, or other processing.
- **Process closed files** — Perform custom actions when NLog closes an individual log file.
- **Process files before deletion** — Copy, compress, upload, or otherwise process a file before NLog deletes it.
- **Perform target cleanup** — Execute custom cleanup logic when the FileTarget is shut down.

For example, `OnFileDeleting` can be used to create a ZIP archive of an old log file before NLog deletes it, while OnFileOpened can wrap the output stream to transparently encrypt log data.

## ScopeContext Properties Reversed

`ScopeContext` has been modified to collect properties in reverse order, so the most recently added properties are processed first.

This change allows the NLog `ScopeContext` compaction logic to write directly to the final dictionary instead of first allocating and populating a List to preserve dictionary ordering.

When new properties are pushed to `ScopeContext`, they are pushed to a linked list that lives on the thread's execution context. The `ScopeContext` compaction logic prevents this linked list from growing indefinitely when a scope is not popped by the application.

The result is fewer allocations and more efficient processing of `ScopeContext` properties, especially for applications that make extensive use of scope properties.

## ProcessInfo LayoutRenderer Obsolete

NLog `${processinfo}` LayoutRenderer is now obsolete, as the dependencies introduced by the .NET `Process` object can increase the AOT build filesize.

Alternative LayoutRenderers are available:
- `${processid}` - Process Id.
- `${processname}` - Process Name.
- `${processtime}` - Time elapsed since process start.
- `${processstart}` - Process Start Time with support for Format and Culture (New in NLog v6.2).
- `${gc:WorkingSet}` - Process Memory Working Set (New in NLog v6.2).

NET11 includes optimizations for the .NET `Process` class, which further reduces the AOT build filesize.

If process information is needed that is not provided by the existing LayoutRenderers, a [custom LayoutRenderer](https://github.com/NLog/NLog/wiki/How-to-write-a-custom-LayoutRenderer) can be registered.

## HttpClientTarget NuGet package

New nuget-package [NLog.Targets.HttpClient](https://www.nuget.org/packages/NLog.Targets.HttpClient) provides `HttpClientTarget` for sending logevents to HTTP/HTTPS endpoint:

Including features:
- HTTP POST, GET, and custom HTTP methods.
- Batching multiple log events into a single request.
- JSON arrays or newline-delimited JSON (NDJSON) for batched events.
- GZip compression.
- Custom HTTP headers and authentication.
- Client certificates for mutual TLS (mTLS).
- HTTP proxy support.
- Configurable retry handling for transient HTTP failures.

The target also reuses `HttpClient` connections for efficient HTTP communication and periodically refreshes the underlying client to detect DNS changes.

This makes HttpClientTarget suitable for sending NLog events to custom HTTP logging services as well as existing HTTP-based log collectors. For example, it can be combined with [SplunkLayout](https://github.com/NLog/NLog/wiki/SplunkLayout) to send events to the Splunk HTTP Event Collector (HEC).

## OpenTelemetryHttpTarget NuGet package

New nuget-package [NLog.Targets.OpenTelemetryHttp](https://www.nuget.org/packages/NLog.Targets.OpenTelemetryHttp) for exporting NLog log events directly to an OpenTelemetry Collector or any OTLP/HTTP-compatible endpoint.

Including features:
- OpenTelemetry LogRecord body, trace ID, and span ID.
- NLog event properties as OpenTelemetry log attributes.
- Resource attributes such as service.name, service.version, and host.name.
- Standard OpenTelemetry environment variables for endpoint, headers, compression, timeout, service name, and resource attributes.
- Batching, payload compression, and retry handling.

`OpenTelemetryHttpTarget` automatically recognizes the standard `OTEL_EXPORTER_OTLP_*` environment variables when target properties are not explicitly configured,
so able to export NLog logevents to OpenTelemetry deployments without adding the OpenTelemetry SDK.

## NLog and next major version

NLog v6 seems to have reached a nice stable point, and the reduction of dependencies has been a move in the right direction. Most users seem happy about the modernizations, even though the rewrite of `FileTarget` has caused some friction.

The release of the new [NLog.Targets.HttpClient](https://www.nuget.org/packages/NLog.Targets.HttpClient) and [NLog.Targets.OpenTelemetryHttp](https://www.nuget.org/packages/NLog.Targets.OpenTelemetryHttp) NuGet-packages should close some gaps and further strengthen the NLog ecosystem.

Looking beyond NLog v6.x and towards a possible next major version, there are several ideas worth exploring:
- Immutable LogEvent/LogRecord to replace the existing `LogEventInfo`
- Immutable collection of event properties captured only when actually needed.
- High resolution UTC timestamps by default.
- Culture-invariant message formatting by default.

Together these changes could lead to a new immutable logging pipeline that is both safer and more efficient, while still supporting the existing `LogEventInfo` pipeline for backwards compatibility.

Another area worth exploring is a non-allocating logging path for common logging scenarios, without paying the cost of execution context, scope properties, and other features unless needed by the configured target output.

NLog should not try to compete with Microsoft.Extensions.Logging as the standard `ILogger` abstraction or its use of source generators. NLog should remain a standalone logging framework while providing first-class integration with Microsoft.Extensions.Logging.

NLog should complement and extend Microsoft.Extensions.Logging when applications need more than basic console output, providing advanced logging features, targets, layouts, and rich machine-readable output.