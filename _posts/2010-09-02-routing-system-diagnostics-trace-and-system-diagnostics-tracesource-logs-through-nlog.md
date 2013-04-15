---
layout: post
title: Routing System.Diagnostics.Trace and System.Diagnostics.TraceSource logs through NLog
---

I have recently added a trace listener class for NLog, which enables routing of System.Diagnostics.Trace and System.Diagnostics.TraceSource logs through your favorite log routing engine. This can be very useful for integrating components that don’t necessarily support logging through NLog as well as analyzing traces produced .NET Framework itself.

By using NLog trace listener you can send those logs via [email](https://github.com/NLog/NLog/wiki/Mail-target), save them to a [database](https://github.com/NLog/NLog/wiki/Database-target), [file](https://github.com/NLog/NLog/wiki/File-target) or to any other supported log [targets](https://github.com/NLog/NLog/wiki/Targets).

Let’s create a simple example – application that makes network call. We will then enable network call tracing without touching a single line of code.

{% highlight csharp %}
namespace TraceDemo 
{ 
  using System.Net; 

  class Program 
  { 
    static void Main(string[] args) 
    { 
      var webClient = new WebClient(); 
      webClient.DownloadString("http://somehost/nosuchfile.txt"); 
    } 
  } 
}
{% endhighlight %}

As you can see the example is just using WebClient from System.Net namespace, and has no tracing-specific code. Internally WebClient is capable of outputting traces through **System.Net** trace source. To route those traces through NLog you need to assign a listener to each source in the application configuration file. It is convenient to define NLogTraceListener as a shared listener and reference by name in all sources that you need as in the following example:

{% highlight xml %}
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <system.diagnostics>
    <sources>
      <source name="System.Net" switchValue="All">
        <listeners>
          <add name="nlog" />
        </listeners>
      </source>
      <source name="System.Net.Sockets" switchValue="All">
        <listeners>
          <add name="nlog" />
        </listeners>
      </source>
    </sources>
    <sharedListeners>
      <add name="nlog" type="NLog.NLogTraceListener, NLog" />
    </sharedListeners>
  </system.diagnostics>
</configuration>
{% endhighlight %}

Obviously you also need NLog.dll and [NLog.config](https://github.com/NLog/NLog/wiki/Configuration-file) to be located in the application directory. For our purposes we’ll use simple configuration with single target:

{% highlight xml %}
<nlog>
  <targets>
    <target name="console" type="ColoredConsole" layout="${longdate} ${windows-identity} ${message}" />
  </targets>

  <rules>
    <logger name="*" minlevel="Trace" writeTo="console" />
  </rules>
</nlog>
{% endhighlight %}

When you run this application, you will get nice color-coded trace that includes lots of diagnostics information straight from the guts of .NET Framework. Having access to detailed trace like this can be very helpful in diagnosing hard-to-reproduce problems that are often impossible to figure out with a debugger.

<img src="/images/posts/2010/09/image_thumb1.png">