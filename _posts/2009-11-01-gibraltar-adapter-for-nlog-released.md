---
layout: post
title: Gibraltar adapter for NLog released
---

The [Gibraltar Adapter for NLog](http://www.gibraltarsoftware.com/see/NLog.aspx) provides log management and analysis for NLog data. With Gibraltar you can easily send logs from your applications to a central location where they can be analyzed in [Gibraltar](http://www.gibraltarsoftware.com/see/NLog.aspx) Analyst.

If you are need a powerful log analyzer for NLog that goes beyond simple filtering and grouping and can scale as your application grows, you should check out Gibraltar.

I found this tool to be a really awesome complement to NLog. The guys behind Gibraltar were generous enough to offer me a commission if any NLog users buy their tool. So, check it out, and if you like it and decide to buy it, you'll be supporting NLog development too, which I'd be grateful for.

Configuring the adapter
-----------------------
Integrating the adapter into your application is trivial and can be done without even having to recompile it. If you want to route all your logs through Gibraltar all you have to do is put the following XML in your NLog.config:

<pre>
&lt;nlog&gt;
  &lt;extensions&gt;
    &lt;add assembly="Gibraltar.Agent.NLog" /&gt;
  &lt;/extensions&gt;
  &lt;targets&gt;
    &lt;target name="Gibraltar" xsi:type="Gibraltar" /&gt;
  &lt;/targets&gt;
  &lt;rules&gt;
    &lt;logger name="*" minlevel="Trace" writeTo="Gibraltar" /&gt;
  &lt;/rules&gt;
&lt;/nlog&gt;
</pre>
If you prefer not to ship the configuration file, just add this code to your Main() method instead:

<pre>
NLog.Config.SimpleConfigurator.ConfigureForTargetLogging(NLog.LogLevel.Trace,
    new Gibraltar.Agent.NLog.GibraltarTarget());
</pre>