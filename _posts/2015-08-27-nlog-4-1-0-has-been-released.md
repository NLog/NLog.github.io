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

In NLog 4.1 we created a new method to render the variables, which fits a lot better in the NLog library: 
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


###Easier upgrade from NLog 3 to NLog 4
With the release of NLog 4.0 we made some breaking changes. Those breaking changes made upgrading an issue: all the code has to be upgraded to NLog 4 at once.

###new JSON options
New options have been added for writing JSON output. 
 
 - More control over spaces: SuppressSpaces. Example:
 
  {% highlight xml %}
  <layout xsi:type="JsonLayout" SuppressSpaces="false">
    <attribute name="process_name" layout="${processname}" />
    <attribute name="short_message" layout="${message}" />
  </layout>
  {% endhighlight %}
 - The JSON encoding can be disabled for properties. 
 
```xml
    <layout xsi:type="JsonLayout">
        <attribute name="Message" layout="${message}" encode="false"/>
    </layout>
```
Example call:

```c#
logger.Info("{ \"hello\" : \"world\" }");
```


###Integrated NLog.Contrib to core
The NLog.Contrib code has been integrated with the core of NLog. 
The following features are now available on the NLog package:

-  Mapped Diagnostics Context (MDLC): Async version of Mapped Diagnostics Context  Allows for maintaining state across
  asynchronous tasks and call contexts.
- The Mapped Diagnostics Contextt Layout renderer: `${mdlc}`
- Trace Activity Id Layout Renderer: `${activityid}` write the `System.Diagnostics` his trace correlation id.


###All events layout renderer: added `IncludeCallerInformation` option
The all events layout renderer introduced in NLog 4.0 

TODO

```
   <target type='file'  name='f'layout='${message} ${all-event-properties:IncludeCallerInformation=true}
```


###Call site line number layout renderer


###replace-newlines layout renderer
`replace-newlines`


###log reciever compatiblty

##Bugs


###UNC path issues

###Fixes in file archiving
- Archive files delete right order 
- DeleteOldDateArchive could delete files not being actual archives. [#850]

###Fixed Mono build

###Position of `<extensions>`

###Logger.log(Exception)

###Internal logger improvements
###${event-properties} - Added culture and format properties 
 
