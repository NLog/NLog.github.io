---
layout: post
title: NLog roadmap, .NET Core, stuctural logging, performance
---

We have the following releases planned for NLog:


### NLog 4.3.8, File Target performance
We have noticed that the performance of the File Target in NLog 4.3 is much slower than NLog 4.2. Arround 4 times. Oops

After some investigation, the support for relative paths for the File Target is to blame. 
We use `Path.GetFullPath` for that, and that method is slow. As the filename could change every write, we didn't added any cache on it. 
This is fixed in NLog 4.3.8 and the performance is fully back! 

### NLog 4.4

#### no .NET Core

Originally NLog 4.4 would have .NET Core support. We have released a lot alpha and beta releases with support .NET Core (or to be precise .NET Standard).
Too bad there is a show-stopper, the behaviour of `GetCurrentClassLogger` is wrong and we can't fix it as the StackFrame API is limited in .NET Core 
(see [here](https://github.com/dotnet/corefx/issues/1797)). You can read more about it [here](https://github.com/NLog/NLog/issues/1379#issuecomment-235696767). 
We will prospone .NET Core support to NLog 5.

Will this delay a RTM with .NET Core support? Yes. As long as the StackFrame API is missing, we can't fix it. 

#### Structural logging

We like to support structural logging like Serilog. We are currently working on an own parser and renderer. More info [here](https://github.com/NLog/NLog/issues/1376).

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


### NLog 5
NLog 5 will have .NET Core support and we will push some small breaking chances. The breaking changes will be small!

### NLog 6
NLog 6 will split all the functionality to multiple packages. Why is this not in NLog 5? 
Well the .NET Core support consists of more than 250 commits and almost 400 changed files.
If something is broken by those changes, it's easier to find the previous code if we won't move all the code around!
