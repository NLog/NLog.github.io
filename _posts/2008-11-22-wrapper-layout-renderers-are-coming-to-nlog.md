---
layout: post
title: Wrapper Layout Renderers are coming to NLog 2.0
---

NLog v2 branch has a new cool feature called Wrapper Layout Renderers which would help me restructure code to make it more maintainable and testable. I'd like to hear your opinion about it.

What are Wrapper Layout Renderers (WLRs)?
-----------------------------------------
Similar to wrapper targets, WLRs can modify output of other layout renderers, by doing textual transformations like:

 * uppercase/lowercase conversion
 * padding, trimming, alignment
 * search/replace
 * elision of excessive text
 * encryption / masking of sensitive information
 * cryptographic transformations (calculating MD5, SHA1 hashes, HMAC checksums)
 * encoding: base64/uuencode, etc.

Note that in NLog v1 many of those concerns are handled by LayoutRenderer itself. Being able to separate them into standalone, extensible classes is very convenient as you can add them separately and all existing layout renderers will be able to benefit from them.
 
Here's how you use them:

 * **${uppercase:${level}}** - will print log level in uppercase
 * **${rot13:${message}}** -  will print ROT13 "encrypted" message
 
For configuration file compatibility, you will still be able to use uppercase, lowercase, padding attributes that you know from NLog v1 directly on layout renderers etc.
 
To implement a wrapper, all you have to do is to create a class derived from WrapperLayoutRendererBase that overrides the Transform() method and apply the usual LayoutRenderer attribute.
Here's the ROT13 wrapper, which implements Caesar's cipher.
 
<code>
<pre>
[LayoutRenderer("rot13")]
public sealed class Rot13LayoutRendererWrapper: WrapperLayoutRendererBase
{
    protected override string Transform(string text)
    {
        return DecodeRot13(text);
    }
}
</pre>
</code>
 
You can of course define public properties as be able to set their values as with regular layout renderers.
I'm planning to add an additional concept called ambient properties which will help maintain NLog v1 compatibility while being very extensible. Ambient properties are properties that appear as if they were present on all layout renderers and when you actually use them, they add an implicit wrapper. This allows you to write: **${level:uppercase=true:padding=-10}** instead of **${padding:padding=-10:${uppercase:${level}}}**

Whenever layout parser encounters an unknown property (such as "uppercase" which doesn't exist on LevelLayoutRenderer anymore) it will look for layout renderers which define **\[AmbientProperty("UpperCase")\]** and will instantiate them and use to wrap the original layout renderer:

<code>
<pre>
[LayoutRenderer("uppercase")]
[AmbientProperty("UpperCase")]
public sealed class UpperCaseLayoutRendererWrapper : WrapperLayoutRendererBase
{
    private bool _upperCase = false;
    public bool UpperCase
    {
        get { return _upperCase; }
        set { _upperCase = value; }
    }
    protected override string Transform(string text)
    {
        return UpperCase ? text.ToUpperInvariant() : text;
    }
}
</pre>
</code>