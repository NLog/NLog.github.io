---
layout: post
title: NLog nightly builds are now available
---

Nightly builds of NLog are now available on CodePlex. They are generated every night around 1AM PST which is 10AM in most of Europe. Builds are generated using [CruiseControl.NET](http://ccnetlive.thoughtworks.com/ccnet/doc/CCNET/) which is pretty awesome piece of software - except the fact that they don't use NLog yet :).

After each build, binaries are automatically pushed to CodePlex servers using [CodePlex Web Services API](http://codeplex.codeplex.com/wikipage?title=CodePlexWebServices&referringTitle=CodePlexAPI). Once the release is uploaded, a direct link to it is also placed on the [Download](http://nlog-project.org/download.html) page. I still haven't figured out how to delete older releases automatically because CodePlex API does not support this, so I'll be doing that manually for now.

You can subscribe to the RSS feed at [http://feeds.feedburner.com/nlogreleases](http://feeds.feedburner.com/nlogreleases) to be notified about new builds.