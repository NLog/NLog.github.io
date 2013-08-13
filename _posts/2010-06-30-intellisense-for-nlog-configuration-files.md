---
layout: post
title: Intellisense for NLog configuration files
---

I have recently updated tools to build **NLog.xsd** which are needed to Intellisense in Visual Studio. Instead of one, in NLog 2.0 there will be multiple schema files - one for each framework plus a unified schema for all frameworks.

<table border="1" cellspacing="0" cellpadding="2" width="724">
<tbody>
<tr>
<td valign="top" width="138"><strong>File Name</strong></td>
<td valign="top" width="394"><strong>XML Namespace</strong></td>
<td valign="top" width="190"><strong>Frameworks</strong></td>
</tr>
<tr>
<td valign="top" width="142">NLog.xsd</td>
<td valign="top" width="392"><a href="http://www.nlog-project.org/schemas/NLog.xsd">http://www.nlog-project.org/schemas/NLog.xsd</a></td>
<td valign="top" width="189">(all frameworks)</td>
</tr>
<tr>
<td valign="top" width="145">NLog.Mono2.xsd</td>
<td valign="top" width="390"><a href="http://www.nlog-project.org/schemas/NLog.mono2.xsd">http://www.nlog-project.org/schemas/NLog.mono2.xsd</a></td>
<td valign="top" width="188">Mono 2.x</td>
</tr>
<tr>
<td valign="top" width="148">NLog.NetCf20.xsd</td>
<td valign="top" width="389"><a href="http://www.nlog-project.org/schemas/NLog.netcf20.xsd">http://www.nlog-project.org/schemas/NLog.netcf20.xsd</a></td>
<td valign="top" width="187">.NET Compact Framework 2.0</td>
</tr>
<tr>
<td valign="top" width="150">NLog.NetCf35.xsd</td>
<td valign="top" width="388"><a href="http://www.nlog-project.org/schemas/NLog.netcf35.xsd">http://www.nlog-project.org/schemas/NLog.netcf35.xsd</a></td>
<td valign="top" width="186">.NET Compact Framework 3.5</td>
</tr>
<tr>
<td valign="top" width="152">NLog.NetFx20.xsd</td>
<td valign="top" width="387"><a href="http://www.nlog-project.org/schemas/NLog.netfx20.xsd">http://www.nlog-project.org/schemas/NLog.netfx20.xsd</a></td>
<td valign="top" width="186">.NET Framework 2.0</td>
</tr>
<tr>
<td valign="top" width="153">NLog.NetFx35.xsd</td>
<td valign="top" width="387"><a href="http://www.nlog-project.org/schemas/NLog.netfx35.xsd">http://www.nlog-project.org/schemas/NLog.netfx35.xsd</a></td>
<td valign="top" width="185">.NET Framework 3.5</td>
</tr>
<tr>
<td valign="top" width="154">NLog.NetFx40.xsd</td>
<td valign="top" width="386"><a href="http://www.nlog-project.org/schemas/NLog.netfx40.xsd">http://www.nlog-project.org/schemas/NLog.netfx40.xsd</a></td>
<td valign="top" width="185">.NET Framework 4.0</td>
</tr>
<tr>
<td valign="top" width="155">NLog.SL2.xsd</td>
<td valign="top" width="386"><a href="http://www.nlog-project.org/schemas/NLog.sl2.xsd">http://www.nlog-project.org/schemas/NLog.sl2.xsd</a></td>
<td valign="top" width="185">Silverlight 2.0</td>
</tr>
<tr>
<td valign="top" width="156">NLog.SL3.xsd</td>
<td valign="top" width="385"><a href="http://www.nlog-project.org/schemas/NLog.sl3.xsd">http://www.nlog-project.org/schemas/NLog.sl3.xsd</a></td>
<td valign="top" width="184">Silverlight 3.0</td>
</tr>
<tr>
<td valign="top" width="156">NLog.SL4.xsd</td>
<td valign="top" width="385"><a href="http://www.nlog-project.org/schemas/NLog.sl4.xsd">http://www.nlog-project.org/schemas/NLog.sl4.xsd</a></td>
<td valign="top" width="186">Silverlight 4.0</td>
</tr>
</tbody>
</table>

The idea is that each XSD file only contains items (targets, layouts, filters, etc.) supported by a particular framework and unified schema supports all the targets supported by at least one framework. Because of that Intellisense will provide smart editing help and validation that’s specific to the target framework.

Intellisense In Action
----------------------
When you add NLog.config to your project using Add Item, it will be using a unified schema (so you will see both Silverlight-specific and .NET Framework specific targets there)

<img src="/images/posts/2010/06/image.png">

When you change the XML to a particular framework - for example Silverlight 2.0, you will immediately see that File target is not supported on that platform and XML editor will highlight the place where the error occurs.

<img src="/images/posts/2010/06/image1.png">

This also works for individual properties. For example, [LogReceiverService](https://github.com/NLog/NLog/wiki/LogReceiverService-target) target does not support certain properties on .NET Compact Framework 3.5 (because of lack of WCF). Sure enough, when you use .NET CF-specific schema those errors will be highlighted.

<img src="/images/posts/2010/06/image2.png">

XSD schemas also provide help when editing NLog.config files:

<img src="/images/posts/2010/06/image_thumb.png">

Customizing XSD Schemas
-----------------------
Starting with NLog 2.0 it is also easy to customize NLog.xsd, which can be useful if your organization uses private extensions to NLog. Let’s say you have created your NLog extensions and put them in SampleExtensions.dll. In order to generate customized NLog.xsd, you need to follow this simple process:

The first step is to download and unpack NLog sources (from [GitHub](http://github.com/NLog/NLog/) or zip package) and build everything by running:

<pre>
build.cmd build xsd
</pre>

from command line. This will build NLog and the tools necessary to customize XSD files. First tool we’ll be using is called DumpApiXml, which analyzes a DLL and generates API file from it as described [here](http://nlog-project.org/2010/03/22/nlog-2-0-build-and-release-process-explained.html). We must run it on our extensions assembly and pass it directory (or directories) where all reference assemblies are located.

<pre>
&lt;nlog-dir&gt;\tools\DumpApiXml\bin\Debug\DumpApiXml.exe -assembly  &lt;path&gt;\SampleExtensions.dll
  -ref "D:\Work\NLog\build\bin\Debug\.NET Framework 4.0" -output &lt;path&gt;\SampleExtensions.api
</pre>

Once we have the SampleExtensions.api project, we need to convert it to XSD using MakeNLogXSD. It accepts multiple \*.api files and can produce XSD files with custom namespaces:

<pre>
&lt;nlog-dir&gt;\tools\MakeNLogXSD\bin\Debug\MakeNLogXSD.exe -api "&lt;nlog-dir&gt;\build\bin\Debug\.NET Framework 4.0\API\NLog.api"
  -api &lt;path&gt;\SampleExtensions.api -xmlns http://mycompany.com/NLog.xsd -out &lt;path&gt;\MyNLog.xsd
</pre>

The command will produce MyNLog.xsd which will use http://mycompany.com/NLog.xsd schema. You can now install the schema in Visual Studio (by dropping it in "**%ProgramFiles%\Microsoft Visual Studio 9.0\Xml\Schemas**" directory) and you should be able to enjoy Intellisense and validation against your custom schema:

<img src="http://nlog-project.org/wp-content/uploads/2010/06/image3.png">