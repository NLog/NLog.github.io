---
layout: post
title: Deploying NLog configuration files
---

Some of the [targets](https://github.com/NLog/NLog/wiki/Targets) supported by NLog require installation to be performed on the machine before the target can be used. For example, when logging to a [database](https://github.com/NLog/NLog/wiki/Database-target), a DBA needs to create the necessary tables, when logging to [event log](https://github.com/NLog/NLog/wiki/EventLog-target) or [performance counter](https://github.com/NLog/NLog/wiki/PerfCounter-target), administrator of the machine must create them before the application can write to them.

NLog 2.0 comes with a new tool and APIs that lets you manage installation and uninstallation of objects which support logging.

Say you want to write logs to:

 * local SQLEXPRESS database
 * Event Log on the local machine
 * increase performance counter each time log message occurs.

With NLog 2.0, you can embed installation/uninstallations steps directly in the log configuration file, like in the following example:

{% highlight xml %}
<?xml version="1.0" encoding="utf-8" ?>
<nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <targets>
    <target xsi:type="Database" name="db">
      <!-- SQL command to be executed for each entry -->
      <commandText>INSERT INTO [LogEntries](TimeStamp, Message, Level, Logger) VALUES(getutcdate(), @msg, @level, @logger)</commandText>

      <!-- parameters for the command -->
      <parameter name="@msg" layout="${message}" />
      <parameter name="@level" layout="${level}" />
      <parameter name="@logger" layout="${logger}" />

      <!-- connection string -->
      <dbProvider>System.Data.SqlClient</dbProvider>
      <connectionString>server=.\SQLEXPRESS;database=MyLogs;integrated security=sspi</connectionString>

      <!-- commands to install database -->
      <install-command>
        <text>CREATE DATABASE MyLogs</text>
        <connectionString>server=.\SQLEXPRESS;database=master;integrated security=sspi</connectionString>
        <ignoreFailures>true</ignoreFailures>
      </install-command>

      <install-command>
        <text>
          CREATE TABLE LogEntries(
          id int primary key not null identity(1,1),
          TimeStamp datetime2,
          Message nvarchar(max),
          level nvarchar(10),
          logger nvarchar(128))
        </text>
      </install-command>

      <!-- commands to uninstall database -->
      <uninstall-command>
        <text>DROP DATABASE MyLogs</text>
        <connectionString>server=.\SQLEXPRESS;database=master;integrated security=sspi</connectionString>
        <ignoreFailures>true</ignoreFailures>
      </uninstall-command>
    </target>

    <target xsi:type="EventLog" name="eventLog" source="NLog Demo"
            layout="${message}${newline}Call site: ${callsite:className=true:methodName=true}${newline}Logger: ${logger}">
    </target>

    <target xsi:type="PerfCounter" name="pc1" categoryName="My Log" counterName="My Counter">
    </target>

  <rules>
    <logger name="*" minlevel="Trace" writeTo="db,eventLog,pc1" />
  </rules>
</nlog>
{% endhighlight %}

In order to deploy the database, event log and performance counter, you can use simply use InstallNLogConfig.exe tool that comes with NLog. Open elevated command prompt and run the following command:

<pre>
> InstallNLogConfig.exe c:\path\to\NLog.config
Installing 'Database Target[db]'
Finished installing 'Database Target[db]'.
Installing 'EventLog Target[eventLog]'
Finished installing 'EventLog Target[eventLog]'.
Installing 'PerfCounter Target[pc1]'
Finished installing 'PerfCounter Target[pc1]'.
</pre>

Uninstalling is equally easy:

<pre>
> InstallNLogConfig.exe" -u c:\path\to\NLog.config 
Uninstalling 'Database Target[db]' 
Finished uninstalling 'Database Target[db]'. 
Uninstalling 'EventLog Target[eventLog]' 
Finished uninstalling 'EventLog Target[eventLog]'. 
Uninstalling 'PerfCounter Target[pc1]' 
Finished uninstalling 'PerfCounter Target[pc1]'.
</pre>

Passing parameters to installation
----------------------------------
Sometimes there is a need to pass parameters to the installation routing, which should not be normally visible in the NLog.config file. One example might be DBA username and password for connecting to the database. You can pass parameters on the command line by using –p NAME=VALUE option:

<pre>
> InstallNLogConfig.exe" –p ADMIN_USER=sa –p ADMIN_PASSWORD=megaSecret1234 c:\path\to\NLog.config 
</pre>

The parameters are accessible using [${install-context} layout renderer](https://github.com/NLog/NLog/wiki/InstallContext-Layout-Renderer). For example, we can easily modify the above example to use SQL authentication where user name and password are passed from command line:

{% highlight xml %}
<install-command>
  <text>CREATE DATABASE MyLogs</text>
    <connectionString>server=.\SQLEXPRESS;database=master;
                      user id=${install-context:ADMIN_USER};password=${install-context:PASSWORD}</connectionString>
    <ignoreFailures>true</ignoreFailures>
</install-command>
{% endhighlight %}

Installation API
----------------
In order to install logging configuration, you can simply use Install() and Uninstall() methods on LoggingConfiguration object. They both take InstallationContext arguments, which can be used pass parameters and specify logging and other options:

{% highlight csharp %}
namespace NLog.Config
{
    public sealed class InstallationContext : IDisposable
    {
        /// <summary>
        /// Gets or sets the installation log level.
        /// </summary>
        public LogLevel LogLevel { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether to ignore failures during installation.
        /// </summary>
        public bool IgnoreFailures { get; set; }

        /// <summary>
        /// Gets the installation parameters.
        /// </summary>
        public IDictionary<string, string> Parameters { get; private set; }

        /// <summary>
        /// Gets or sets the log output.
        /// </summary>
        public TextWriter LogOutput { get; set; }
    }
}
{% endhighlight %}

Typical installation code will look like this:

{% highlight csharp %}
using (var context = new InstallationContext())
{
  var config = new XmlLoggingConfiguration("NLog.config");

  // output detailed installation logs
  context.LogLevel = LogLevel.Trace;

  context.Parameters["ADMIN_USER"] = "sa";
  context.Parameters["ADMIN_PASSWORD"] = "megaSecret1234";

  // write logs to a log file
  using (var logFile = File.CreateText("InstallLog.txt"))
  {
    context.LogOutput = logFile;

    config.Install(context);  
  }
}
{% endhighlight %}

In order to support custom installation in your target or any other configuration item (such as layout, filter, etc.), you simply need to implement IIinstallable interface:

{% highlight csharp %}
public interface IInstallable
{
  void Install(InstallationContext installationContext);
  void Uninstall(InstallationContext installationContext);
  bool? IsInstalled(InstallationContext installationContext);
}
{% endhighlight %}

See [DatabaseTarget](http://github.com/NLog/NLog/blob/master/src/NLog/Targets/DatabaseTarget.cs) sources for example implementation.