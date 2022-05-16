---
layout: post
title: NLog 5.0 Finally Ready!
---

NLog 5.0 has completed preview testing, and is ready for release.

## Major Changes

- NLog ScopeContext replaces MDLC and MDC
- NLog Configuration from code with fluent `LogManager.Setup()`
- NLog DatabaseTarget extracted into its own [NLog.Database](https://www.nuget.org/packages/NLog.Database) nuget-package 
- NLog Extensions assemblies will not be loaded automatically, so [extensions must be explicitly added](https://github.com/NLog/NLog/wiki/Register-your-custom-component).
- .NET Standard takes over target-platforms Silverlight / WindowsPhone / Xamarin iOS / Xamarin Android
- Updated default values for better out-of-the-box experience
- Removed obsolete methods and properties

For more details see [List of major changes in NLog 5.0](https://nlog-project.org/2021/08/25/nlog-5-0-preview1-ready.html)

For full list of all changes: [NLog 5.0 PullRequests](https://github.com/NLog/NLog/pulls?q=is%3Apr+is%3Amerged+milestone:%225.0%20%28new%29%22)

## Credits
Additional thanks to contributers:

- @TalAloni
- @njqdev
- @menishmueli
- @ErickJeffries
- @AlanLiu90
- @aled
- @tetrodoxin
- @noamyogev84
- @simoneserra93
- @sjafarianm
- @Orace
- @GitHubPang
- @KurnakovMaksim