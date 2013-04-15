---
layout: post
title: New, smaller NLog installer is available
---

I've just checked in code changes to produce much smaller installer packages for NLog 2.0. Until now, the combined installer package for all framework was 20.8MB, after the change it is less than 6 MB. What made the installer huge was not the size of NLog.dll (it is are between 200KB and 300KB depending on the platform), but the documentation: 9 chm files, each about 2MB. it was clearly a big waste, given that the documentation for most platforms is almost the same.

The new installer includes single documentation file generated from a special build of NLog with DOCUMENTATION flag turned on. The combined assembly includes superset of all APIs available for all platforms - the produced assembly won't necessarily run, but is good enough to generate documentation. The same technique was used in NLog 1.0 timeframe - I originally thought it would not work for 2.0 given large differences between .NET and Silverlight build, but now I think it is a reasonable compromise between the size and accuracy of the doc file.

The new suite of installers should show up on CodePlex in the next couple hours.