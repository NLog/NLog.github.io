---
layout: post
title: NLog 5.0 Finally Ready!
---

NLog 5.0 has completed preview testing, and is ready for release.

## Major Features

- NLog is now faster and lighter
- ScopeContext to replace MDC + MDLC + NDC + NDLC
- NLog Layout stored as NLog Configuration Variables (Ex. JsonLayout)
- NLog Layout for everything
- Fluent API for NLog LoggingConfiguration
- NLog Callsite from caller member attributes
- LogFactory with Dependency Injection
- Updated default values for better out-of-the-box experience
- Multiple type-aliases can be defined for targets, layouts, layout renderers and conditions
- Parsing of type-alias will now ignore dashes (-)
- NLog v5.1 enables support for ISpanFormattable in FormattedMessage and serializing JSON.
- NLog v5.2 includes annotations for application trimming without build warnings.

See details [here](https://nlog-project.org/2021/08/25/nlog-5-0-preview1-ready.html)

## Major Breaking Changes

NLog v5.2 marks additional methods as obsolete as they conflict with [application trimming](https://nlog-project.org/2023/05/30/nlog-5-2-trim-warnings.html).

See rationale [here](https://nlog-project.org/2021/08/25/nlog-5-0-preview1-ready.html)

- Strong Version Changed
- Obsolete methods have been removed
- LoggingRule Filters DefaultAction changed to FilterResult.Ignore, that can cause NO output.
- NLog.Extensions.Logging without any filter, that can give LOTS of unexpected output.
- NLog.Extensions.Logging changes capture of EventId, so missing EventId_Id-property.
- NLog.Extensions.Logging makes NLog-section reserved in appsettings.json
- NLog Extensions assemblies will not be loaded automatically, so [extensions must be explicitly added](https://github.com/NLog/NLog/wiki/Register-your-custom-component).
- NLog DatabaseTarget extracted into its own [NLog.Database](https://www.nuget.org/packages/NLog.Database) nuget-package
- NLog OutputDebugStringTarget extracted into its own [NLog.OutputDebugString](https://www.nuget.org/packages/NLog.OutputDebugString) nuget-package
- NLog PerformanceCounterTarget extracted into its own [NLog.PerformanceCounter](https://www.nuget.org/packages/NLog.PerformanceCounter) nuget-package
- NLog ImpersonatingTargetWrapper extracted into its own [NLog.WindowsIdentity](https://www.nuget.org/packages/NLog.WindowsIdentity) nuget-package
- NLog LogReceiverWebServiceTarget extracted into its own [NLog.Wcf](https://www.nuget.org/packages/NLog.Wcf) nuget-package
- NLog PerformanceCounterLayoutRenderer extracted into its own [NLog.PerformanceCounter](https://www.nuget.org/packages/NLog.PerformanceCounter) nuget-package
- NLog RegistryLayoutRenderer extracted into its own [NLog.WindowsRegistry](https://www.nuget.org/packages/NLog.WindowsRegistry) nuget-package
- NLog WindowsIdentityLayoutRenderer extracted into its own [NLog.WindowsIdentity](https://www.nuget.org/packages/NLog.WindowsIdentity) nuget-package
- Deprecated NLog.Extended nuget-package
- Deprecated NLog.Config nuget-package
- Xamarin, Windows Phone and Silverlight platforms replaced by .NET Standard
- .NET Framework v4.0 platform replaced by .NET Framework v3.5 platform
- Automatic loading of NLog.config now first check for exe.nlog
- NLog Configuration will have KeepVariablesOnReload enabled by default
- Layout and LayoutRenderer are now threadsafe by default
- Default Layout for NLog Targets has been updated
- Default Format for NLog Exception layoutrenderer has been updated
- NLog InternalLogger will not initialize itself from app.config or environment variables
- Removed obsolete methods and properties
- ScopeContext changes MappedDiagnosticContext (MDC) to use AsyncLocal
- MappedDiagnosticContext (MDC), MappedDiagnosticLogicalContext (MDLC), GlobalDiagnosticContext (GDC) now case-insensitive
- FileTarget KeepFileOpen = true by default
- FileTarget ConcurrentWrites = false by default
- FileTarget Encoding default value changed to UTF8
- FileTarget will include BOM by default for UTF16 and UTF32 encoding
- NetworkTarget will Discard by default on overflow
- JsonLayout MaxRecursionLimit default value changed to 1
- JsonLayout EscapeForwardSlash default value changed to false
- JsonLayout always includes decimal point for floating-point types
- CallSite-renderer will automatically clean async callstacks
- The Simplelayout.ToString() has been changed

For full list of all changes: [NLog 5.0 Pull Requests](https://github.com/NLog/NLog/pulls?q=is%3Apr+is%3Amerged+milestone:%225.0%22)

- [Breaking Changes](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22breaking%20change%22+is%3Amerged+milestone:%225.0%22)
- [Breaking Behavior Changes](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22breaking%20behavior%20change%22+is%3Amerged+milestone:%225.0%22)
- [Features](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22Feature%22+is%3Amerged+milestone:%225.0%22)
- [Improvements](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22Enhancement%22+is%3Amerged+milestone:%225.0%22)
- [Performance](https://github.com/NLog/NLog/pulls?q=is%3Apr+label%3A%22Performance%22+is%3Amerged+milestone:%225.0%22)

## Credits
Additional thanks to contributers:

- @TalAloni
- @njqdev
- @menishmueli
- @ErickJeffries
- @AlanLiu90
- @aled
- @tetrodoxin
- @noamyogev84
- @simoneserra93
- @sjafarianm
- @Orace
- @GitHubPang
- @KurnakovMaksim
- @mickelsonmichael
- @ThomasArdal
