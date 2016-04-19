---
layout: post
title: NLog 4.3 has been released!
---

After three RC releases, NLog 4.3 has been released! With more than 150 issues closed, this is one of the largest release since years. 
Main features: Xamarin support, Windows Phone 8 support, improved error handling and logging of NLog self and a lot of bug fixes!

The release can be downloaded from [NuGet](https://www.nuget.org/packages/NLog/4.3.0). 

Check for all the details the [GitHub 4.3 milestone](https://github.com/NLog/NLog/issues?q=milestone%3A4.3+is%3Aclosed). 

For those who have contributed to NLog, big thanks!


## Features

This release contains the following features:


### Support Windows Phone 8, Xamarin Android and Xamarin iOS (beta)
In NLog 4.3 support has been added for the following platforms:
 Windows Phone 8, Xamarin Android and Xamarin iOS. 
The support is still in beta as we didn't get the unit tests running.

Not every feature is working on those platforms, for example auto reloading the 
configuration is not supported in Xamarin. A full overview of what is supported
on each platform can be viewed [on the wiki](https://github.com/NLog/NLog/wiki/platform-support).



### Consistent handling of exceptions (BEHAVIOUR CHANGE)

The logging and throwing of exceptions was previously inconsistent. 
Not all of it was logged to the internal logger and some times they got lost. 
For example, the async wrapper (or async attribute) was catching all exceptions without a proper rethrow.

This is bad as it is sometimes unclear why NLog isn't working (got it myself multiple times). 
This has been fixed in NLog 4.3!

- All exceptions are logged to the internal logger
- The "throwExceptions" option will be respected in all cases


Advise: disable throwExceptions in production environments! (this the default)

```xml
<nlog throwExceptions="false">
```

### Control of exception throwing for configuration errors
The following is stated in multiple locations: 
>  By default exceptions are not thrown under any circumstances.

This was not true for configuration errors - those were always rethrown in the past.
If you change the config at runtime, this could lead to exceptions to the users!

We now introduce the "throwConfigExceptions" option:


```xml
<nlog throwConfigExceptions="true|false|<empty>">
```

```csharp
LogManager.ThrowConfigExceptions = true | false | null
```

- If set to `true`, if will throw exceptions for configuration errors. 
Set this to `true` if you like the behaviour from NLog 4.2 and ealier.
- If set to empty (or `null` in the API), this option will follow the "throwExceptions" option (previous section)
- If set to `false`, don't throw exceptions for configuration errors. 

Also throwing exceptions for a configuration error  
could lead to `System.TypeInitializationException` which is bad and confusing as sending info with the exception is difficult or sometimes impossible 
- see [stackoverflow](http://stackoverflow.com/questions/34994470/better-typeinitializationexception-innerexception-is-also-null).


### API improvements
There are some notable changes in the API, so it's easier to create or edit the configuration in C# 
(or other .Net language).
The existence of the `SimpleConfigurator` was a hint things weren't simple enough ;)

Changes:

-  `LogManager` has now `AddRule` methods. See examples below.
- Set the max log level in the `LoggingRule` constructor.
- The name of the `TargetAttribute` is used as fallback for every target now. 

#### `LogManager` now has `AddRule` methods
Rules can now be created directly in the `LogManager`. 
There are some overloads to keep things simple.

Before:

```csharp
var config = new LoggingConfiguration();
var fileTarget = new FileTarget();
config.AddTarget("f1", fileTarget);
config.LoggingRules.Add(new LoggingRule("*", LogLevel.Debug, LogLevel.Error, fileTarget));
LogManager.Configuration = config;

```

now also possible:

```csharp
var config = new LoggingConfiguration();
var fileTarget = new FileTarget("f1");
config.AddTarget(fileTarget);
config.AddRule(LogLevel.Debug, LogLevel.Fatal, "f1");  
LogManager.Configuration = config;

```
or

```csharp
var config = new LoggingConfiguration();
var fileTarget = new FileTarget {name: "f1"};
config.AddRule(LogLevel.Debug, LogLevel.Fatal, fileTarget);
LogManager.Configuration = config;

```




### Relative paths for fileTarget
FileTarget now supports relative paths. No need for `${basedir}` in the file target anymore!


### InternalLogger: write to System.Diagnostics.Trace 
It's now possible to write to let the internal logger write to `System.Diagnostics.Trace`. 
The trace is easy to follow within Visual Studio.

![image](https://cloud.githubusercontent.com/assets/5808377/13997991/f76fd65a-f134-11e5-8e9d-bd3d532b248c.png)


```xml
<nlog internalLogToTrace="true" 

```

or 
```c#
InternalLogger.LogToTrace = true;
```



### Other features
Smaller improvements

#### Targets

- Mail Target: allow virtual paths for SMTP pickup 
- EventTarget: option to set the maximum length of the message and action (discard, split, truncate)
- MethodCallTarget: allow optional parameters in called methods.
- ConsoleTarget: regex cache is instead of compiled regex, for better memory usage. This is configurable. 
- Database target: doesn't require "ProviderName" attribute when using `<connectionStrings>`

#### Layouts
- RegistryLayout: support for layouts, RegistryView (32, 64 bit) and all root key names (HKCU/HKLM etc)

#### API
- Allow to free CallContext in `MappedDiagnosticsLogicalContext`
- LogFactory: add generic-type versions of `GetLogger()` and `GetCurrentClassLogger()`
- Added `Logger.Swallow(Task task)`

#### Other


- Unused targets will be logged to the internal logger
- Config classes are now thread-safe.
- InternalLogger: improved logging of exceptions (analogous to normal Logger)
- More logging to the internal logger (e.g. Async wrapper and buffer wrapper)
- Added timestamp options for the internal logger:
  - Added "internalLogIncludeTimestamp" option to `<NLog>` 
  - Added "nlog.internalLogIncludeTimestamp" option `<appSettings>`
  - Added `NLOG_INTERNAL_INCLUDE_TIMESTAMP` environment setting
- NLog reads NLog.Config from Android Assets.



## Bug fixes
Various bugs have been fixed in this version. The most noticeable:

- `${callsite}` works now for async methods!
- A **lot of** Filetarget bug fixes regarding with archiving, locking and concurrent writing. 
See [GitHub issues](https://github.com/NLog/NLog/issues?q=milestone%3A4.3+is%3Aclosed+label%3Afile-target) for all details.
 Most noticeable:
   - Use last-write-time for archive file name. This is far more stable. 
    In the past there were some issues with unexpected archive filenames.
   - Fix: archiving won't work when a there is a date in the filename
   - Fix: archiving not working properly with AsyncWrapper
   - Fix: footer for archiving
   - Fix: crashes with relative path without `${basedir}` 
   - Fix: archive files are never created when there are lot of writes in log file 
   - Fix: writing file to root wasn't working
- NetworkTarget: fix possible deadlock
- Fix autoreload nlog.config with parent configs. 
- WebServiceTarget: fix HTTP GET protocol
- Bugfix: Internallogger creates folder, even when turned off
- Fix possible Nullref in `${variable}`
- `${processtime}`: incorrect milliseconds formatting
- `${processtime}`: fix incorrect negative time (rounding issue)


## Thanks to!!


- [bhaeussermann](https://github.com/bhaeussermann)
- [breyed](https://github.com/breyed)
- [brutaldev](https://github.com/brutaldev)
- [bryjamus](https://github.com/bryjamus)
- [eduardorascon](https://github.com/eduardorascon)
- [epignosisx](https://github.com/epignosisx)
- [Kaykins](https://github.com/Kaykins)
- [kt1996](https://github.com/kt1996)
- [michaeljbaird](https://github.com/michaeljbaird)
- [MikeFH](https://github.com/MikeFH)
- [nathan-schubkegel](https://github.com/nathan-schubkegel)
- [neris](https://github.com/neris)
- [Niklas-Peter](https://github.com/Niklas-Peter)
- [Page-Not-Found](https://github.com/Page-Not-Found)
- [pysco68](https://github.com/pysco68)
- [rellis-of-rhindleton](https://github.com/rellis-of-rhindleton)
- [sorvis](https://github.com/sorvis)
- [UgurAldanmaz](https://github.com/UgurAldanmaz)
- [vincechan](https://github.com/vincechan)





