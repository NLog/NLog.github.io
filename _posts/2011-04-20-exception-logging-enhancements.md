---
layout: post
title: Exception logging enhancements
---

One of the frequent feature requests I've been getting was to improve the way exceptions are logged. Recent builds of NLog 2.0 include several usability enhancements that should make working with exceptions much easier.

Conditional formatting
----------------------
Conditional logging allows you to make your layouts somewhat more dynamic - you can include/exclude fields based on conditions, provide default values and so on. In order to achieve this, you have 3 new layout renderers at your disposal.

**${onexception:INNER} -  output**

To render a layout when the exception is being logged, use **${onexception:INNER}**, it will output INNER only when current log event includes an exception (in other words when it was emitted using any of the Logger.\*Exception() methods. INNER can include other layouts, for example:

{% highlight xml %}
<targets>
  <target name="f" type="File" layout="${message}${onexception:EXCEPTION OCCURRED\:${exception:format=tostring}}" />
</targets>
{% endhighlight %}

It will output log message, but in case of exception, it will also log detailed exception information prefixed with "EXCEPTION OCCURRED:".

**${when} - advanced conditional formatting**

You can also conditionally include or exclude layout renderers based on conditions by using **${when}** layout renderer wrapper. You can even use ambient property called "when" as if it were declared on any other layout renderer:

For example **${message:when=logger=='logger'}** will only print the message when it was emitted by 'logger'. The conditions can be much more complex - you have the full power of conditions language at your disposal.

**${whenEmpty} - empty value coalescing**

Sometimes you may want to print an indication that a layout renderer has produced an empty value, instead of completely skipping its output. That's where **${whenEmpty}** layout renderer wrapper comes in handy. You can also use the ambient property form, just by using 'whenEmpty' property in any other layout renderer. For example:

**${message:whenEmpty=(no message)}**

Inner exception logging
-----------------------
Recent builds also include improvements to **${exception}** layout renderer which now lets you output inner exceptions. There are several new properties:

 * **${exception:maxInnerExceptionLevel=N}** -  controls how many inner exceptions are logged. defaults to zero for backwards compatibility.
 * **${exception:innerExceptionSeparator=TEXT}** - defines text that separates inner exceptions. Defaults to new line string (platform specific).
 * **${exception:innerFormat=FORMATSTRING}** - defines the format of inner exceptions the same way that **${exception:format=FORMATSTRING}** defines the format of the top-level exception. If this parameter is not specified, the same format is used for both top-level and inner exceptions.

A complete usage example is:

{% highlight xml %}
<targets>
  <target name="f" type="File" layout="${message}${onexception:EXCEPTION OCCURRED\:${exception:format=type,message,method:maxInnerExceptionLevel=5:innerFormat=shortType,message,method}}" />
</targets>
{% endhighlight %}

This will print top-level exception with full type name, message and method that raised the exception, but for inner exceptions only short type name is used instead.

As always, comments and suggestions are welcome.