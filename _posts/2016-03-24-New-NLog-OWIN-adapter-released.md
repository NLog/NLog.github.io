---
layout: post
title: New NLog OWIN adapter has been released
---

We're proud to announce that the former community project `NLogAdapter` is now part of NLog as `NLog.Owin.Logging` to provide a `Microsoft.Owin.Logging.ILoggerFactory` implementation for your OWIN pipeline.

Usage is as simple as:

```powershell
PM > Install-Package NLog.Owin.Logging
```

```csharp
using NLog.Owin.Logging;

public class Startup
{
    public void Configuration(IAppBuilder app)
    {
        app.UseNLog();
    }
}
```
