---
layout: post
title: NLog for Windows Phone 7
---

This week I have checked in a port of NLog 2.0 for Windows Phone 7. It's still very experimental and the intention of this release is to get feedback from people. Please use at your own risk.

Current build supports 8 targets:

 * [Console](https://github.com/NLog/NLog/wiki/Console-target) - can be used to write logs to the console (only works in Emulator - see this post for instruction on how to enable console output)
 * [Memory](https://github.com/NLog/NLog/wiki/Memory-target) - stores traces in memory
 * [MethodCall](https://github.com/NLog/NLog/wiki/MethodCall-target) - runs user-provided method for each log message
 * [Network](https://github.com/NLog/NLog/wiki/Network-target), [NLogViewer](https://github.com/NLog/NLog/wiki/NLogViewer-target) and [Chainsaw](https://github.com/NLog/NLog/wiki/Chainsaw-target) - write XML-formatted log event over the network. Only HTTP:// and HTTPS:// protocols are supported.
 * [WebService](https://github.com/NLog/NLog/wiki/WebService-target) - sends log events to a web service using SOAP or POST
 * [LogReceiverService](https://github.com/NLog/NLog/wiki/LogReceiverService-target) - sends log events to LogReceiver web service using WCF

Note that [File target](https://github.com/NLog/NLog/wiki/File-target) and several others are not included because of current constraints of the platform APIs.

Here is a simple step-by-step tutorial for adding NLog to your WP7 app:

Download and install the bits
-----------------------------
 * Go to <http://nlog.codeplex.com/releases> and download one of the recent nightly builds - choose build later than 2011/1/9
 * Pick a package named = NLog2-All-*.msi (includes builds for all platforms - recommended) or NLog2-WP-*.msi (which includes only WP7 bits).
 * Run the setup and wait - setup will add code snippets and templates for all development environments you have on the machine, which can take some time (couple minutes, so be patient)

Add NLog  to your Windows Phone app project
-------------------------------------------
* Open your project
* Add **NLog.config** to your project - the easiest way is to select '**Add new item**' and choose '**Empty NLog Configuration File**' from the '**NLog**' section. 

<img src="/images/posts/2011/01/NLogWP7AddNewItem.png">

* This will also add a reference to NLog: 

<img src="/images/posts/2011/01/NLogWP7WithReference_thumb.png">

* If you prefer, you manually add reference to "**C:\Program Files (x86)\NLog\Silverlight for Windows Phone 7\NLog.dll**" instead and create **NLog.config** manually
* One last thing is changing **Build Action** for NLog.config to '**Content**' (this ensures that the file will be included in the XAP package).

Set logging configuration
-------------------------
In this tutorial we will use LogReceiverService target, but you can use any other target supported by NLog. To do this open NLog.config and paste the following configuration: 

{% highlight xml %}
<?xml version="1.0" encoding="utf-8" ?>
<nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <targets>
      <target xsi:type="LogReceiverService" name="webService" endpointAddress="http://localhost:5000/LogReceiver.svc"/>
    </targets>

    <rules>
      <logger name="*" minlevel="Debug" writeTo="webService" />
    </rules>
</nlog>
{% endhighlight %}

Emit log messages
-----------------
To emit log messages you need to get a Logger instance from LogManager and call one of the log methods. See .NET Logging API for more information. Let's add some logging code to MainPage.xaml.cs:

{% highlight csharp %}
namespace WindowsPhoneApplication2
{
    using System.Windows;
    using Microsoft.Phone.Controls;

    public partial class MainPage : PhoneApplicationPage
    {
        private static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();

        // Constructor
        public MainPage()
        {
            InitializeComponent();
            logger.Info("Main page loaded.");
        }

        private void button1_Click(object sender, RoutedEventArgs e)
        {
            logger.Debug("Button 1 clicked.");
        }

        private void button2_Click(object sender, RoutedEventArgs e)
        {
            logger.Debug("Button 2 clicked.");
        }
    }
}
{% endhighlight %}

When you run the code, log messages will be sent to http://localhost:5000/LogReceiver.svc

Receive log messages
--------------------
In order to receive log messages you need to have an endpoint that implements **ILogReceiverServer** contract. NLog comes with an example that does just that and listens on (incidentally) http://localhost/LogReceiver.svc , or if you prefer you can implement your own server. You can find it the example in the source code under **examples\NLogReceiverForwarderService**. The sample will basically forward NLog messages received from the network through NLog running on the server machine.

 * Download NLog source code
 * Open the project file **examples\NLogReceiverForwarderService\NLogReceiverForwarderService.csproj** (Visual Studio needs to be running as an Administrator)
 * Edit NLog.config and adjust log outputs as necessary.
 * Run the project. Notice how when you click on buttons in your Windows Phone 7 application, the logs are displayed on your console:

<img src="/images/posts/2011/01/LogForwarderOutput_thumb.png">

Let's do more...
----------------
Having rich NLog do log routing on both client and server opens a lot of possibilities. You can for example send much richer information from the client to the server. In order to do this we'll be using parameters. Let's modify client side configuration to send thread id along with each log message:
{% highlight xml %}
<?xml version="1.0" encoding="utf-8" ?>
<nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <targets>
      <target xsi:type="LogReceiverService" name="webService" endpointAddress="http://localhost:5000/LogReceiver.svc">
        <parameter name="t" layout="${threadid}" />
      </target>
    </targets>

    <rules>
      <logger name="*" minlevel="Debug" writeTo="webService" />
    </rules>
</nlog>
{% endhighlight %}

On the server side, we can now extract 't' parameter using [${event-context} layout renderer](https://github.com/NLog/NLog/wiki/EventContext-Layout-Renderer). Let's also add timestamp to each message:

{% highlight xml %}
<?xml version="1.0" encoding="utf-8" ?>
<nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <targets>
        <target name="console" xsi:type="Console" layout="${longdate} ${message} ${event-context:t}" />
    </targets>

    <rules>
        <logger name="*" minlevel="Debug" writeTo="console" />
    </rules>
</nlog>
{% endhighlight %}

Now when you restart both client and server you should see this picture - we can now see that all log events were sent from thread #2 - the UI thread of the Silverlight application.

<img src="/images/posts/2011/01/LogForwarderOutput2_thumb.png">

I would love to hear your feedback about this build and using NLog in Windows Phone 7 applications in general. Please use [Forum](http://nlog-project.org/forum) for any questions or suggestions or [Issue Tracker](http://nlog-project.org/issuetracker) if something does not work correctly.