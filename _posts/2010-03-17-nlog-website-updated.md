---
layout: post
title: NLog website updated
---

Large portion of the NLog website has just been migrated from static html pages to [WordPress](http://wordpress.org/).

Previously most of the navigation (menus and static pages such as download, faq, documentation) was done using static pages generated using XSLT templates while the dynamic part (blog and some pages) was done in WordPress. They looked seamless, but it required a lot of work and made updating the site unnecessarily brittle, because each time I had to touch two places in two completely different technologies. Now that everything is in WordPress I can finally use [Windows Live Writer](http://windowslivewriter.spaces.live.com/)!

(Note that documentation for targets/layout renderers/etc. is still generated but that's pretty much the only thing that's left)

Please let me know if you find any glitches or other problems as a result of the migration.