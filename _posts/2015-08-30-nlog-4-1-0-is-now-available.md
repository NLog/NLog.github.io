---
layout: post
title: NLog 4.1 is Now Available!
---

A new version of NLog has been released! 

We fixed around 25 bugs, added some new features and made the migration of NLog 3 to 4 easier. 
The release can be downloaded from [NuGet](https://www.nuget.org/packages/NLog/4.1.0). 

Check for all the details the [GitHub 4.1 milestone](https://github.com/NLog/NLog/issues?q=milestone%3A4.1+is%3Aclosed). 

##Features

This release contains the following features:



###Overhaul variables 

Since 4.0 you can read the variables defined in the configuration file. We also claimed you could change the values, but we were wrong...
The variables where implemented like a kind of macros and changing them would not give the expected results. 

In NLog 4.1, we created a new method to render the variables, which fits a lot better in the NLog library: 
we created a layout renderer for the variables! With the same syntax you can define the variables, but rendering is a bit different. 


In NLog 4.0 you would define:


{% highlight xml %}
<nlog>
  <variable name='user' value='admin' />
  <variable name='password' value='realgoodpassword' />
            
  <targets>
    <target name='debug' type='Debug' layout='${message} and ${user}=${password}' />
  </targets>
  <rules>
    <logger name='*' minlevel='Debug' writeTo='debug' />
  </rules>
</nlog>
{% endhighlight %}

In 4.1 you can use the `$var{}` layout renderer:

{% highlight xml %}
<nlog>
  <variable name='user' value='admin' />
  <variable name='password' value='realgoodpassword' />
            
  <targets>
    <target name='debug' type='Debug' layout='${message} and ${var:user}=${var:password}' />
  </targets>
  <rules>
    <logger name='*' minlevel='Debug' writeTo='debug' />
  </rules>
</nlog>
{% endhighlight %}

What's the real advantage here?

- It is in line with NLog's current code
- Variables can be changed, deleted and created from the API
- A default value can be configured for a variable, e.g. `${var:password:default=unknown}`
- The old variables can still be used and so this is completely backwards-compatible.

You might wonder: why has the old method not been replaced? The answer is simple: the new method only works on `Layout` types and not on plain `strings`. 



###  Object values for GDC, MDC and NDC contexts
The context classes, GCD, MCD and NDC, now support using `object` values instead of `strings`. This is mostly beneficial from the API perspective. 

The `get` method still returns a `string` - for backwards-compatibility reasons. We created a new method: `getObject`. 

When writing to the logs, the `object` is converted to a `string`

  {% highlight C# %}
GlobalDiagnosticsContext.Set("myDataBase","someValue"); //already possible
GlobalDiagnosticsContext.Set("myDataBaseNumber",2); //4.1+
 {% endhighlight %}


###Easier upgrade from NLog 3 to NLog 4
With [the release of NLog 4.0](http://nlog-project.org/2015/06/09/nlog-4-has-been-released.html) we made some breaking changes. Those breaking changes made upgrading an issue: all the code has to be upgraded to NLog 4 at once.

The main cause was the change of behavior of `Log(string message, Exception ex)`. This call should be replaced by `Log(Exception ex, string message)` in NLog 4.0.

Changing all those calls can be difficult at once. So we have introduced the following option:

  {% highlight xml %}
<nlog exceptionLoggingOldStyle='true'>
  {% endhighlight %}

With this option enabled, you can still use `Log(string message, Exception ex)` in NLog 4. 

So the upgrade path to NLog 4

1. Enable "exceptionLoggingOldStyle" in the configuration
2. Upgrade to NLog 4.1+
3. (this can take some time): replace the calls to `Log(string message, Exception ex)` etc.
4. Disable "exceptionLoggingOldStyle"  in the configuration

Note: we will remove this feature in NLog 5.0


###New JSON options
New options have been added for writing JSON output. 
 
 - More control over spaces: SuppressSpaces. Example:
 
{% highlight xml %}
<layout xsi:type="JsonLayout" SuppressSpaces="false">
  <attribute name="process_name" layout="${processname}" />
  <attribute name="short_message" layout="${message}" />
</layout>
{% endhighlight %}
 - The JSON encoding can be disabled for properties. 
 
{% highlight xml %}
<layout xsi:type="JsonLayout">
    <attribute name="Message" layout="${message}" encode="false"/>
</layout>
{% endhighlight %}
Example call:

{% highlight c# %}
logger.Info("{ \"hello\" : \"world\" }");
{% endhighlight %}

See [the wiki](https://github.com/NLog/NLog/wiki/JsonLayout)

###Integrated NLog.Contrib to core
The NLog.Contrib code has been integrated with the core of NLog. 
The following features are now available on the NLog package:

-  Mapped Diagnostics Context (MDLC): Async version of Mapped Diagnostics Context  Allows for maintaining state across
  asynchronous tasks and call contexts.
- The Mapped Diagnostics Context Layout renderer: `${mdlc}`
- Trace Activity Id Layout Renderer: `${activityid}` write the `System.Diagnostics` his trace correlation id.


###All events layout renderer: optional writing of caller information. 
The all events layout renderer introduced in NLog 4.0 was unexpectedly writing [caller information](https://msdn.microsoft.com/en-us/library/hh534540.aspx), like current method etc, to the targets. This is now an option and disabled by default. 

For example:

- ` ${all-event-properties}` writes "Test=InfoWrite, coolness=200%, a=not b"
- ` ${all-event-properties:includeCallerInformation=true}` writes "Test=InfoWrite, coolness=200%, a=not b, CallerMemberName=foo, CallerFilePath=c:/test/log.cs, CallerLineNumber=1001"

###Call site line number layout renderer
Officially introduced in NLog 4.0, but was not available due to a merge fault. The `${callsite-linenumber}`  writes the line number of the caller. 

###Easy replacement of newlines
With the `${replace}` layout renderer it was already possible to replace the newlines, but it was a bit tricky to use - different systems, different newlines.

The `${replace-newlines}` layout renderer fixes this.

###WCF Log Receiver Changes
4.0.0 introduced an unattended breaking changing that replaced the `WcfLogReceiverClient` with the `WcfLogReceiverClientFacade` (NLog/NLog#783). It was not only a naming issue, but also some functionality was lost and there was a lot of code duplication.

Unfortunately, there was not an easy fix, so the following was done to try to make it _less_ of a breaking change. The changes are still breaking, but minus a recompilation, the changes should be mostly transparent. See NLog/NLog#874 for all of the changes related to WCF Log Receiver.

####Changes from 3.2.1
Compared to 3.2.x, these the changes:

-  Use `ILogReceiverTwoWayClient` instead of `ILogReceiverClient`. `ILogReceiverClient` is still in the code, but is marked obsolete.
- If your code is dependent on `ClientBase`, then change it to `WcfLogReceiverClientBase`


####Changes from 4.0.0
Compared to 4.0.x, these the changes:

- The return type for the method `CreateWcfLogReceiverClient()` in `LogReceiverWebServiceTarget` is `WcfLogReceiverClient` again, but is marked obsolete.
- Use `CreateLogReceiver()`, which returns `IWcfLogReceiverClient` to reduce breaking changes in the future.

##Event properties - culture and format options 
The event properties are `object` values. When writing them with  `${event-properties}`  to the logs, the values are converted to `strings`. It's now possible to control the culture and format. 

Examples: `${event-properties:prop1:format=yyyy-M-dd}` and `${event-properties:aaa:culture=nl-NL}`

##Bugs
Various bugs are fixed in this version. The most notable ones:

###UNC path issues
4.0.1 did gave issues with configuration files or binaries hosted on UNC locations.

###Fixes in file archiving
Multiple bugs are fixed with file archiving:

- Archive files where sometimes deleted in the wrong order.
- `DeleteOldDateArchive` could delete files not being actual archives. [#847](https://github.com/NLog/NLog/issues/847)

###Fixed Mono build
This release finally builds again on Mono! We are busy adding Travis CI integration to keep the Mono build working. 



###Exception is not correctly logged when calling without message
Writing an exception as only argument to a logger, like `logger.Info(new Exception())` was not correctly registering the exception to the log messages.  

###Internal logger improvements
Some small improved has been made to the internal logger. 

