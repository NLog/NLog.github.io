---
layout: post
title: Extending NLog ... is easy!
---



Not everyone is aware that NLog is easy to extend to your own wishes. 
There could be various reasons why you would like to extend NLog. 
For example: If you want to write your log messages to a custom output or you would like to use your own ${} macro's. 

With some attributes you can create your own custom Target, Layout or Layout renderer with easy. 
Also creating your own conditions for filter messages is possible!

I will describe the Target and Layout renderer in this post.

##How to write a custom target?
It’s really easy. Create a class that inherits from `NLog.Targets.TargetWithLayout` and override the `Write()` method. In the body of the method invoke `this.Layout.Render()` to get the message text, then send the text to the destination media.


###Example

Example 
{% highlight csharp %}

[Target("MyFirst")] 
public sealed class MyFirstTarget: TargetWithLayout 
{ 
    public MyFirstTarget()
    {
        this.Host = "localhost";
    }
 
    [RequiredParameter] 
    public string Host { get; set; }
 
    protected override void Write(LogEventInfo logEvent) 
    { 
       string logMessage = this.Layout.Render(logEvent); 

       SendTheMessageToRemoteHost(this.Host, logMessage); 
    } 
 
    private void SendTheMessageToRemoteHost(string host, string message) 
    { 
         // TODO - write me 
    } 
} 

{% endhighlight %}

###How to pass configuration options to the target?
Consider the above example. There’s a property called “Host” that does just that. Having a public property that sets the required configuration parameters is enough for NLog to use it. Each attribute that you put in the `<target />` definition gets passed to the appropriate public property. NLog takes care of the appropriate conversions necessary so that you can use integer, string, datetime, boolean parameters.

##How to write a custom layout renderer?
Create a class that inherits from `NLog.LayoutRenderers.LayoutRenderer`, set the `[LayoutRenderer("your-name"]` on the class and override the `Append(StringBuilder builder, LogEventInfo logEvent)` method. 
Invoke in this method `builder.Append(..)` to render your custom layout renderer.

###Example
We create a `${hello-world}` layout renderer, which renders..."hello world!".

{% highlight csharp %}
[LayoutRenderer("hello-world")]
public class HelloWorldLayoutRenderer : LayoutRenderer
{
    protected override void Append(StringBuilder builder, LogEventInfo logEvent)
    {
        builder.Append("hello world!");
    }
}


{% endhighlight %}

###How to pass configuration options to the layout render?
Just create public properties on the Layout Renderer. The properties could be decorated with the `[RequiredParameter]` and `[DefaultParameter]` attributes. The `[DefaultParameter]` is can be passed to the layout renderer without using the name.



for example:

{% highlight csharp %}
[LayoutRenderer("hello-world")]
public class HelloWorldLayoutRenderer : LayoutRenderer
{
        /// <summary>
        /// I'm not required or default
        /// </summary>
        public string Config1 { get; set; }

        /// <summary>
        /// I'm required
        /// </summary>
        [RequiredParameter]
        public string Config2 { get; set; }

        /// <summary>
        /// I'm the default parameter. You can set me as required also.
        /// </summary>
        [DefaultParameter]
        public bool Caps {get;set;}

{% endhighlight %}

Example usages

- `${hello-world}` - raises exception: required parameter Config2 isn't set
- `${hello-world:Config2=abc}` - OK, Config2 property set
- `${hello-world:true:config2=abc}` - default parameter (Caps) set to `true`
- `${hello-world:true:config2=abc:config1=yes}` - all the three properties set.

##How to use the custom target / layout renderer
It’s easy. Just put the target or layout renderer in a DLL and reference it from the the config file using the `<extensions />` clause as described here.

Starting from NLog 4.0 assemblies with the name "NLog*.dll", like “NLog.CustomTarget.dll” are now loaded automatically. This assembly should be in the same folder as `NLog.dll`. 

Configuration file example:

{% highlight xml %}
<nlog> 
  <extensions> 
    <add assembly="MyAssembly"/> 
  </extensions> 
  <targets> 
    <target name="a1" type="MyFirst" host="localhost"/> 
    <target name="f1" type="file"  layout="${longdate} ${hello-world}" 
            fileName="${basedir}/logs/logfile.log" />
  </targets> 
  <rules> 
    <logger name="*" minLevel="Info" appendTo="a1"/> 
    <logger name="*" minLevel="Info" appendTo="f1"/> 
  </rules> 
</nlog>
{% endhighlight %}


###Do I really need to create a separate DLL?
Not really. You can register your target programmatically. Just be sure to do it at the very beginning of your program before any log messages are written. It should be possible to reference your EXE using the `<extensions />` clause.
{% highlight csharp %}
static void Main(string[] args) 
{ 
    //target
    ConfigurationItemFactory.Default.Targets
          .RegisterDefinition("MyFirst", typeof(MyNamespace.MyFirstTarget));

    //layout renderer
    ConfigurationItemFactory.Default.LayoutRenderers
          .RegisterDefinition("hello-world", typeof(MyNamespace.HelloWorldLayoutRenderer ));
 
    // start logging here 
}
{% endhighlight %}


