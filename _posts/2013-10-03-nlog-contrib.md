---
layout: post
title: NLog Contrib
excerpt: Introducing the NLog-Contrib repository
---

Almost 8 months ago, I silently created a the [NLog-Contrib](https://github.com/NLog/NLog-Contrib) repository. It has been empty most of the time, probably affected by the silent creation.

The repository is meant to be used for targets and other NLog extensions with external references, meaning it won't be merged into NLog itself. In my opinion the future of NLog involves more community contributions, allowing NLog itself to evolve more rapidly.

Now why should people use NLog-Contrib instead of creating a personal repository?  
Mainly because then contributions are located in a single place, where people could find the easily. The other aspect is that I often look at then contributions, and try to build them against the newest version of NLog, meaning contributors could get faster feedback when something breaks. Also the NuGet deployment, can be done by me.

Recently the first two contributions were made to the repository, NLog.ManualFlush and NLog.Elmah.  
The NLog-Contrib wiki will soon be updated with examples and description of the contributed targets.

## NLog.ManualFlush ## 
Is a wrapper which is used when you want to control the flushing yourself. Is useful when you only want to log to file under certain circumstances.

## NLog.Elmah ## 
Contributed by [Todd Meinershagen](https://github.com/toddmeinershagen), is used to log to [Elmah](https://code.google.com/p/elmah/).  