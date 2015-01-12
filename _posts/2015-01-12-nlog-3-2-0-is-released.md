---
layout: post
title: NLog 3.2.0 has been released
excerpt: NLog 3.2.0 has been released
---

NLog 3.2.0 has been released, and is available at [NuGet](https://www.nuget.org/packages/NLog/ "NuGet - NLog"), 
the binaries are available at [GitHub release page](https://github.com/NLog/NLog/releases/tag/v3.2.0 "GitHub release page").

This release contains mostly bug fixes, but also a couple of enhancements and new features.

Features
========

Support for blacklisted assemblies
-----------------------------
NLog assemblies are by default skippe, when the calling method is determined, using the callsite renderer. This release adds support for manually specifing other assemblies which should be skipped. This is done by setting the assemblies to be skipped like this:
{% highlight csharp %}
LogManager.HiddenAssemblies = new Assembly[] { Assembly.GetExecutingAssembly(), Assembly.GetEntryAssembly() };
{% endhighlight %}

Archive files by date and sequence
----------------------------------
A new ArchiveNumberMode have been íntroduce for the File target. It is called DateAndSequence and can be set like this:
{% highlight xml %}
<target type='File' archiveNumberMode='DateAndSequence' ...>
{% endhighlight %}
As the name says, it "numbers" the archive using both date and sequence number.

Archive old file on startup
---------------------------
A new attribute called archiveOldFileOnStartup has been added to the File target. It allow users to define if an existing old file should be archive every time the application starts. It can be set like this:
{% highlight xml %}
<target type='File' archiveOldFileOnStartup='true' ...>
{% endhighlight %}

Programmatic access to variable defined in configuration file
---------------------------------------------------------
It is now possible to access variable defined in configuration files like this:
{% highlight csharp %}
LogManager.Configuration.Variables
{% endhighlight %}
This allows users to add and remove as needed programatically, but please remember that layouts may be cached, meaning that changes to variables may not be shown.
