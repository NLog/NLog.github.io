---
layout: post
title: NLog 4.0 release candidate is online
---

The release candidate of NLog 4.0 has is online. More than 100 issues are closed in GitHub. The release candidate can be downloaded from NuGet. 

##Features

This release contains the following features:



###Zipped file archives

The FileTarget can now compress the archived files to zip format. 
Example: set EnableArchiveFileCompression

{% highlight xml %}
  <target name="file" xsi:type="File"
      layout="${longdate} ${logger} ${message}" 
      fileName="${basedir}/logs/logfile.txt" 
      archiveFileName="${basedir}/archives/log.{#}.txt"
      archiveEvery="Day"
      archiveNumbering="Rolling"
      maxArchiveFiles="7"
    enableArchiveFileCompression="true" />
{% endhighlight %}


### Logging exceptions (**breaking change**)

Logging exceptions is now more consistent and complete then before. This is a breaking change.
All the logger methods, like `.Debug`, `Error` etc has now a first optional parameter of the type `Exception`. Only that parameter would be written as `Exception` to the log and can be used in the layout renderer like ` ${exception:format=tostring}`. 

#### Changes:

*	All "exception" methods are starting with `Exception`. E.g `Error(Exception exception, string message, params object[] args)`.
*	All "exception" methods has 'args' as parameter for formatting the message.
*	All "exception" methods has an overload with an `IFormatProvider` as parameter.

Changes that are not backwards-compatible.
*	removed "exceptionCandidate" hack: `Log(string message, Exception ex)` would write to exception property instead of message. This is non-backwards compatible in behaviour!
*	all other "exception methods": Eg. `ErrorException` and `Error(string message, Exception exception)` are marked as `Obsolete`, also in the interfaces. 

{% highlight csharp %}

//NLog 4.0
Logger.Error(ex, "ow noos");
Logger.Error(ex, "ow noo {0}", "s");

//Obsolete
Logger.ErrorException(ex, "ow noos");

//BREAKING CHANGE: no compile error, but exception is used in message formatting.
Logger.Error("ow noos", ex); //don't do this.
//consistent with:
Logger.Error("ow noos {0}", var1");

{% endhighlight %}

###Conditional logging

In extreme cases logging could affect the performance of your application. There is a small overhead when writing a lot of log messages, like Tracing.
For this case it’s now possible to only include the Trace and Debug call with a Debug release. 
Instead of writing:

{% highlight csharp %}
Logger.Trace(“entering method {0}, methodname”);
{% endhighlight %}

Write

{% highlight csharp %}
Logger. ConditionalTrace(“entering method {0}, methodname”);
{% endhighlight %}

This call will be removed by the .Net compiler if the DEBUG conditional compilation symbol is not set – default on a Release build.

### Auto load extensions

Assemblies with the name "NLog*.dll", like "NLog.CustomTarget.dll" are now loaded automatically. This assembly should be in the same folder as NLog.dll.
Of course you can load NLog extentions manually with the [`<Extensions>` config]( https://github.com/nlog/nlog/wiki/How-to-write-a-Target#how-to-use-the-newly-created-target)

### AllEventProperties layout renderer

A new layout renderer that outputs all of the event's properties. Format and separator can be manually configured.
Usage examples:

*	`${all-event-properties}`
*	`${all-event-properties:Separator=|}`
*	`${all-event-properties:Separator= | :Format=[key] is [value]}`

This combines nicely with the [fluent interface introduced in 3.2.0](http://nlog-project.org/2015/01/20/have-you-seen-our-new-fluent-interface.html).

Examples:
{% highlight csharp %}
var logger = LogManager.GetCurrentClassLogger();
logger.Info()
    .Message("This is a test fluent message '{0}'.", DateTime.Now.Ticks)
    .Property("Test", "InfoWrite")
    .Property("coolness", "200%")
    .Property("a", "not b")
    .Write();
{% endhighlight %}

* In case of `${all-event-properties}` this would write: `Test=InfoWrite, coolness=200%, a=not b`
* In case of `${all-event-properties:Format=[key] is [value]}` this would write: `Test is InfoWrite, coolness is 200%, a is not b`


### Writing to JSON

A new layout that renders log events as structured JSON documents.
Example:

{% highlight csharp %}
<target name="jsonFile" xsi:type="File" fileName="${logFileNamePrefix}.json">
      <layout xsi:type="JsonLayout">
              <attribute name="time" layout="${longdate}" />
              <attribute name="level" layout="${level:upperCase=true}"/>
              <attribute name="message" layout="${message}" />
              <attribute name="callsite" layout="${callsite:includeSourcePath=true}" />
              <attribute name="stacktrace" layout="${stacktrace:topFrames=10}" />
              <attribute name="exception" layout="${exception:format=ToString}"/>
       </layout>
</target>
{% endhighlight %}


### LoggingRule final behavior (**breaking change**)

The behavior of the final attribute has been changed. Example:

{% highlight csharp %}
<logger name="logger1" level="Debug"  final=”true”  />
{% endhighlight %}

Before 4.0 it would mark _all_ messages from the logger “logger1” as final. In 4.0 it would only mark the _debug_ messages as final. 

### Added Eventlog.EntryType

When writing to the Eventlogger, NLog would write to `Information`, `Warning` or `Error` entrytype, depending on the level. This is now layoutable and gives the opportunity to write also a `FailureAudit` or `SuccessAudit` and/or use it with conditions.

### Other

* The `EventLogTarget.Source` now accepts layout-renderers. But beware that the layout renderers can be used when in- or uninstalling the target. 
*	The `Console`- and `ColorConsole` target has an `encoding` property.
*	The application domain layout renderer has been added. Examples: `${appdomain}`, `${appdomain:format=short}` or `${appdomain:format=long}`.
*	Added `CallSiteLineNumber` layout renderer. usage: `${callsite-linenumber}`
*	Added `SkipFrames` option to the `Stacktrace` layout renderer
*	The `WebserviceTarget` has the option `IncludeBOM`. Possible options: 
  *	`null`: don't change BOM.
  *	`true`: always include UTF-8 BOM UTF-8 encodings.
  *	`false`: **default**, always skip BOM on UTF-8 encodings.
*	`FileTarget` uses time from the current `TimeSource` for date-based archiving. #512
*	Multicast with the `LogReceiverTarget` is now possible
*	The `Mailtarget` has now less required parameters. (at least To, CC or BCC should be set) and the `Mailtarget` logs their errors correctly to the internal logger now. 
* The `Counter.Sequence` now accepts layout renderers.

##Bug fixes

More than 30 bugs are solved. The full list can be seen on [Github](https://github.com/NLog/NLog/issues?utf8=%E2%9C%93&q=milestone%3A4.0+is%3Aclosed+label%3Abug).

The most noticeable bugs:

*	The default value of `DatabaseTarget.CommandType` could lead to exceptions
*	If the XML was broken (invalid), autoreload would be disabled - the application needed a restart before reading the changed config.  This has been fixed.
*	The `Logmanager.GetCurrentClassLogger` was not thread-safe and with many concurrent calls it would throw an exception.
*	Various fixes to the archiving of files.
*	Bugfix: `WebserviceTarget` wrote encoded UTF-8 preamble.


##Breaking changes

NLog 4.0 has some breaking changes. To sum up:

*	`LoggingRule.Final` behaviour has been changed.
*	The methods of logging exception data has been changed.
*	The webservice target won't write a BOM with UTF-8 (default, can be set)
* All properties that has been changed to accept layout renderers. 

##Wiki
Please note that the wiki isn't updated yet.


