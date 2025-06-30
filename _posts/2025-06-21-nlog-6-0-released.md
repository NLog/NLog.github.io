---
layout: post
title: NLog 6.0 released
---

NLog v6 with the following major changes:

- Support Ahead-of-Time (AOT) builds without warnings
- Support Nullable references
- Support ReadOnlySpan to reduce memory allocations
- LogFactory supports FlushAsync and IDisposableAsync
- FileTarget removed support for ConcurrentWrites
- FileTarget refactored file-archive-logic with ArchiveSuffixFormat

NLog v6 reducing its footprint by extracting features into separate nuget-packages:

- [NLog.Targets.AtomicFile](https://www.nuget.org/packages/NLog.Targets.AtomicFile) - ConcurrentWrites using atomic file-append from operating system API.
- [NLog.Targets.ConcurrentFile](https://www.nuget.org/packages/NLog.Targets.ConcurrentFile) - Original FileTarget with ConcurrentWrites using global mutex from operating system API.
- [NLog.Targets.GZipFile](https://www.nuget.org/packages/NLog.Targets.GZipFile) - EnableArchiveFileCompression using GZipStream for writing GZip compressed log-files.
- [NLog.Targets.Mail](https://www.nuget.org/packages/NLog.Targets.Mail) - Depends on System.Net.Mail.SmtpClient.
- [NLog.Targets.Network](https://www.nuget.org/packages/NLog.Targets.Network) - Depends on TCP and UDP Network Socket, and adds support for Syslog and Graylog.
- [NLog.Targets.Trace](https://www.nuget.org/packages/NLog.Targets.Trace) - Depends on System.Diagnostics.TraceListener and System.Diagnostics.Trace.CorrelationManager.
- [NLog.Targets.WebService](https://www.nuget.org/packages/NLog.Targets.WebService) - Depends on System.Net.Http.HttpClient.
- [NLog.RegEx](https://www.nuget.org/packages/NLog.RegEx) - Depends on System.Text.RegularExpressions which is a huge dependency for a logging library.

See also [List of major changes in NLog v6](https://nlog-project.org/2025/04/29/nlog-6-0-major-changes.html) for more details.

## Many other improvements

Full list of all changes: [NLog 6.0 Pull Requests](https://github.com/NLog/NLog/pulls?q=is%3Apr+is%3Amerged+milestone:%226.0%22)

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