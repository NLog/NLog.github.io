This is the official NLog GitHub page, [nlog-project.org](https://nlog-project.org/).

Config targets, layouts and layout renderers:
===

The config of the targets, layouts and layout renderers:

- [config/targets.json](config/targets.json)
- [config/layouts.json](config/layouts.json)
- [config/layout-renderers.json](config/layout-renderers.json)

Those are visible and searchable on https://nlog-project.org/config

### Add a custom component

Do you like to have a custom target, layout or layout renderer listed https://nlog-project.org/config?

- Please make sure you docs are up-to-date. An example is really recommend.
- Send a PR for one of the JSON files

Add a news post 
===
How to add a new news post.

1. Create and new MarkDown file (`.md`) in the `_posts` folder, starting with the date (`yyyy-MM-dd`). Don't use spaces or extra dots in the filename! Don't forget the `.md` extension! 
2. Start the post with the [Jekyll front matter](https://jekyllrb.com/docs/frontmatter/), 
  * `layout: post` is required. 
  * Choose a good title after `title:`
  * Example
   ```
   ---
   layout: post
   title: NLog 3.2.0 has been released
   ---
   ```
3. Write some [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown/) and save the file. 

Notes
---
- The markdown parser is different compared to Github itself. So that means: different syntax sometimes: 
  - Code fences (triple tick) isn't working. See [NLog 4.0 release post](https://github.com/NLog/NLog.github.io/blob/master/_posts/2015-06-09-nlog-4-has-been-released.md)
I prefer markdown when it's possible (the hyperlink).
  - Lists should be prepended with a whiteline. 
- You can preview you changes to rename your fork to `<your-name>.github.io` and browse to it!
- Changes are visible in about a minute. 

Update version
===
Update `version` variable in [_config.yml](_config.yml)
