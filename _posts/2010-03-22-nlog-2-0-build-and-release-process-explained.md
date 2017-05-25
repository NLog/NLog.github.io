---
layout: post
title: NLog 2.0 build and release process explained
---

I've spent last couple weeks working on tools to support NLog 2.0 release process. Releasing library such as NLog which targets 8 frameworks is not an easy task and requires some pretty sophisticated automation support.

Each NLog release consists of several files:

 * **NLog.dll** and **NLog.Extended.dll** - NLog library
 * **NLog.xml** and **NLog.Extended.xml** - API documentation extracted from source code comments
 * **NLog.xsd** - schema information used to author and validate NLog configuration files
 * **NLog.chm** - documentation for each platform

Because each supported platform is slightly different (in terms of targets, layout renderers, etc.) a separate version of each artifact must be produced for every build.

Let's take a look at the process which produces all of these:

<img src="/images/posts/buildprocess.png">

Step 1: Compilation
-------------------
At the very beginning, source files are compiled using csc.exe to produce NLog.dll and NLog.xml (additionally NLog.Extended.dll and NLog.Extended.xml for platforms which need it). This is using standard C# compiler functionality and there is nothing really fancy here. Maybe except for the fact that StyleCop is being used to make sure that in-source documentation is consistent and follows some established patterns.

Step 2: API Dump
----------------
The next step is to analyze output assemblies using reflection and extract information about targets, layout renderers, etc. that have been compiled in. This is done using DumpApiXml.exe and the result is a file called NLog.api - one for each supported platform. The reason why a dump file is being used is to simplify further processing: documentation, XSD and website generators can rely only on the API file without the need to duplicate (relatively complex) reflection code.

The API dump includes information about each target in a format that's friendly for XSLT processing and includes pre-calculated pieces of information such as URI slugs, inline XML documentation, etc.

<img src="/images/posts/xmldocumentation.png">

Step 3: Conceptual documentation generation
-------------------------------------------
Before NLog.chm can be generated we need to generate conceptual documentation which explains configuration file format for each target, layout renderer, etc. This is all done by MakeApiDoc.exe and uses NLog.api for each platform, generated in the previous step. The result is a bunch of \*.aml files which will be used by SHFB later. (Note that MakeApiDoc.exe is not checked in into public NLog repository yet).

Step 4: XSD schema generation
-----------------------------
Similar to conceptual documentation, NLog.xsd is also generated from NLog.api - the result is a document with documented XSD types and elements which can be used in Visual Studio to provide Intellisense(tm) for authoring and validating NLog.config. (Note that MakeNLogXsd.exe in the public repository is not up-to-date yet and does not use NLog.api, instead it's an older version from NLog 1.0 which uses reflection. It will be updated soon.)

Step 5: Website generation
--------------------------
NLog.api will also be used to generate documentation for the website, which includes:

 * targets.html
 * layoutrenderers.html
 * filters.html
 * layouts.html
 * conditions.html
 * conditionmethods.html
 * and individual documentation pages for each target, layout renderer, etc.

The website will be generated using simple XSLT stylesheet, which is possible thanks to the relatively simple api file format. Since users will not need to generate the website, the tools used here will not be part of the NLog release.

Step 6: Documentation generation
--------------------------------
Having assemblies, code comments (generated in step 1) and conceptual documentation (generated in step 3) we can finally launch [SHFB](http://shfb.codeplex.com/) to generate documentation each platform. The documentation is produced in two formats:

 * NLog.chm - compiled help file which will be included in the download
 * website files - which you can [browse on the web](http://nlog-project.org/doc/)

Step 7: Installer
-----------------
The last remaining steps in getting NLog ready for release will be packaging. Most likely this is going to be automated using [WIX](http://wix.sourceforge.net/), but I did not get to that part yet.
