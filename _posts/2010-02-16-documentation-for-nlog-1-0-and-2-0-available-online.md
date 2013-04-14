---
layout: post
title: Documentation for NLog 1.0 and 2.0 available online
---

Documentation for NLog 1.0 is available online at [http://nlog-project.org/doc/1.0/](http://nlog-project.org/doc/1.0/)

Starting with NLog 2.0 there will be a separate documentation build for each supported framework. They will be all accessible from the following base url:

[http://nlog-project.org/doc/2.0/](http://nlog-project.org/doc/2.0/)

or you can jump directly to the documentation for your framework of choice:

 * NLog for .NET Framework 2.0
 * NLog for .NET Framework 3.5
 * NLog for .NET Framework 3.5 Client Profile
 * NLog for .NET Framework 4.0
 * NLog for .NET Framework 4.0 Client Profile
 * NLog for .NET Compact Framework 2.0
 * NLog for .NET Compact Framework 3.5
 * NLog for Silverlight 2.0
 * NLog for Silverlight 3.0
 * NLog for Mono 2.x

Note that conceptual documentation (tutorials, configuration information, etc.) is not included yet in NLog 2.0 builds and it will be added later.

Producing such a complex set of documentation was a real challenge. I used excellent [Sandcastle](http://sandcastle.codeplex.com/) and [Sandcastle Help File Builder](http://shfb.codeplex.com/) from CodePlex which helped a lot. Getting those tools to produce customized documentation for all NLog 2.x frameworks was a complex task with lots of custom scripting to support the build process.

As always – feedback is more than welcome.