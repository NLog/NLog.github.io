---
layout: post
title: First preview build of NLog 2.0 is available
---

Very experimental first build of NLog from 2.0 branch is available for download. It's not alpha, beta or even gamma, just a preview of upcoming changes for those adventurous enough to try it out. My primary goal for this preview release is **making sure there are no unintended [breaking changes](http://nlog-project.org/2009/10/19/nlog-2-backwards-compatibility-and-breaking-change-policy.html)**.

I would greatly appreciate your help in making sure the code which uses NLog 1.x continues to work with NLog 2.0 (in both source and binary-compatibility situations). Please report any issues as comments under this post.

Summary of changes:

 * Entire code base has been ported to C# 3.0, cleaned up and simplified.
 * This release has been compiled against the following frameworks:
   * Silverlight 2.0 and 3.0
   * .NET Framework 2.0
   * .NET Framework 3.5 (client and extended profile)
   * .NET Framework 4.0 Release Candidate (client and extended profile)
   * Mono 2.x
   * .NET Compact Framework 2.0 and 3.5
 * Support for pre-2.0 versions of the .NET Framework and Mono has been removed
 * Logging pipeline and extensibility interface (targets, layout renderers, layouts, filters, etc.) has been completely redesigned for better maintainability
 * Added support for [wrapper layout renderers](http://nlog-project.org/2008/11/22/wrapper-layout-renderers-are-coming-to-nlog.html)

Please consult [breaking change policy](http://nlog-project.org/2009/10/19/nlog-2-backwards-compatibility-and-breaking-change-policy.html) for information about expected behavior. I would like to make sure logging APIs and configuration files continue to work without having to modify your code.

Download sources and binaries from [http://nlog.codeplex.com/releases/view/41859](http://nlog.codeplex.com/releases/view/41859)<br />
Documentation: [http://nlog-project.org/doc/2.0/](http://nlog-project.org/doc/2.0/)