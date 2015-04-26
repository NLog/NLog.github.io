---
layout: post
title: NLog 3.2.1 has been released
---

NLog 3.2.1 has been released yesterday. The release contains the following bug fixes:

- The default timeout on the SMTP target could lead to connection issues. This has been resolved.
- The stack trace renderer was broken since 3.2.0 with the addition of the blacklist assembly feature. Both are working correctly now. 
- In 3.2.0  ['Programmatic access to variables defined in configuration file'](http://nlog-project.org/2015/01/12/nlog-3-2-0-is-released.html#programmatic-access-to-variables-defined-in-configuration-file) 
was featured. Unfortunately, the posted example was not working. 
It's now possible to access the variables with the use of `LogManager.Configuration.Variables`.

Unit tests have been added for the above issues to prevent regression bugs. 
Details of the bug fixes can be seen on [the GitHub milestone](https://github.com/NLog/NLog/issues?q=milestone%3A3.2.1)



Last, but certainly not least: thanks for reporting these issues! 


