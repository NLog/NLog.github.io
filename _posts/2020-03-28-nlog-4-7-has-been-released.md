---
layout: post
title: NLog 4.7 has been released!
---

NLog 4.7 marks another year of new features and performance improvements.

## Main features

### LogFactory Setup
There has been introduced a new fluent api for setting up NLog before logging. Instead of having static methods on different NLog types, then all options are being gathered around `LogFactory.Setup()`. This will also prepare the road for improving the support for multiple isolated `LogFactory` instances in the same application.

### Custom Object Serialization
It is now possible to customize the serialization of different object types. One can exclude unwanted properties, or add new artificial properties.

### Examples
Ensures that object-reflection is skipped for all objects that implements `IDangerousObject`:

```c#
NLog.LogManager.Setup().SetupSerialization(s => 
   s.RegisterObjectTransformation<IDangerousObject>(o => o.ToString()));
```

Ensures that only selected properties for objects of the type `System.Net.WebException`:

```c#
NLog.LogManager.Setup().SetupSerialization(s => 
   s.RegisterObjectTransformation<System.Net.WebException>(ex => new {
      Type = ex.GetType().ToString(),
      Message = ex.Message,
      StackTrace = ex.StackTrace,
      Source = ex.Source,
      InnerException = ex.InnerException,
      Status = ex.Status,
      Response = ex.Response.ToString(),  // Call your custom method to render stream as string
   }));
```

This can be used together with `${exception:format=@}` or the Properties-Format-option `${exception:format=Properties}`.

### Lambda Condition Methods
NLog already has two ways for adding own custom condition methods:
- Create static class with class-attribute `[ConditionMethods]` and add static methods with function-attribute `[ConditionMethod]`. Then add the assembly to be registered as an extension.
- Explicit register a static method using `ConfigurationItemFactory.Default.ConditionMethods.RegisterDefinition()`.

Now it is also possible to register lamdba methods:

```c#
LogManager.Setup().SetupExtensions(s =>
   s.RegisterConditionMethod("hasParameters", evt => evt.Parameters?.Length > 0)
);
```

And of course standard static methods: 

```c#
LogManager.Setup().SetupExtensions(s =>
   s.RegisterConditionMethod("hasPriority", typeof(NLogConditionMethods).GetMethod("HasPriority", BindingFlags.Static))
);
```

### FileTarget MaxArchiveDays
FileTarget can now use the timestamp of the archived files to check if they should be deleted. This allows you to keep log files from the last 30 days, even if `ArchiveAboveSize` have produced several files for the same day. It can be used in combination with the existing setting `MaxArchiveFiles`, so one will not have more than ex. 60 files in total.

### DatabaseTarget Custom Connection Properties
DatabaseTarget is very generic and supports multiple DbProviders. Certain DbProviders might have additional connection properties. Like `SqlConnection.AccessToken` for Azure AD Access Token.

Now it is possible to configure additional connection properties:

```xml
<target name="db" xsi:type="Database" connectionstring="..." >
  <connectionProperty name="AccessToken" layout="${gdc:AccessToken}" propertyType="System.String" />
</target>
```

All configured connection properties will be applied before opening the connection. In the above example then one must handle expiry of the AccessToken in `${gdc:AccessToken}`, by creating a custom background timer that will refresh the Azure AccessToken in timely manner.

### InternalLogger LogMessageReceived
NLog InternalLogger now has support for raising events, instead of having to create a custom `ITextWriter` and assign it as to `InternalLogger.LogWriter`.

```c#
InternalLogger.LogMessageReceived += (sender, e) => SomethingUseful(e);
```

One should be careful with executing heavy operations in the custom event handler, as it will hurt NLog performance. And most important of all, then one should never use NLog Logger inside the custom event handler, as it will cause stackoverflow or deadlock.

### GitHub SourceLink
The new releases will now be tagged by [Microsoft.SourceLink.GitHub](https://github.com/dotnet/sourcelink), that will allow easier debugging with NLog source code available from Github. See also the [
Scott Hanselman blog](https://www.hanselman.com/blog/ExploringNETCoresSourceLinkSteppingIntoTheSourceCodeOfNuGetPackagesYouDontOwn.aspx)

### .NET Core Single File Publish
.NET Core 3 introduced a new feature called Single File Publish, that builds the entire application (with dotnet) as a single executable file. Microsoft failed to complete the illusion, so if checking the `AppDomain.BaseDirectory`, then one will get a secret temporary folder, where the single executable file has been unzipped to. 

NLog uses `AppDomain.BaseDirectory` as base directory for all relative paths. This means log files will not appear as expected, but are instead written to the secret temp folder. The current work-around is to explicitly specify `${basedir}` with this special option:

```xml
<target type="file" fileName="${basedir:fixtempdir=true}\App.txt" />
```

If wanting to support override of the `NLog.config`, that has been packaged into the single file (Ex. `SingleApp.exe`). Then one must rename `NLog.config` to `SingleApp.exe.nlog`. Then NLog will prioritize the `SingleApp.exe.nlog` placed next to the actual `SingleApp.exe`, but will fallback to `SingleApp.exe.nlog` in the secret temp folder.

Single File Publish can also be combined with `PublishTrimmed` that trims the single executable to a minimum. See also the [
Scott Hanselman blog](https://www.hanselman.com/blog/MakingATinyNETCore30EntirelySelfcontainedSingleExecutable.aspx)

```xml
<PublishSingleFile>true</PublishSingleFile>
<PublishTrimmed>true</PublishTrimmed>
<RuntimeIdentifier>win-x64</RuntimeIdentifier>
```

## Many other improvements

For a full list of all the enhancements and performance improvements: [NLog 4.7 Release Notes](https://github.com/NLog/NLog/releases/tag/v4.7)
