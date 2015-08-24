---
layout: post
title: NLog 4.1 has been released. 
---

A new version of NLog is released! 

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

In 4.1 you can use the `var` layout renderer:

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

What's the real benefit here?

- It's more in line with NLog
- You can change, delete and create variables from the API
- We can set a default value on an variable, e.g. `${var:password:default=unknown}`
- The old variables can still be used and so this is fully backwards compatible.

Maybe you ask yourself: why is the old method not replaced? Well the new method works one on `Layouts` and not on plain `strings`. 



###  Object values for GDC, MDC and NDC contexts
The context classes, GCD, MCD and NDC, now supports using `object` values instead of `strings`. This is mostly beneficial from the API perspective. 

The `get` method still returns a `string` - for backwards compatibility reasons. We created a new method `getObject`. 


###Easier move from NLog 3 to NLog 4
With the release of NLog 4.0 we made some breaking changes. Those breaking changes made upgrading an issue: all the code have to be upgraded to NLog 4 at once.


