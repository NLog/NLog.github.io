---
layout: post
title: NLog 2.0 Beta 1 Release Notes
alias: /nlog2-beta1-release-notes
---

NLog 2.0 Beta 1 has been released and is available for download from <http://nlog-project.org/download>

What is NLog?
NLog is a popular logging platform for .NET with rich log routing and management capabilities. It makes it easy to produce and manage high-quality logs for your application regardless of its size or complexity. NLog is open source software, distributed under the terms of [BSD license](http://www.opensource.org/licenses/bsd-license.php) and source is available on [GitHub](http://github.com/NLog/NLog/).

NLog 2.0 release is focused on adding support for new platforms (Silverlight, .NET Framework 4), improving logging architecture and manageability and addressing most frequently reported user issues.

Platform support
----------------
The following platforms are supported:

 * .NET Framework 2.0 SP1 and above, 3.5 (Client and Extended profiles), 4.0 (Client and Extended profiles)
 * Silverlight 2.0, 3.0, 4.0
 * .NET Compact Framework 2.0, 3.5
 * Mono 2.x profile

Support for .NET 1.x, .NET Compact Framework 1.0 has been removed in this release.

New features
------------
 * Support for .NET client and extended profile. All features which require .NET Extended profile have been moved to a separate assembly called NLog.Extended.dll. See the [NLog.Extended](http://github.com/NLog/NLog/tree/master/src/NLog.Extended/) project on GitHub for more details.
 * [NLogTraceListener](http://nlog-project.org/2010/09/02/routing-system-diagnostics-trace-and-system-diagnostics-tracesource-logs-through-nlog.html) for integrating with System.Diagnostics Trace and TraceSource APIs
 * [Wrapper layout renderers](http://nlog-project.org/2008/11/22/wrapper-layout-renderers-are-coming-to-nlog.html) which modify output of other layout renderers.
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

 * [Asynchronous processing and exception handling](http://nlog-project.org/2010/05/18/asynchronous-makeover-nlog-edition.html).
 * [InstallNLogConfig](http://nlog-project.org/2010/09/25/deploying-nlog-configuration.html) - configuration installer

Target updates
--------------
 * Added WCF-based [LogReceiverService target](https://github.com/NLog/NLog/wiki/LogReceiverService-target), for communicating between client which uses NLog and server. See examples on GitHub:
   * [Silverlight client](http://github.com/NLog/NLog/tree/master/examples/NLogSilverlightApp/) which transmits logs to a web server.
   * [Log receiver service](http://github.com/NLog/NLog/tree/master/examples/NLogSilverlightApp.Web/) which uses WCF to receive logs.
 * Update scrolling [RichTextBox target](https://github.com/NLog/NLog/wiki/RichTextBox-target) - auto scroll, length limit, height and width configuration.
 * [Database target](https://github.com/NLog/NLog/wiki/Database-target) enhancements: support for installation and uninstallation, named connection strings from the configuration file.
 * [Mail target](https://github.com/NLog/NLog/wiki/Mail-target) now supports **enableSsl** flag for communicating with SMTP server over SSL.

Architectural updates
---------------------
 * NLog codebase has been cleaned up and upgraded to C# 3.0.
 * Entire codebase passes StyleCop and FxCop analysis with relatively few exclusions.
 * Added unit test coverage for new and refactored code.
 * [Nightly builds](http://nlog-project.org/2010/05/22/nlog-nightly-builds-available.html) available in the [Download](http://nlog-project.org/download) section.
 * Programmatic configuration API has been cleaned up to reduce coupling between components and improve maintainability.
 * Directory and namespace structure cleanup
 * MSI-based [installer](http://nlog-project.org/2010/05/01/nlog-2-0-installer-is-available-for-testing.html).
 * Robustness fixes - centralized and [unified handling of exceptions](http://nlog-project.org/2010/09/05/new-exception-handling-rules-in-nlog-2-0.html).
 * Switched build system to MSBuild
 * Improved internal logging for better diagnostics.

Backwards compatibility and breaking changes
--------------------------------------------
Logging API and configuration file are generally backwards compatible, but programmatic configuration APIs are not. In order to support new platforms and features, NLog codebase had to be refactored which in some cases introduced breaking changes. See NLog website for [backwards compatibility and breaking change policy](http://nlog-project.org/2009/10/19/nlog-2-backwards-compatibility-and-breaking-change-policy.html).

In addition to that, please refer to the following articles for information about further behavior changes:

 * Exception handling rules have been changed. [Read more](http://nlog-project.org/2010/09/05/new-exception-handling-rules-in-nlog-2-0.html).
 * Removed support for NLOG_GLOBAL_CONFIG_FILE and NLog.dll.nlog [configuration file locations](https://github.com/NLog/NLog/wiki/Configuration-file#wiki-configuration-file-locations).
 