---
layout: post
title: NLog 4.0 has been released. 
---

NLog 4.0 has been released! 
More than 100 issues are [closed in GitHub](https://github.com/NLog/NLog/issues?q=milestone%3A4.0+is%3Aclosed). 
The release can be downloaded from [NuGet](https://www.nuget.org/packages/NLog/4.0.0). 

We had a small delay (less than a week) on releasing this version. 
We underestimated the need for a release candidate and the time needed for documenting a changes on the [wiki](https://github.com/nlog/nlog/wiki) .

Thanks again for the reported issues and requested features!

This post is almost identical to the [release candidatie news post](http://nlog-project.org/2015/05/28/nlog-4-release-candidate.html)



## Split of the package NLog.Extended to NLog.Web and NLog.Windows.Forms
With the release of NLog 4.0 we have split the package [NLog.Extended](https://www.nuget.org/packages/NLog.Extended/) to [NLog.Web](https://www.nuget.org/packages/NLog.Web/) and [NLog.Windows.Forms](https://www.nuget.org/packages/NLog.Windows.Forms/). 
This will give us the opportunity to clean up the references in NLog.Extended. 
There are also some targets and layout renderers still in NLog.Extended, we will also create new packages for those in the future.

The [wiki](https://github.com/nlog/nlog/wiki/Targets) has been updated to make more clear which [Targets](https://github.com/nlog/nlog/wiki/Targets) and which [Layout Renderers](https://github.com/nlog/nlog/wiki/Layout-Renderers) are in each package.

For more information, see the [NLog.Extended news post](http://nlog-project.org/2015/06/13/NLog-Extended_NLog-Web_and_NLog-Windows-Forms.html)

## Features

This release contains the following features:



### Zipped file archives (.Net 4.5 and higher)

The `FileTarget` can now compress the archived files to zip format. 
Example: set `EnableArchiveFileCompression` in config file:

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

Because we use the standard stuff of .Net for this, it's only available in .Net 4.5 and higher.

### Consistent logging of exceptions (**breaking change**)

Logging of exceptions is now more consistent and complete than before. This is a breaking change.
All the logger methods, such as `.Debug`, `Error` etc. now contains a first optional parameter of the type `Exception`. 
Only this parameter would be written as `Exception` to the log and can be used in the layout renderer, for example `${exception:format=tostring}`. 

#### Changes:

*	All "exception" methods starts with `Exception` parameter. E.g. `Error(Exception exception, string message, params object[] args)`.
*	All "exception" methods have a 'args' as parameter for formatting the message.
*	All "exception" methods have an overload with an `IFormatProvider` as parameter.

Changes that are not backwards-compatible:

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

### Conditional logging

In extreme cases logging could affect the performance of your application. There is a small overhead when writing a lot of log messages, like Tracing.
In this case it’s now possible to only include the `Trace` and `Debug` call with a debug release. 
Instead of:

{% highlight csharp %}
Logger.Trace("entering method {0}", methodname);
{% endhighlight %}

Use:

{% highlight csharp %}
Logger.ConditionalTrace("entering method {0}", methodname);
{% endhighlight %}

This call will be removed by the .Net compiler if the DEBUG conditional compilation symbol is not set – default on a release build.

### Auto load extensions

Assemblies with the name "NLog*.dll", like "NLog.CustomTarget.dll" are now loaded automatically. This assembly should be in the same folder as NLog.dll.
Of course you can load NLog extensions manually with the [`<Extensions>` config]( https://github.com/nlog/nlog/wiki/How-to-write-a-Target#how-to-use-the-newly-created-target)

### AllEventProperties layout renderer

A new layout renderer which outputs all of the event's properties. Format and separator can be manually configured.
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

* In case of `${all-event-properties}` this would produce: `Test=InfoWrite, coolness=200%, a=not b`
* In case of `${all-event-properties:Format=[key] is [value]}` this would produce: `Test is InfoWrite, coolness is 200%, a is not b`


### Writing to JSON

A new layout that renders log events as structured JSON documents.
Example:

{% highlight csharp %}
<target name="jsonFile" xsi:type="File" fileName="${logFileNamePrefix}.json">
      <layout xsi:type="JsonLayout">
              <attribute name="time" layout="${longdate}" />
              <attribute name="level" layout="${level:upperCase=true}"/>
              <attribute name="message" layout="${message}" />
       </layout>
</target>
{% endhighlight %}

would write: `{ "time": "2010-01-01 12:34:56.0000", "level": "ERROR", "message": "hello, world" }`

#### Notes:

* Currently the layout will always create an non-nested object with properties.
* Also there is no way to prevent escaping of the values (e.g. writing custom JSON as value)
* The JSON will be written on one line, so no newlines. 

### Improved loggingRule final behavior (**breaking change**)

The behavior of the final attribute has been changed. Example:

{% highlight csharp %}
<logger name="logger1" level="Debug"  final=true  />
{% endhighlight %}

Before 4.0 it would mark _all_ messages from the logger “logger1” as final. In 4.0 it will only mark the _debug_ messages as final. 

### Added Eventlog.EntryType

When writing to the Eventlogger, NLog would writes to `Information`, `Warning` or `Error` entrytype, depending on the level. This is now configurable (with layout renderes) and offers the opportunity to write also a `FailureAudit` or `SuccessAudit` and/or use it with conditions.

### Other

* The `EventLogTarget.Source` now accepts layout-renderers. Note: layout renderers can not be used when in- or uninstalling the target. 
*	The `Console`- and `ColorConsole` target has an `encoding` property.
*	The application domain layout renderer has been added. Examples: `${appdomain}`, `${appdomain:format=short}` or `${appdomain:format=long}`.
*	Added `CallSiteLineNumber` layout renderer. usage: `${callsite-linenumber}`
*	Added `SkipFrames` option to the `Stacktrace` layout renderer
*	The `WebserviceTarget` has the option `IncludeBOM`. Possible options: 
    *	`null`: doesn't change BOM.
    *	`true`: always include UTF-8 BOM UTF-8 encodings.
    *	`false`: **default**, always skip BOM on UTF-8 encodings.
*	`FileTarget` uses time from the current `TimeSource` for date-based archiving. 
*	Multicast with the `LogReceiverTarget` is now possible
*	The `Mailtarget` has less required parameters (at least To, CC or BCC should be set) and the `Mailtarget` logs their errors correctly to the internal logger now. 
* The `Counter.Sequence` now accepts layout renderers.

## Bug fixes

Over 30 bugs has been solved. The full list can be viewed on  [Github](https://github.com/NLog/NLog/issues?utf8=%E2%9C%93&q=milestone%3A4.0+is%3Aclosed+label%3Abug).

The most noticeable bugs:

*	The default value of `DatabaseTarget.CommandType` could lead to exceptions
*	If the XML was broken (invalid), auto reload would be disabled - the application needed a restart before reading the changed configuration.  
*	The `Logmanager.GetCurrentClassLogger` was not thread-safe and with many concurrent calls it would throw an exception.
*	Various fixes to the archiving of files.
*	Bugfix: `WebserviceTarget` wrote encoded UTF-8 preamble.


## Breaking changes

NLog 4.0 has some breaking changes. To sum up:

*	`LoggingRule.Final` behaviour has been changed.
*	The methods of logging exception data has been changed.
*	The webservice target won't write a BOM with UTF-8 (default, can be set)
* All properties that have been changed to accept layout renderers. 




