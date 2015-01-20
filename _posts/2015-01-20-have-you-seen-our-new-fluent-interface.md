---
layout: post
title: Have you seen our new fluent interface? (3.2.0 feature)
---

With the release of 3.2.0 a new [fluent interface](https://en.wikipedia.org/wiki/Fluent_interface) has also been  introduced. 
This feature simplifies writing complex logging statements and can be extended with [extension methods](http://msdn.microsoft.com/en-us//library/bb383977.aspx).

{% highlight csharp %}
var logger = LogManager.GetCurrentClassLogger();
logger.Info()
    .Message("This is a test fluent message '{0}'.", DateTime.Now.Ticks)
    .Property("Test", "InfoWrite")
    .Write();
{% endhighlight %}

To start with the fluent interface:

1. Import the namespace `NLog.Fluent`
2. Create a `Logger` as regular
3. Start the fluent interface with `logger.Log(LogLevel...)`, `logger.Debug()`, `logger.Error()` etc.
4. Use the fluent interface
5. Finish the chain with `.Write()`

Full example
---

{% highlight csharp %}
using System;
using NLog;
using NLog.Fluent;

class Program
{
    void Test()
    {
        var logger = LogManager.GetCurrentClassLogger();

        try
        {
            //ex 1
            logger.Info()
                .Property("id", 123)
                .Property("category", "test")
                .Write();
            DoCrash();
        }
        catch (Exception ex)
        {
            //ex 2
            logger.Log(LogLevel.Error)
                  .Exception(ex)
                  .Message("log a message with {0} parameter", 1).Write();
            throw;
        }
    }

    private static void DoCrash()
    {
        //..
    }
}

{% endhighlight %}

