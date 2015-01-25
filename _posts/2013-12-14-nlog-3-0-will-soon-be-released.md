---
layout: post
title: NLog 3.0 will soon be released
excerpt: NLog 3.0 will soon be released
---

Since NLog 2.1 was released, I've focused on moving to a new build server and deciding what frameworks should be supported in future releases. The move to the new build server is almost complete, and support for some of the older frameworks will be dropped.

I've decided that the following no longer will be supported from NLog 3.0:

 * Compact Framework (all versions)
 * Silverlight 2 and 3
 * .NET 2.0
 * COM Interop
 * NLogC

The reason these frameworks no longer will be supported, is partly due to build server requirements, but most of all to reduce the complexity of NLog. Over time the complexity have increased exponentially, which in turn makes it difficult to create new features and fix bugs, and the only way I can see to fix this, is to drop support for some older frameworks. Overall this should decrease the time between releases, and make NLog more stable.

The reason for moving to a new build server, is that the old build server was starting to the get unstable, but also the improve the build pipeline. The improvements to the build pipeline will allow more frequent releases, and faster and better test feedback. Overtime this will allow me to reintroduce nightly builds, automate deployment again and run the tests for [Mono](http://www.mono-project.com/ "The Mono project").

Also installers will, at least for the moment, no longer be supplied, instead you should use [NuGet](http://nuget.org/ "NuGet") packages or download the binaries directly from the [GitHub release page](https://github.com/NLog/NLog/releases "GitHub release page").

As I see it, the future of NLog is bright, and hopefully more contributions will be made to both the NLog itself and [NLog-Contrib](http://github.com/NLog/NLog-Contrib "NLog Contrib"), actually I see the NLog-Contrib repository, as a way to test and develop new features, which could be included in the core at a later time. Using NLog-Contrib of this, decreases the release time, which in turn decreases the user feedback time which is invaluable.
