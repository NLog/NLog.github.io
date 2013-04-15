---
layout: post
title: NLog 2.0: Small API reorganizations and breaking changes
---

I just checked a set of API changes, which may break code which uses recent nightly builds from NLog 2.0 branch. If you are upgrading to the latest build (2010.06.11.01 or newer) you may need to update your code:

 * **NLog.Targets.Compound** namespace was removed and classes were merged into **NLog.Targets.Wrappers** namespace. In NLog 2.0 there is no distinction between wrappers and compound targets – they will be collectively referred to as wrappers.
 * **NLog.Contexts** namespace was removed and classes were merged into **NLog** namespace (this is actually the situation we had in NLog 1.0, so this change is really undoing previous breaking change which was unnecessary)

The changes are consistent with general [breaking change policy](http://nlog-project.org/2009/10/19/nlog-2-backwards-compatibility-and-breaking-change-policy.html) and should not impact people only using file-based configuration and simple logging APIs.