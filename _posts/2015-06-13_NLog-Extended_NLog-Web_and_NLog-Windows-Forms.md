---
layout: post
title: NLog.Extended, NLog.Web and NLog.Windows.Forms
---

With the release of NLog 4.0 we have split the package NLog.Extended to NLog.Web and NLog.Windows.Forms. 
This will give us the oppunity to clean up the references in NLog.Extended. 
There are also some targets still in NLog.Extended, we will also create new packages for those in the future.

For now this this will results in:

- NLog.Web contains the targets and layout-renderes specific to ASP.Net and IIS.
- NLog.Windows.Forms contains targets specific for Windows.Forms
- All other are in NLog.Extended - This is for currently only the MSMQ target and `${appsetting}` layout renderer.


This wasn't communicated in the NLog 4.0 release post - which lead to upgrade issues - we are sorry for that. The NLog 4.0 release post will be fixed.
