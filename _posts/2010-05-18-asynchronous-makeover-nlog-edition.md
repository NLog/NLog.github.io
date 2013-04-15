---
layout: post
title: Asynchronous Makeover - NLog Edition
---

I just checked in code to enable asynchronous execution of wrappers in NLog. This is the last big architectural change before bug-fixing and stabilization for 2.0 release.

New features
------------
 * Exceptions thrown from wrappers such as AsyncTargetWrapper, BufferingTargetWrapper, AspNetBufferingTargetWrapper are now handled as opposed to being swallowed.
 * LogReceiverWebServiceTarget now handles asynchronous exceptions.
 * Exceptions from batch-aware targets are now handled for each item separately. It means that if you write 100 messages to a BufferedWrapper which wraps File target and one of those file writes fails, you will get 99 successes and 1 failure as opposed to one massive failure which no wrapper can reasonably handle. The same thing applies to email, etc.

There has been a small change to the design described in [the last post](http://nlog-project.org/2010/05/09/asynchronous-logging-in-nlog-2-0.html). Asynchronous continuations are represented as delegates instead of interface. It makes makes it much easier to use ad-hoc continuations in code without sacrificing composability.

Downloads
---------
The source code is available in [GitHub repository](http://github.com/NLog/NLog). I've published a private build from the master branch: [http://nlog-project.org/public/asyncpreview1/](http://nlog-project.org/public/asyncpreview1/).

I would appreciate people giving this build a spin and reporting any anomalies. Given the scope of changes and lack of unit tests in some areas I expect many things to be broken, so any usage in production is highly discouraged.