---
layout: post
title: Important NLog 2.0 milestone reached
---

Today marks the very important milestone of NLog 2.0 development - I now have fully automated set of NLog unit tests running on all supported platforms.

Why is this such a big deal? In NLog 1.0 timeframe I was not able to run automated unit tests in some environments (such as .NET Compact Framework which did not support NUnit). Because of that I had to resort to ad-hoc testing which unfortunately missed some pretty big bugs.

The .NET ecosystem has grown significantly in the last couple years, and because NLog 2.0 is going to support at least 5 versions of .NET Framework, 3 versions of Silverlight, 2 versions of .NET Compact Framework and Mono, the ability to run the entire test suite on all frameworks became even more important.

Common test library
-------------------
Since I wanted to use the same set of unit tests in all supported environments, I've decided to switch from NUnit-based tests to MSTest. Main reason was the fact that NUnit is not available for Silverlight and .NET Compact Framework and MSTest is available inside Visual Studio. Switching was relatively painless and in most cases was just a simple search/replace of using statements.

MSTest has the advantage of supporting all versions of .NET and .NET Compact Framework inside Visual Studio and is nicely integrated with the IDE. There are some annoyances, such as pretty [complicated debugging experience](http://blog.opennetcf.com/ctacke/2009/11/20/DebuggingSmartDeviceMSTESTUnitTests.aspx) with mobile devices, but I did not have to write almost any custom code to use it and there is no need for 3rd-party download, which is another plus.

Supporting Silverlight was a bit more tricky, because MSTest does not support it directly, but thankfully there is [Silverlight Toolkit](http://silverlight.codeplex.com/) on CodePlex which provides required libraries and test runner, which requires just a little bit of custom coding.

I still don't have automated test coverage in Mono, but I think it should be doable - if you know of some ready-to-use MSTest replacement for Mono (ideally one which works on Unix), please let me know.

Build System
------------
In NLog I've switched from NAnt to MSBuild as the build automation platform. MSBuild scripts have the huge advantage of being able to use them in Visual Studio directly while enabling deep customizations. MSBuild is installed as part of .NET Framework so almost everyone should already have it on their machines.

In order to make building and running tests in NLog a bit easier, I've created a batch file (**build.cmd**) which is a wrapper for MSBuild. It lets me select which platforms I want to build and test against and do everything in one shot.

In order to build NLog 2.0 for all supported platforms run:

<pre>
build.cmd
</pre>

To build and run tests for all platforms:

<pre>
build.cmd buildtests runtests
</pre>

If you want to only target specific frameworks, just put their mnemonics on the command line:

<pre>
build.cmd netfx20 netfx35client doc
</pre>

To generate documentation for Silverlight 2.0 and Silverlight 3 use:

<pre>
build.cmd sl2 sl3 doc
</pre>

You can produce full release of NLog (binaries and documentation for all platforms):

<pre>
build.cmd all
</pre>

There are many more options available, to find out what they are:

<pre>
build.cmd /?
</pre>

The working NLog 2.0 is available in Subversion [http://svn.nlog-project.org/repos/nlog/branches/NLog2/](http://svn.nlog-project.org/repos/nlog/branches/NLog2/), but I will be moving it soon to the trunk.