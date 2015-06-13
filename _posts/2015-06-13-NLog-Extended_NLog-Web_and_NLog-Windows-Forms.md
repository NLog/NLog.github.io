---
layout: post
title: NLog.Extended, NLog.Web and NLog.Windows.Forms
---

With the release of NLog 4.0 we have split the package [NLog.Extended](https://www.nuget.org/packages/NLog.Extended/) to [NLog.Web](https://www.nuget.org/packages/NLog.Web/) and [NLog.Windows.Forms](https://www.nuget.org/packages/NLog.Windows/Forms/). 
This will give us the opportunity to clean up the references in NLog.Extended. 
There are also some targets still in NLog.Extended, we will also create new packages for those in the future.

For now this this will results in:

- [NLog.Web](https://www.nuget.org/packages/NLog.Web/) contains the targets and layout-renderes specific to ASP.Net and IIS. Version 2.0 is compatible with NLog 4.0
- [NLog.Windows.Forms](https://www.nuget.org/packages/NLog.Windows/Forms/) contains targets specific for Windows.Forms. Version 2.0 is compatible with NLog 4.0
- All other are in [NLog.Extended](https://www.nuget.org/packages/NLog.Extended/) - This is for currently only the MSMQ target and `${appsetting}` layout renderer. Version 4.0 is compatible with NLog 4.0


This wasn't communicated in the [NLog 4.0 release post](http://nlog-project.org/2015/06/09/nlog-4-has-been-released.html) - which could lead to upgrade issues - we are sorry for that. The NLog 4.0 release post will be fixed.
