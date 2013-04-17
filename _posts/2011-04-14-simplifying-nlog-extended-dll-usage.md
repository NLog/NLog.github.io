---
layout: post
title: Simplifying NLog.Extended.dll usage
---

I'd like to let you know about small simplification to using targets and layout renderers from NLog.Extended.dll. Previously you had to register them using configuration section:

{% highlight xml %}
<extensions>
  <add assembly="NLog.Extended" />
</extensions>
{% endhighlight %}

Starting with today's Nightly build, this is no longer required - you can simply use extended items without extra registration (exactly like it worked in NLog 1.0). The only change is that you must have NLog.Extended.dll in the same directory as NLog.dll - you will get exception if it's not present.

If you need NLog.Extended, please [give this feature a try](http://nlog-project.org/download) and report any issues you find.