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


##How to write a custom layout renderer?
Create a class that inherits from `NLog.LayoutRenderers.LayoutRenderer`, set the `[LayoutRenderer("your-name"]` on the class and override the `Append(StringBuilder builder, LogEventInfo logEvent)` method. 
Invoke in this method `builder.Append(..)` to render your custom layout renderer.

###Example
We create a `${hello-universe}` layout renderer, which renders... "hello universe!".

{% highlight csharp %}
[LayoutRenderer("hello-universe")]
public class HellouniverseLayoutRenderer : LayoutRenderer
{
    protected override void Append(StringBuilder builder, LogEventInfo logEvent)
    {
        builder.Append("hello universe!");
    }
}


{% endhighlight %}

###How to pass configuration options to the layout render?
Just create **public** properties on the layout renderer. The properties could be decorated with the `[RequiredParameter]` and `[DefaultParameter]` attributes. 
With the `[RequiredParameter]` attribute, NLog will check if this property has a value and throw an exception when not. When the  `[DefaultParameter]` attribute is used, than the name of the property is not required in your config if it's the first value - see the examples below. 

It's not required that the property is a `string`.
NLog takes care of the appropriate conversions necessary. You can use, inter alia, the following types for the properties: `integer`, `string`, `datetime` and `boolean`. 


For example:

{% highlight csharp %}
[LayoutRenderer("hello-universe")]
public class HellouniverseLayoutRenderer : LayoutRenderer
{
        /// <summary>
        /// I'm not required
        /// </summary>
        public string Config1 { get; set; }

        /// <summary>
        /// I'm required
        /// </summary>
        [RequiredParameter]
        public string Config2 { get; set; }

        /// <summary>
        /// I'm the default parameter. You can also set me as required.
        /// </summary>
        [DefaultParameter]
        public bool Caps {get;set;}

{% endhighlight %}

Example usages

- `${hello-universe}` - raises exception: required parameter "Config2" isn't set
- `${hello-universe:Config2=abc}` - OK, "Config2" property set
- `${hello-universe:true:config2=abc}` - default parameter "Caps" set to `true`
- `${hello-universe:true:config2=abc:config1=yes}` - all the three properties set.


##How to write a custom target?
Creating a custom target is almost indentical to creating a custom layout renderer. 

The created class should now inherit from `NLog.Targets.TargetWithLayout` and override the `Write()` method. In the body of the method invoke `this.Layout.Render()` to render the message text.

###Example
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

###How to pass configuration options to the target?

The property "host" is a configurable option to this target. You can pass the value as attribute in the config: `<layout type="myFirst" host="test.com" />`


##How to use the custom target / layout renderer
It’s very simple. Just put the target or layout renderer in a DLL and reference it from the the config file using the `<extensions />` clause as described above.

Starting from NLog 4.0, assemblies with the name "NLog*.dll", such as “NLog.CustomTarget.dll” are now loaded automatically. This assembly should be in the same folder as `NLog.dll`. 

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


###Do I really need to create a separate DLL?
Not really. You can register your target programmatically. Just be sure to do it at the very beginning of your program before any log messages are written. 
{% highlight csharp %}
static void Main(string[] args) 
{ 
    //layout renderer
    ConfigurationItemFactory.Default.LayoutRenderers
          .RegisterDefinition("hello-universe", typeof(MyNamespace.HellouniverseLayoutRenderer ));

    //target
    ConfigurationItemFactory.Default.Targets
          .RegisterDefinition("MyFirst", typeof(MyNamespace.MyFirstTarget));
 
    // start logging here 
}
{% endhighlight %}


