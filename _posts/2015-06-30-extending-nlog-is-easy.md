---
layout: post
title: Extending NLog is... easy!
---



Not everyone knows NLog is easy to extend to your own wishes. 
There can be various reasons for wanting to extend NLog. 
For example when you want to write your log messages to a custom output or you would like to use your own `${}` macros. 

With some attributes you can create your own custom target, layout or layout renderer with ease. 
Also creating your own conditions for filter messages is possible!

I will describe creating your own layout renderer and custom target in this post.


## How to write a custom layout renderer?
Create a class which inherits from `NLog.LayoutRenderers.LayoutRenderer`, set the `[LayoutRenderer("your-name"]` on the class and override the `Append(StringBuilder builder, LogEventInfo logEvent)` method. 
Invoke in this method `builder.Append(..)` to render your custom layout renderer.

### Example
We create a `${hello-universe}` layout renderer, which renders... "hello universe!".

{% highlight csharp %}
[LayoutRenderer("hello-universe")]
public class HelloUniverseLayoutRenderer : LayoutRenderer
{
    protected override void Append(StringBuilder builder, LogEventInfo logEvent)
    {
        builder.Append("hello universe!");
    }
}


{% endhighlight %}

### How to pass configuration options to the layout render?
Just create **public** properties on the layout renderer. The properties can be decorated with the `[RequiredParameter]` and `[DefaultParameter]` attributes. 
With the `[RequiredParameter]` attribute, NLog checks if this property has a value and throws an exception when it hasn't.
The property names are required in your config by default. The property name of the first value can be skipped, if the property is decorated with the `[DefaultParameter]` attribute - see the examples below. 

It's not required for the property to be a `string`.
NLog takes care of the appropriate conversions when necessary. You can use, inter alia, the following types for the properties: `integer`, `string`, `datetime` and `boolean`. 


For example:

{% highlight csharp %}
[LayoutRenderer("hello-universe")]
public class HelloUniverseLayoutRenderer : LayoutRenderer
{
        /// <summary>
        /// I'm not required
        /// </summary>
        public string Config1 { get; set; }

        /// <summary>
        /// I'm required! 
        /// </summary>
        [RequiredParameter]
        public string Config2 { get; set; }

        /// <summary>
        /// Hi! I'm the default parameter. You can also set me as required.
        /// </summary>
        [DefaultParameter]
        public bool Caps {get;set;}

{% endhighlight %}

Example usages:

- `${hello-universe}` - Raises exception: required parameter "Config2" isn't set.
- `${hello-universe:Config2=abc}` - OK, "Config2" property set.
- `${hello-universe:true:config2=abc}` - Default parameter "Caps" set to `true`.
- `${hello-universe:true:config2=abc:config1=yes}` - All the three properties set.


## How to write a custom target?
Creating a custom target is almost identical to creating a custom layout renderer. 

The created class should now inherit from `NLog.Targets.TargetWithLayout` and override the `Write()` method. In the body of the method invoke `this.Layout.Render()` to render the message text.

### Example
An example of a custom target:
 
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

### How to pass configuration options to the target?

The property "host" is a configurable option to this target. You can pass the value as attribute in the config: `<layout type="myFirst" host="test.com" />`


## How to use the custom target or layout renderer
First put your custom target or layout renderer in a separate assembly (.dll). Then you should register your assembly. Starting from NLog 4.0, assemblies with the name "NLog*.dll", such as "NLog.CustomTarget.dll" are now registered automatically - they should be in the same folder as "NLog.dll".  

If that's not the case you should register your assembly manually: reference your assembly from the the config file using the `<extensions />` clause. Only the assembly name is needed (without ".dll"). 

Configuration file example:

{% highlight xml %}
<nlog> 
  <extensions> 
    <add assembly="MyAssembly"/> 
  </extensions> 
  <targets> 
    <target name="a1" type="MyFirst" host="localhost"/> 
    <target name="f1" type="file"  layout="${longdate} ${hello-universe}" 
            fileName="${basedir}/logs/logfile.log" />
  </targets> 
  <rules> 
    <logger name="*" minLevel="Info" appendTo="a1"/> 
    <logger name="*" minLevel="Info" appendTo="f1"/> 
  </rules> 
</nlog>
{% endhighlight %}


### Do I really need to create a separate assembly?
Not really. You should then register your target programmatically. Just make sure to register your stuff at the very beginning of your program, before any log messages are written. 
{% highlight csharp %}
static void Main(string[] args) 
{ 
    //layout renderer
    ConfigurationItemFactory.Default.LayoutRenderers
          .RegisterDefinition("hello-universe", typeof(MyNamespace.HelloUniverseLayoutRenderer ));

    //target
    ConfigurationItemFactory.Default.Targets
          .RegisterDefinition("MyFirst", typeof(MyNamespace.MyFirstTarget));
 
    // start logging here 
}
{% endhighlight %}


