---
layout: post
title: NLog 4.0.1 has been released. 
---

We just released a patch release for 4.0. This release fixes the following problems:

* The auto-load of the extensions was not working in combination with ASP.NET.
* Autoflush was not optimal implemented.
* We reverted an unneeded breaking change in `MailTarget`. The `SMTP` property is not required anymore. This is consistent with 3.x.
* Loading the NLog config from an embedded resource is now working. 
* Writing to files could lead to `OverflowExceptions` in 64-bit runtime. This was a bug since NLog 2.0.
* Some obsolete texts are corrected.

Thanks for reporting those issues and creating Pull Requests! Without your help we could not release of 4.0.1 on short time.
