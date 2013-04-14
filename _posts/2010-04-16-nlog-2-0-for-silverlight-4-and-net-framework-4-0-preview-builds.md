---
layout: post
title: NLog 2.0 for Silverlight 4 and .NET Framework 4.0 preview builds
---

This week .NET Framework 4.0 and Silverlight 4 have been released. I've updated NLog 2.0 to support them and published a new build - very experimental - on [CodePlex](http://nlog.codeplex.com/releases/view/43702). One of the biggest updates in Silverlight 4 is support for out-of-browser applications with elevated permissions, which means applications that can access the filesystem.

I've put together a tiny sample that shows how to use NLog in Silverlight application. Basically since Silverlight does not have a concept of application configuration file you should configure Silverlight at application startup. In my case I've added this code in App.xaml.cs:

<pre>
private void Application_Startup(object sender, StartupEventArgs e)
{
    InitializeNLog();
    this.RootVisual = new MainPage();
}

private void InitializeNLog()
{
    SimpleConfigurator.ConfigureForTargetLogging(
        new FileTarget()
        {
            FileName = "${specialfolder:MyDocuments}/log.${shortdate}.txt",
            Layout = new CsvLayout()
            {
                Columns =
                {
                    new CsvColumn("Time", "${longdate}"),
                    new CsvColumn("Level", "${level}"),
                    new CsvColumn("Lessage", "${message}"),
                    new CsvColumn("Logger", "${logger}"),
                },
            }
        },
        LogLevel.Debug);
}
</pre>

The application will produce CSV-formatted log file in Documents folder. The name of the file will be log.CURRENTDATE.txt.

Usage of NLog stays unchanged:

<pre>
public partial class MainPage : UserControl
{
    private static Logger logger = LogManager.GetCurrentClassLogger();

    public MainPage()
    {
        InitializeComponent();

        // log some events
        this.Loaded += (sender, e) => logger.Info("Page loaded");
        this.LayoutUpdated += (sender, e) => logger.Debug("Layout updated");
        this.SizeChanged += (sender, e) => logger.Debug("Size changed to {0}x{1}", e.NewSize.Width, e.NewSize.Height);
        this.KeyDown += (sender, e) => logger.Debug("Key down '{0}'", e.Key);
        this.Unloaded += (sender, e) => logger.Info("Unloaded");
    }

    private void button1_Click(object sender, RoutedEventArgs e)
    {
        logger.Info("Button clicked");
    }
}
</pre>

Why not give NLog for Silverlight a try? Go to [http://nlog.codeplex.com/releases/view/43702](http://nlog.codeplex.com/releases/view/43702) and download preview bits today and report back any issues.