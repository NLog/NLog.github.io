---
layout: post
title: NLog 2.0 RC Release Notes
alias: /nlog-2-rc-release-notes
---

NLog 2.0 Release Candidate (RC) has been released and is available for download from <http://nlog.codeplex.com/releases/view/68535>.

What is NLog?
-------------
NLog is a popular logging platform for .NET, Silverlight and Windows Phone with rich log routing and management capabilities. It makes it easy to produce and manage high-quality logs for your application regardless of its size or complexity. NLog is open source software, distributed under the terms of [BSD license](http://www.opensource.org/licenses/bsd-license.php) and source is available on [GitHub](http://github.com/NLog/NLog/).

NLog 2.0 release is focused on adding support for new platforms (Silverlight, .NET Framework 4, Windows Phone 7.x), improving logging architecture and manageability and addressing most frequently reported user issues.

What’s - New in NLog 2.0
----------------------
 * [Asynchronous logging pipeline](http://nlog-project.org/2010/05/18/asynchronous-makeover-nlog-edition.html) - fully supports async-only operations (Silverlight)
 * [Wrapper Layout Renderers](http://nlog-project.org/2008/11/22/wrapper-layout-renderers-are-coming-to-nlog.html) - can transform output of other layout renderers
 * [New build system (MSBuild-based)](http://nlog-project.org/2010/02/20/important-nlog-2-0-milestone-reached.html) - old build system based on NAnt is no longer supported
 * [New MSI-based installer](http://nlog-project.org/2010/05/01/nlog-2-0-installer-is-available-for-testing.html) - generated using WIX, NSIS-based installer is no longer supported
 * [Platform-specific Intellisense](http://nlog-project.org/2010/06/30/intellisense-for-nlog-configuration-files.html) - includes only supported targets and properties for each platform
 * [Support for logging via Trace and TraceSource](http://nlog-project.org/2010/09/02/routing-system-diagnostics-trace-and-system-diagnostics-tracesource-logs-through-nlog.html) - new NLogTraceListener for integrating with legacy code
 * [New exception handling rules](http://nlog-project.org/2010/09/05/new-exception-handling-rules-in-nlog-2-0.html) - logging configuration errors will now throw exceptions at startup.
 * [InstallNLogConfig.exe](http://nlog-project.org/2010/09/25/deploying-nlog-configuration.html) - new tool to install/uninstall logging objects (such as event log, performance counters, etc.)
 * [Exception logging enhancements](http://nlog-project.org/2011/04/20/exception-logging-enhancements.html) - long-awaited extensions to ${exception} layout renderer.
 * Support for .NET client and extended profile. All features which require .NET Extended profile have been moved to a separate assembly called *NLog.Extended.dll*. See the [NLog.Extended](http://github.com/NLog/NLog/tree/master/src/NLog.Extended/) project on GitHub for more details.
 * Merged NLog.ComInterop into NLog.dll itself, which means one less DLL to deploy when using NLog through COM.
 * GetCurrentClassLogger() is now supported in .NET Compact Framework.

<blockquote>
Since there is no StackTrace class in .NET Compact Framework, the implementation uses relatively slow method to get the calling class, so using it in a loop or performance-sensitive code is not recommended)
</blockquote>

 * Lambda-based delayed message computation:

{% highlight csharp %}
Logger logger = LogManager.GetCurrentClassLogger();
int i, j, k;

// message will not be computed if not necessary, thus helping improve performance when logs are disabled
logger.Info(() => "message" + i + ", " + j + "," + k);
{% endhighlight %}

In addition to those, lots of work went into raising the quality bar of NLog:

 * The entire codebase has been migrated to C# 3.0, cleaned up (thanks ReSharper!) and switched to using generic collection classes.
 * StyleCop and FxCop are now being used to analyze code quality.
 * Programmatic configuration API has been redesigned, to reduce internal coupling and improve testability
 * Hundreds of new unit tests have been written
 * Significant portions of internal logging and configuration pipeline have been rewritten for better maintainability.
 * All supported platforms have fully automated unit tests now

Target updates
--------------
 * Added WCF-based [LogReceiverService target](https://github.com/NLog/NLog/wiki/LogReceiverService-target), for communicating between client which uses NLog and server. See examples on GitHub:
   * [Silverlight client](http://github.com/NLog/NLog/tree/master/examples/NLogSilverlightApp/) which transmits logs to a web server.
   * [Log receiver service](http://github.com/NLog/NLog/tree/master/examples/NLogSilverlightApp.Web/) which uses WCF to receive logs.
 * Update scrolling [RichTextBox target](https://github.com/NLog/NLog/wiki/RichTextBox-target) - auto scroll, length limit, height and width configuration.
 * [Database target](https://github.com/NLog/NLog/wiki/Database-target) enhancements: support for installation and uninstallation, named connection strings from the configuration file.
 * [Mail target](https://github.com/NLog/NLog/wiki/Mail-target) now supports enableSsl flag for communicating with SMTP server over SSL.

Compatibility
-------------
This release of NLog adds compatibility with several new platforms.

 * Windows
   * .NET Framework 2.0 SP1
   * .NET Framework 3.5 SP1 - New in NLog 2.0
   * .NET Framework 4 Client Profile - New in NLog 2.0
   * .NET Framework 4 Extended Profile - New in NLog 2.0
 * Silverlight (Windows/Mac OS X)
   * Silverlight 2.0 - New in NLog 2.0
   * Silverlight 3.0 - New in NLog 2.0
   * Silverlight 4.0 - New in NLog 2.0
 * Silverlight for Windows Phone
   * Windows Phone 7 - New in NLog 2.0
   * Windows Phone 7.1 (beta) - New in NLog 2.0
 * .NET Compact Framework (Windows Mobile)
   * .NET Compact Framework 2.0
   * .NET Compact Framework 3.5 - New in NLog 2.0
 * Mono (Windows/Unix)
   * Mono 2.x profile (experimental)

NLogC component is supported on .NET Framework 4.0 only. NLog.ComInterop component is supported on all versions of .NET Framework. Compatibility with .NET Framework 1.x and .NET Compact Framework has been removed.

Backwards compatibility and breaking change policy
--------------------------------------------------
NLog v2.0 maintains backwards compatibility with:
 * existing NLog.config files
 * client code using Logger, LogManager, LoggerFactory, GDC, MDC, NDC and LogEventInfo classes

As a rule of thumb, existing code that does not rely on programmatic configuration or manipulation of NLog internal objects will continue to work with NLog v2.0. Majority of applications and components fall into this category and should be easily portable to NLog v2.0 without or with minimal changes.

Code which uses programmatic configuration will typically require modifications related to namespace reorganization.

Full breaking change policy can be viewed [here](http://nlog-project.org/2009/10/19/nlog-2-backwards-compatibility-and-breaking-change-policy.html).

Community support
-----------------
Community support for NLog 2.0 is available through discussion forum at <http://nlog-project.org/forum>.

Bugs and other issues can be filed via [issue tracker on CodePlex site](http://nlog.codeplex.com/).

At this time NLog project is not accepting source code contributions from the community. Users can help shape future releases by reporting bugs, suggesting new features and participating in community discussion on [NLog forum](http://nlog-project.org/forum).

Known issues
------------
 * NLog does not support running code in partial trusted on .NET Framework. Silverlight and Windows Phone partial trust scenarios are supported.
 * NLogTraceListener is not fully functional under Mono because of platform differences