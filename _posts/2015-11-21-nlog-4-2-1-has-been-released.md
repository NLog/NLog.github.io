---
layout: post
title: NLog 4.2.1 has been released!
---

Release notes:

- Show warning for Databasetarget.UseTransactions instead of exception. 
- NetworkTarget: improved performance, allow configuring of max connections. See [wiki](https://github.com/NLog/NLog/wiki/Network-target).
- Filetarget: Max archives settings sometimes removes to many files. 
- Prevent Collection was modified (ObjectGraphScanner.ScanProperties) 
- General memory pressure improvements. 
- LogReceiverWebServiceTarget.CreateLogReceiver() should be virtual 
- VariableLayoutRenderer does not work with Custom LogManagers.
