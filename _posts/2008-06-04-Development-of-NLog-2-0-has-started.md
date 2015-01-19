---
layout: post
title: Development of NLog 2.0 has started
---

Main focus of this release will be extending support to new platforms (such as .NET Framework 3.5/LINQ, Silverlight 2.0, .NET Compact Framework 3.5) and environments (ASP.NET, WCF, etc) as well as code cleanup and improved robustness and internal architecture. Support for .NET 1.x will be removed, but config-file compatibility and basic binary compatibility will be preserved.

I am thinking of serious cleanup of NLog code base and build process to make entire product easier to maintain in the future and more approachable. Here are the changes I'm planning to make:

 1. Replace the use of NDoc (which is essentially dead) with Sandcastle for documentation generation.
 2. Deprecate/Remove suppport .NET 1.x and .NET Compact Framework 1.x (NLog 1.0 will stay around to support older frameworks, I don't want legacy code to remain there in NLog 2.0).
 3. No more “universal” release (which was built with .NET 1.0 and used many runtime tricks to detect and compensate for platform differences). Instead targeted builds will be available for all frameworks.
 4. Add generics to Logger (replace generated code with generic methods) - will maintain source-level compatibility but will break IL-level compatibility.
 5. Move to a single build system (MSBuild). Remove NAnt, VS2003 and compact framework projects. Simple msbuild techniques will be used to produce builds for all supported platforms instead.
 6. Evaluate the possibility of using LINQ-style lambdas to do deferred evaluation of layouts and/or log messages, something like:<br />
 logger.Debug(()=> "asdasd" + i);     // lambda here will not be evaluated if logging is disabled for Debug level.<br />
 <strong>Rationale</strong>: Many people still try to use string concatenation (which kills performance) instead of String.Format-style when passing log messages. Lambdas have the potential to make that easier while maitaining high speed.
 7. Simplify website/documentation generation. Sandcastle may help here.
 8. Switch to MSI installers generated using Wix
