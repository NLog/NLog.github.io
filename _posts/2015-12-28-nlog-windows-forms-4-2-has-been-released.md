---
layout: post
title: NLog.Windows.Forms 4.2 has been released!
---

NLog.Windows.Forms 4.2 has been released including a new feature for the [RichTextBoxTarget](https://github.com/NLog/NLog.Windows.Forms/wiki/RichTextBoxTarget) — it is now possible to add clickable links to log messages.

## Features

This release contains the following features:

### RichTextBox links 

It is now possible to add clickable links to messages show in in the RichTextBox control and receive whole event info in the link click handler. 
To do this, set target's newly introduced `supportLink` parameter to `true` and use new [`${rtb-link}`](https://github.com/NLog/NLog.Windows.Forms/wiki/RTB-Link-Layout-Renderer) layout renderer to specify link part of the layout. 
To receive link click events, add a handler to `RichTextBoxTarget.LinkClicked` event. Use `RichTextBoxTarget.GetTargetByControl(RichTextBox control)` static method to access the target attached to a specific RichTextBox control.

Not sure how to use it? Here are few examples. 

#### Exception details example
When logging exceptions to RichTextBoxTarget you have to find a compromise between flooding the control with huge stacktraces and missing important information. Not anymore! Now you may long only a short description into textbox, and show whole details when user clicks a link:

<img src="/images/posts/2015/12/link_exception_details_click.png">

Just setup a proper layout (don't forget to enable `supportLinks`)

{% highlight xml %}
<target xsi:type="RichTextBox"
   layout="${message}${onexception:inner= ${exception:format=Message} ${rtb-link:details}}"
   ....
   supportLinks="true"
   ....
   />
{% endhighlight %}

And add a link click handler:

{% highlight c# %}
public Form1()
{
    InitializeComponent();
    RichTextBoxTarget.ReInitializeAllTextboxes(this); //more on this later
    RichTextBoxTarget.GetTargetByControl(richTextBox1).LinkClicked += Form1_LinkClicked;
}

private void Form1_LinkClicked(RichTextBoxTarget sender, string linkText, LogEventInfo event)
{
    MessageBox.Show(event.Exception.ToString(), "Exception details", MessageBoxButtons.OK);
}
{% endhighlight %}

#### Focusing at specific item example
Sometimes you may need to not only notify user of some problem (like validation failing), but also help him navigate to the problematic item (for example when the list is huge). In this case you may store item's id of some sort in the [`LogEventInfo.Property`](https://github.com/NLog/NLog/wiki/EventProperties-Layout-Renderer), turn it into a link and navigate to the item in link click handler:

<img src="/images/posts/2015/12/event_properties_link_click.png">

The layout:

{% highlight xml %}
<target xsi:type="RichTextBox"
            layout="${message} ${rtb-link:${event-properties:item=Index}}"
            ....
            supportLinks="true"
            ....
            />
{% endhighlight %}

Validation code:

{% highlight c# %}
private void validateButton_Click(object sender, EventArgs e)
{
    logger.Info("Validation started");
    foreach (ListViewItem item in listView1.Items)
    {
       if (item.SubItems[1].Text.Contains("bad"))
       {
            logger.Info()
               .Message("Validation failed on line")
               .Property("Index", (int)item.Tag)
               .Write();
            return;
        }
    }
    logger.Info("Validation succeeded");
}
{% endhighlight %}

Event handling code:

{% highlight c# %}
public Form2()
{
    InitializeComponent();
    RichTextBoxTarget.ReInitializeAllTextboxes(this);
    RichTextBoxTarget.GetTargetByControl(richTextBox1).LinkClicked += Form2_LinkClicked;
}

private void Form2_LinkClicked(RichTextBoxTarget sender, string linkText, LogEventInfo event)
{
    int lineIndex = (int)event.Properties["Index"];
    listView1.EnsureVisible(lineIndex);
    listView1.SelectedIndices.Add(lineIndex);
    listView1.Select();
}
{% endhighlight %}

Hope you could find more useful applications of this new feature!

### A note on 4.1 release
_In case you are not sure what_ `RichTextBoxTarget.ReInitializeAllTextboxes(this)` _call does, then you might have missed a feature added in 4.1 release. It improves the RichTextBoxTarget functional by allowing it to be configured and initialized before the actual control is created. Check_ `allowAccessoryFormCreation` _and_ `messageRetention` _options description in the [target's documentation](https://github.com/NLog/NLog.Windows.Forms/wiki/RichTextBoxTarget)_

