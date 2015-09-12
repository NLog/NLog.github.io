---
layout: post
title: NLog 4.1.1 has been released!
---

We just released a new version of NLog which fixes a few issues in NLog 4.1.0.

##Features

- MDLC now also support objects, like MDC,GDC and NDC (those were added in 4.1.0)

##Bug fixes:
- NLog won't crash if there are binaries starting with "nlog" that we can't load (those were loaded by the auto load feature)
- Directory was required with the internal logger
- Fixed assembly name issue with strong name. With the release of NLog 4.1.0 we made a mistake with the full name. 
We changed the version in it to 4.1.0.0, but because of the strong naming, we should keep it 4.0.0.0. 
This the curse of strong naming, and at least in NLog 4 we should live with it. 

In the NLog 4.1.1, the full name is the same as NLog 4.0.0 and 4.0.1.

If nuget is adding the following to your (main) .config:

{% highlight xml %}
<dependentAssembly>
  <assemblyIdentity name="NLog" publicKeyToken="5120e14c03d0593c" culture="neutral" />
  <bindingRedirect oldVersion="0.0.0.0-4.1.0.0" newVersion="4.1.0.0" />
</dependentAssembly>
{% endhighlight %}

You should remove it, or change it to:

{% highlight xml %}
<dependentAssembly>
  <assemblyIdentity name="NLog" publicKeyToken="5120e14c03d0593c" culture="neutral" />
  <bindingRedirect oldVersion="0.0.0.0-4.1.0.0" newVersion="4.0.0.0" />
</dependentAssembly>
{% endhighlight %}

- If you use other libraries build on NLog 3, 4.1.0 or before: change it
- If you don't use other libraries build on NLog, or those are build on NLog 4.x (expected 4.1.0), remove it

We are sorry if the upgrade to 4.1.0 gave issues. 
We are aware that the strong naming is sometimes gives more issues than solving things and 
that versioning issues with strong naming are common. 
But some users need the strong name, and so we keep it for at least version 4.


##Other:
- Obsolete text fixed
- Removed some unused classes (moved to NLog.Windows.Forms before)


Download it from [nuget](https://www.nuget.org/packages/NLog/)!
