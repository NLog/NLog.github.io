---
layout: post
title: NLog.Extended, NLog.Web and NLog.Windows.Forms
---

With the release of NLog 4.0 we have split the package [NLog.Extended](https://www.nuget.org/packages/NLog.Extended/) to [NLog.Web](https://www.nuget.org/packages/NLog.Web/) and [NLog.Windows.Forms](https://www.nuget.org/packages/NLog.Windows.Forms/). 
This will give us the opportunity to clean up the references in NLog.Extended. 
There are also some targets and layout renderers still in NLog.Extended, we will also create new packages for those in the future.

For now this this will results in:

- [NLog.Web package](https://www.nuget.org/packages/NLog.Web/) contains the targets and layout-renderes specific to ASP.Net and IIS. Version 2.0 is compatible with NLog 4.0
- [NLog.Windows.Forms package](https://www.nuget.org/packages/NLog.Windows.Forms/) contains targets specific for Windows.Forms. Version 2.0 is compatible with NLog 4.0
- All other are in [NLog.Extended package](https://www.nuget.org/packages/NLog.Extended/) - This is for currently only the MSMQ target and `${appsetting}` layout renderer. Version 4.0 is compatible with NLog 4.0
- Please note: the classic ASP (so non-ASP.Net) are still in the [NLog package](https://www.nuget.org/packages/NLog/)


This wasn't communicated in the [NLog 4.0 release post](http://nlog-project.org/2015/06/09/nlog-4-has-been-released.html) - which could lead to upgrade issues - we are sorry for that. The NLog 4.0 release post will be fixed.


##Source code and issues
The new extension packages, NLog.Web and NLog.Windows.Forms have their own GitHub reposities. Please post questions, feature requests or bug reports to the related repository. 

* [NLog.Web on GitHub](https://github.com/NLog/NLog.Web)
* [NLog.Windows.Forms on GitHub](https://github.com/NLog/NLog.Windows.Forms)
* NLog.Extended is in the folder [NLog.Extended in the NLog GitHub repository](https://github.com/NLog/NLog/tree/master/src/NLog.Extended)


##Auto load
Because we introduced auto load of extentions in NLog 4.0 (see [news post](http://nlog-project.org/2015/06/09/nlog-4-has-been-released.html#auto-load-extensions)), there is no need for additional configuration. Just install NLog.Web, NLog.Windows.Forms and/or NLog.Extended with Nuget. 
