---
layout: post
title: NLog packaging options
---

I'm trying to figure out what kind of packaging would be most appropriate for NLog 2.0 and I would like to hear your opinion on this matter.

Given that there are going to be at least 9 supported frameworks (and new ones will likely be added - such as Silverlight for Windows Mobile), putting everything into a single exe/msi is not practical. The size would be huge (about 16 MB in compressed msi/30 MB expanded on disk) and that's mostly because of API documentation in CHM format which adds around 2MB per framework. The library itself is and will likely remain small and because it's MSIL it compresses really well.

So here are the options I'm considering (for simplicity I'm omitting the fact that there will be two flavors: Release and Debug and some common packages such as sources):

 1. One package with binaries and documentation for each framework
  1. NLog-2.0-NetFx20.msi / zip
  2. NLog-2.0-NetFx35.msi / zip
  3. NLog-2.0-NetFx40.msi / zip
  4. NLog-2.0-SL2.msi / zip
  5. NLog-2.0-SL3.msi / zip
  6. NLog-2.0-SL4.msi / zip
  7. NLog-2.0-NetCf20.msi / zip
  8. NLog-2.0-NetCf35.msi / zip
  9. NLog-2.0-Mono.msi / zip
 2. One package with binaries and documentation for each version of Visual Studio which would include all the frameworks it supports + separate downloads for individual frameworks:
  1. NLog-2.0-VS2008.msi / zip (would include NetFx20,NetFx35,SL2,SL3,NetCF20,NetCF35)
  2. NLog-2.0-VS2010.msi / zip (would include NetFx20,NetFx35,NetFx40,SL3,SL4)
  3. NLog-2.0-NetFx20.msi / zip
  4. NLog-2.0-NetFx35.msi / zip
  5. NLog-2.0-NetFx40.msi / zip
  6. NLog-2.0-SL2.msi / zip
  7. NLog-2.0-SL3.msi / zip
  8. NLog-2.0-SL4.msi / zip
  9. NLog-2.0-NetCf20.msi / zip
  10. NLog-2.0-NetCf35.msi / zip
  11. NLog-2.0-Mono.msi / zip
 3. One package with binaries and documentation for each family of frameworks:
  1. NLog-2.0-NetFx.msi / zip (would include NetFx20, NetFx35, NetFx40)
  2. NLog-2.0-Silverlight.msi / zip (would include SL2,SL3,SL4)
  3. NLog-2.0-CompactFramework.msi / zip (would include NetCf20, NetCf35)
  4. NLog-2.0-Mono.zip
 4. Only one package with binaries and documentation which would include the most common frameworks only, other frameworks would be available as separate downloads as in option#1
  1. NLog-2.0.msi / zip (would include NetFx35, NetFx40, SL4)
  2. NLog-2.0-NetFx20.msi / zip
  3. NLog-2.0-NetFx35.msi / zip
  4. NLog-2.0-NetFx40.msi / zip
  5. NLog-2.0-SL2.msi / zip
  6. NLog-2.0-SL3.msi / zip
  7. NLog-2.0-SL4.msi / zip
  8. NLog-2.0-NetCf20.msi / zip
  9. NLog-2.0-NetCf35.msi / zip
  10. NLog-2.0-Mono.msi / zip
 5. One big package (msi/zip) with all binaries, but without documentation (about 2.5MB msi, 11MB installed). Documentation would be available online or as a separate download.

Which one of these would you prefer?