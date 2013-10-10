---
layout: post
title: NLog 2.1 has been released
excerpt: NLog 2.1 has been released
---

After a long wait NLog 2.1 has finally been released. Bugs have been fixed and a lot of improvements and new features has been added.

### Better support for Partial Trust
FileTarget now uses the managed implementation as a fallback if running under Partial Trust, as calls to unmanaged code is not allowed in Partial Trust. Also assemblies has been marked with the AllowPartiallyTrustedCallers attribute to allow NLog to be called from assemblies running under Partial Trust.

### Pluggable time sources
Thanks to Robert Vazan NLog now has pluggable time sources, which allows you to control timestamp precision. He has written two excellent blog posts about this feature, see [How to configure NLog time source](http://blog.angeloflogic.com/2013/10/how-to-configure-nlog-time-source.html) and [How to write custom NLog time source](http://blog.angeloflogic.com/2013/10/how-to-write-custom-nlog-time-source.html).

You can control the timestamp precision in the configuration file like this:

{% highlight xml %}
<nlog>
    <time type='AccurateLocal' />
    ...
</nlog>
{% endhighlight %}

### Date Based File Archiving
Historically NLog hasn't been very good at archiving files base on date, but thanks to [mkaltner](https://github.com/mkaltner) this have changed.

He has introduced a archive numbering mode for dates, and a new setting on the file target to set the date format in the log file. These changes allow you to control how logs are archived based on date. The date based file archiving could be configued like this:

{% highlight xml %}
<target xsi:type="File"
	archiveEvery="Minute"
	archiveFileName="logs/NLogTest.{#}.log"
	archiveNumbering="Date"
	archiveDateFormat="yyyyMMddHHmm"
	...
/>
{% endhighlight %}

### AppSettings layout renderer
Thanks to [Mario Pareja](https://github.com/mpareja) a new layout renderer has been taken implemented in NLog. The new layout renderer inserts content based on the application configuration. The renderer can be used in any layout like this, where name is the configuration key:

{% highlight xml %}
<target xsi:type="File"
	layout="${appsetting:name=appSettingKey}"
	...
/>
{% endhighlight %}


### Easier way to disable logger rules
To disable logger rules in earlier versions of NLog you would have to either remove or comment out the rule, but sometimes you would like an easiere way to do this. In this version of NLog a new attribute has been added:

{% highlight xml %}
<logger enabled="false"
	...
/>
{% endhighlight %}

### Other changes
Of course other changes have made it in to this release, see the full change log at [Github](https://github.com/NLog/NLog/issues?milestone=2&state=closed)