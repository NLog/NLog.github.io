---
layout: post
title: NLog 2.0 installer is available for testing
---

I've spent last couple nights working on MSI installer for NLog 2.0 and I have first version of MSI packages ready for testing. They should be reasonably usable - the code passes all unit tests but did not get much integration testing yet.

There are 5 installer packages:

 * .NET Framework package (NLog2-NetFX-PrivateBuild.msi - 8.4 MB) which includes NLog for .NET Framework 2.0, 3.5 and 4.0
 * Silverlight package (NLog2-SL-PrivateBuild.msi - 6.4 MB) which includes NLog for Silverlight 2.0, 3.0 and 4.0
 * Compact Framework package (NLog2-NetCF-PrivateBuild.msi - 4.6 MB) which includes NLog for .NET Compact Framework 2.0 and 3.5
 * Mono package (NLog2-Mono-PrivateBuild.msi - 3.1 MB) which includes NLog for .NET Compact Framework 2.0 and 3.5
 * Full package (NLog2-All-PrivateBuild.msi - 20 MB) which includes all 9 frameworks

Each package comes with Visual Studio integration, which supports VS2010, VS2008 and VS2005 (completely untested) and should have the same functionality as in NLog 1.0:

 * Code snippets for C# and VB (just type ‘nlogger' and it will include logger declaration)
 * Item templates for empty, console and typical log file
 * XSD for intellisense

Note that unlike in NLog 1.0, the installer installs those VS items for all users on the machine, not for the user who ran the installer.

Please also note that debug symbols (pdb/mdb), binaries and documentation for some older frameworks, such as Silverlight 2.0 and .NET Framework 2.0 are excluded by default - use custom or full installation to enable them.

Please give the installer a try on as many platform configurations as you can and report success/failure along with your configuration information as comments to this post. I'm particularly interested in testing the following dimensions:

 * various combinations of Visual Studio SKUs installed on the same machine (with or without add-on packages such as Silverlight SDK, Resharper, etc.)
 * different versions of Windows
 * x86 and x64 CPUs
 * non-English versions of Windows
 * non-English versions of Visual Studio

Thanks in advance for all your help.