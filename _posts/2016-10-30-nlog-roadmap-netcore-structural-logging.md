---
layout: post
title: NLog roadmap, .NET Core, stuctural logging, performance
---

We have the following releases planned for NLog:


### NLog 4.4

#### no .NET Core, yet

Originally NLog 4.4 would have .NET Core support. We have released multiple alpha and beta releases with support .NET Core (or to be precise .NET Standard).
Too bad there is a show-stopper, the behaviour of `GetCurrentClassLogger` is wrong and we can't fix it as the StackTrace API is limited in .NET Core 
(see [here](https://github.com/dotnet/corefx/issues/1797)). You can read more about it [here](https://github.com/NLog/NLog/issues/1379#issuecomment-235696767). 
We will prospone .NET Core support to NLog 5.

Will this delay a RTM with .NET Core support? Yes. As long as the StackTrace API is missing, we can't fix it.
It seems that .NET Standard 2 (Q1 2017) will support the StackTrace API. 

#### Better handling of invalid config
Currently, some mistakes in the config could lead to no logging at all. 
For example, if I use `${aspnet-item}` in the file targt and I forgot to include NLog.Web, no files are written.

We will fix this in NLog 4.4 and we will replace the wrong part with an empty string. See [this PR](https://github.com/NLog/NLog/pull/1583).

#### Easier extending
A lot of feature requests could be easily implemented with writing a custom target or layout renderer. 
Right now it's a bit difficult to register your custom code. We will improve that.
Also a custom layout renderer should be as easy as one line of code:

```
LayoutRenderer.RegisterLayoutRenderer("trace-identifier", (logEvent) =>  HttpContext.Current.TraceIdentifier );
```

#### Steam and byte pooling (performance)
Currently under development, thanks to @bjornbouetsmith and @snakefoot!

This change will lower memory pressure and preventing (excessiv)e garbage collection 

For details, see [PR 1397](https://github.com/NLog/NLog/pull/1397) and and [PR 1663](https://github.com/NLog/NLog/pull/1663)

### NLog 4.5

#### Structural logging

We like to support structural logging like Serilog. We are currently working on an own parser and renderer. More info [here](https://github.com/NLog/NLog/issues/1376).

### NLog 5
NLog 5 will have .NET Core support and we will push some small breaking chances. The breaking changes will be small!

### NLog 6
NLog 6 will split all the functionality to multiple packages. Why is this not in NLog 5? 
Well the .NET Core support consists of more than 250 commits and almost 400 changed files.
If something is broken by those changes, it's easier to find the previous code if we won't move all the code around!
