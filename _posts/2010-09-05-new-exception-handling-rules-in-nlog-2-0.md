---
layout: post
title: New exception handling rules in NLog 2.0
---

NLog will introduce a change to logging exception handling and suppression. In NLog 1.0 all exceptions were disabled by default, but could be enabled by setting

{% highlight xml %}
<nlog throwExceptions="true">

</nlog>
{% endhighlight %}

or in code:

{% highlight csharp %}
LogManager.ThrowExceptions = true;
{% endhighlight %}

This flag applied to configuration errors as well as runtime errors, which was problematic, because a simple configuration file typo could cause entire logging to be disabled silently.

To address this, NLog 2.0 will treat configuration errors separately from runtime errors. There will be two kinds of exceptions:

 1. Configuration exceptions - raised during parsing of [configuration file](https://github.com/NLog/NLog/wiki/Configuration-file) and wrapped in **NLogConfigurationException**. Such errors are fatal and will prevent your application from starting (this is the same as having malformed App.config or Web.config). The errors that cause this exception are:
  * syntax errors in NLog.config
  * invalid target names
  * invalid property names
  * invalid property values
 2. Runtime exceptions (such as permission issues, connection failures, etc.) - raised during logging and initialization and wrapped in **NLogRuntimeException**. They can be controlled by **throwExceptions** flag.

I would love to hear your comments.