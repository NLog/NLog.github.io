---
layout: post
title: Using NLog with Mono
---

After releasing NLog 2.0 a number of people have reported problems with running on latest versions of Mono. Basically at the end of program execution (after the Main() has finished) the program locks up waiting for NLog logs to be flushed, so mono process never completes and needs to be killed.

This behavior is only specific to NLog 2.0 - NLog 1.0 did not exhibit this behavior. It seems to be related to threading and timers used by NLog 2.0 which are somehow not available in Mono when the program is about to be terminated. The same code works with .NET just fine. I haven't fully investigated this issue - maybe Mono folks can see if this issue can be fixed in Mono itself?

Anyway - there is a simple way prevent the deadlock: just make sure you set LogManager.Configuration property to null before your application exits. This will cause Flush() to be executed before Main() finishes and will prevent appdomain unload handler from locking up.

In NLog 2.0.0.2005 (nightly build - available on CodePlex, source code on GitHub as usual) I have disabled automatic flushing of logs in Mono builds. That means that when running on Mono (same as with Silverlight and .NET Compact Framework), it is developer's responsibility to flush logs before program exits. I'm hoping to restore automatic flushing behavior when the issue is fixed in Mono or if I can find a way to work around the problem.