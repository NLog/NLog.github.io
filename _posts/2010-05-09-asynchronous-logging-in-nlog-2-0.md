---
layout: post
title: Asynchronous logging in NLog 2.0
---

NLog 1.0 supports [asynchronous logging](https://github.com/NLog/NLog/wiki/AsyncWrapper-target), but there is no good support for asynchronous exception handling. This is because wrappers targets are not capable of receiving exceptions which are raised on other threads.

Since NLog 2.0 is going to support Silverlight where entire networking stack is completely asynchronous, it is critical to enable wrappers for those scenarios. Without it some important wrapper-based features, such as load balancing or failover would not work properly.

This post will present new APIs to support asynchronous logging features that are coming in the next release of NLog.

Exception Handling in NLog 1.0
------------------------------
NLog 1.0 uses very simple, synchronous exception handling pattern:

{% highlight csharp %}
try
{
    // do something
}
catch (Exception ex)
{
    // handle exception
}
{% endhighlight %}

The problem arises if the code block inside try { } clause performs an asynchronous operation such as network call which may result in an exception, as in the following example:

{% highlight csharp %}
try
{
    WebClient client = new WebClient();
    client.DownloadStringCompleted += (sender, e) =>
    {
        // this event will be raised asynchronously
        // on another thread, long after try/catch block completes
 
        // any exceptions raised here will not be handled by the catch {} block below
    }

    client.DownloadStringAsync(new Uri("http://example.com"));
}
catch (Exception ex)
{
    // handle exception
}
{% endhighlight %}

NLog cannot handle exceptions in such cases, since the original stack frame is gone, so it just swallows exceptions raised asynchronously and logs them to the internal log. Not catching exceptions on background threads would be fatal and might result in application termination.

You can probably see why swallowing exceptions prevents wrappers, such as [RetryingWrapper](https://github.com/NLog/NLog/wiki/RetryingWrapper-target) from working. If you write declare the following wrappers in your configuration file, the outermost wrapper will never implement any retry logic, since AsyncWrapper will never pass any asynchronous exceptions to RetryingWrapper.

{% highlight xml %}
<target type="RetryingWrapper" ...>
   <target type="AsyncWrapper" ...>
      <target type="File" ...>
   </target>
</target>
{% endhighlight %}

Asynchronous Exception Handling in NLog 2.0
-------------------------------------------
In order to implement proper asynchronous exception handling we need to let asynchronous methods know what to do in case of success and failure. This is typically done through [continuation](http://en.wikipedia.org/wiki/Continuation) functions. There are many ways to represent continuation information, I've decided to represent it as an interface with two methods:

{% highlight csharp %}
public interface IAsyncContinuation
{
    void OnSuccess();
    void OnException(Exception exception);
}
{% endhighlight %}

The Target.Write() API will be refactored to look like this:

{% highlight csharp %}
public void WriteLogEvent(LogEventInfo logEvent, IAsyncContinuation asyncContinuation)
{
    try
    {
        this.Write(logEvent, asyncContinuation);
    }
    catch (Exception ex)
    {
        asyncContinuation.OnException(ex);
    }
}

protected virtual void Write(LogEventInfo logEvent, IAsyncContinuation asyncContinuation)
{
    try
    {
        this.Write(logEvent);
    }
    catch (Exception ex)
    {
        asyncContinuation.OnException(ex);
        return;
    }

    asyncContinuation.OnSuccess();
}

protected abstract void Write(LogEventInfo logEvent);
{% endhighlight %}

As you can see, by default the asynchronous code gets forwarded to the synchronous Write method. This lets us keep the existing extensibility interface for targets. If you want to implement asynchronous target, you need to override both synchronous and asynchronous write methods:

{% highlight csharp %}
public class MyAsyncTarget : TargetWithLayout
{
    [RequiredParameter]
    public Uri TargetUri { get; set; }

    protected override void Write(LogEventInfo logEvent)
    {
        throw new NotSupportedException("Synchronous write operation is not supported.");
    }

    protected override void Write(LogEventInfo logEvent, IAsyncContinuation asyncContinuation)
    {
        var wc = new WebClient();
        wc.UploadDataCompleted += (sender, e) =>
            {
                wc.Dispose();
                if (e.Error != null)
                {
                    asyncContinuation.OnException(e.Error);
                    return;
                }

                asyncContinuation.OnSuccess();
            };

        byte[] data = Encoding.UTF8.GetBytes(this.Layout.GetFormattedMessage(logEvent));
        wc.UploadDataAsync(this.TargetUri, data);
    }
}
{% endhighlight %}

Target.Flush() method will be changed in a similar way, except it will be asynchronous only:

{% highlight csharp %}
public void Flush(IAsyncContinuation asyncContinuation)
{
    try
    {
        this.FlushAsync(asyncContinuation);
    }
    catch (Exception ex)
    {
        asyncContinuation.OnException(ex);
    }
}

protected virtual void FlushAsync(IAsyncContinuation asyncContinuation)
{
    asyncContinuation.OnSuccess();
}
{% endhighlight %}

LogManager and LogFactory will also be enhanced with asynchronous Flush() methods. Their synchronous overloads will not be available in Silverlight, since there is no way to wait on a potential network call without causing a deadlock:

{% highlight csharp %}
public class LogFactory
{
#if !SILVERLIGHT
  void Flush();
  void Flush(TimeSpan timeout);
  void Flush(int timeoutMilliseconds);
#endif

  void Flush(IAsyncContinuation asyncContinuation);
  void Flush(IAsyncContinuation asyncContinuation, TimeSpan timeout);
  void Flush(IAsyncContinuation asyncContinuation, int timeoutMilliseconds);
}
{% endhighlight %}

Working with continuations
--------------------------
NLog 2.0 will provide default implementation of continuations creatable through AsyncHelpers.MakeContinuation() factory method:

{% highlight csharp %}
IAsyncContinuation continuation = AsyncHelpers.MakeContinuation(
    () => { /* code to execute on success */ }
    ex => { /* code to execute on failure */ });
{% endhighlight %}

In addition to this I am planning to expose helpers which will make working with and composing continuations easier:

{% highlight csharp %}
public delegate void AsynchronousAction(IAsyncContinuation asyncContinuation);
public delegate void AsynchronousAction<T>(IAsyncContinuation asyncContinuation, T argument);

public static class AsyncHelpers
{
  public static void RunSequentially<T>(IEnumerable<T> values, IAsyncContinuation asyncContinuation, AsynchronousAction<T> callback);
  public static void RunInParallel<T>(IEnumerable<T> values, IAsyncContinuation asyncContinuation, AsynchronousAction<T> action);
  public static void Repeat(int repeatCount, IAsyncContinuation asyncContinuation, AsynchronousAction action);
  public static IAsyncContinuation FollowedBy(this IAsyncContinuation asyncContinuation, AsynchronousAction action);
  public static IAsyncContinuation WithTimeout(this IAsyncContinuation asyncContinuation, TimeSpan timeout);
  public static void RunSynchronously(AsynchronousAction action);
}
{% endhighlight %}

Impact on wrappers
------------------
Because of the way the API is designed, the impact on existing targets should be very limited. Unfortunately this does not apply to wrappers, which have to be completely rewritten to be fully asynchronous. Asynchronous code tends to be larger and more difficult to read and follow, as demonstrated in the following example:

For example, the code for [retrying wrapper](https://github.com/NLog/NLog/wiki/RetryingWrapper-target) in NLog 1.0 looked like this:

{% highlight csharp %}
protected internal override void Write(LogEventInfo logEvent)
{
    for (int i = 0; i < RetryCount; ++i)
    {
        try
        {
            if (i > 0)
                InternalLogger.Warn("Retry #{0}", i);
            WrappedTarget.Write(logEvent);
            // success, return
            return;
        }
        catch (Exception ex)
        {
            InternalLogger.Warn("Error while writing to '{0}': {1}", WrappedTarget, ex);
            if (i == RetryCount - 1)
                throw ex;
            System.Threading.Thread.Sleep(RetryDelayMilliseconds);
        }
    }
}
{% endhighlight %}

The code for the same operation in NLog 2.0 is much more complex:

{% highlight csharp %}
protected override void Write(LogEventInfo logEvent, IAsyncContinuation asyncContinuation)
{
    FailureAction failure = null;
    int counter = 0;

    failure = ex =>
        {
            InternalLogger.Warn("Error while writing to '{0}': {1}", this.WrappedTarget, ex);
            int retryNumber = Interlocked.Increment(ref counter);

            // exceeded retry count
            if (retryNumber == this.RetryCount)
            {
                asyncContinuation.OnException(ex);
                return;
            }

            // sleep and try again
            Thread.Sleep(this.RetryDelayMilliseconds);
            InternalLogger.Warn("Retry #{0}", retryNumber);

            this.WrappedTarget.WriteLogEvent(logEvent, AsyncHelpers.MakeContinuation(asyncContinuation.OnSuccess, failure));
        };

    this.WrappedTarget.WriteLogEvent(logEvent, AsyncHelpers.MakeContinuation(asyncContinuation.OnSuccess, failure));
}
{% endhighlight %}

Summary
-------
Asynchronous processing is a very difficult matter, and it is very difficult to write correct and robust asynchronous code. I am hoping that proposed APIs and abstraction level are the right ones and will not make the source code too difficult to read and maintain.

Any comments or suggestions are welcome.