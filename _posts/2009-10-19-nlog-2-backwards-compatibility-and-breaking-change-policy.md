---
layout: post
title: NLog 2 backwards compatibility and breaking change policy
---

I have spent last couple months doing significant refactoring of NLog v2 code base with the goal to improve long-term maintainability, extensibility, usability and testability. During that process I discovered (with great help from FxCop) and decided to fix some design issues and align the codebase with .NET Design Guidelines. Fixing some issues required me to introduce some breaking changes which may impact applications using NLog v1 who want to migrate to NLog v2. This post explains the scope of the breaking changes to date and explains general principles I'm following during NLog 2 development.

Configuration File Format
-------------------------
Good news first: configuration file format will not be affected by those breaking changes. That means that configuration files from NLog 1.0 should just work with NLog 2.0 without modifications. If there are any exceptions, they will be explicitly listed when NLog 2 is released.

Note that that you may see some behavioral changes for features that were not implemented properly in NLog v1 and will be fixed in NLog 2. The most common example is probably the use of "padding" attribute on layout renderers. If you used it in v1 you may have found that it did not work for all renderers (depending on their implementation). Because of the redesign and introduction of wrapper layout renderers, padding is now guaranteed to be supported by all renderers and the configuration file usage remains unchanged.

Logging API
-----------
Logging API will be largely unaffected by breaking changes. If your application only uses Logger, LogManager and LogEventInfo classes, and does NOT configure logging programmatically, you should be able to use newer version of NLog without rebuilding your code (just by using assembly binding redirection).

Configuration and Extensibility API
-----------------------------------
Other APIs (including configuration API + any class other than what's mentioned in #1, including target, layout, layout renderer, filter classes, etc.) are generally not guaranteed to backwards compatible. Breaking changes are mostly class renames, including moving classes between namespaces, but also changing public types of some properties.

Here are the classes of changes you will see in NLog v2 in no particular order (note that the list is not complete and may grow to include further changes):

 1. Properties which supported layouts (such as FileTarget.FileName or TargetWithLayout.Layout) have been replaced from String type to Layout type. Previously each property setter was doing layout parsing so we were locked into using simple layouts only (structural layouts such as CSV were not supported without major tricks). In the spirit of dependency inversion principle I moved construction to the configurator code. This allowed me to get rid of CompiledLayout properties.<br/>
 **Note**: In order to help users porting old code I have created an implicit conversion from String type to Layout which will do simple layout parsing under the hood. So in most cases users will not see the difference in usage.
 2. The same thing applies to properties which supported condition expressions. The property type was changed from String to ConditionExpression and properties no longer need to do the parsing – instead it is done by the configurator. As with layouts, there is also an implicit String to ConditionExpression conversion to help with code migration.
 3. Some enumeration properties were using nested enumeration types which were not easily discoverable – I made those enums public in the same namespace where they are used.
 4. Merged types from Win32/Targets into Targets, Win32/LayoutRenderers into LayoutRenderers/ and so on – because Win32-specific features were not easily discoverable
 5. Refactored GetStackTraceUsage() to return StackTraceUsage enumeration instead of magic constants (0, 1, 2) which described stack trace usage of components such as targets, layouts, layout renderers.
 6. Removed PopulateLayouts methods and replaced them with generic reflection-based discovery of Layouts.
 7. Initialize() and Close() methods are now automatically called by NLog itself without the need to recursively invoke them in wrappers, layouts, conditions, filters and so on. This makes the extensio classes really clean and reusable.
 8. Casing of some class names and property names was fixed to follow .NET naming guidelines – for example class names starting with ASP were renamed to start with Asp
 9.Introduced single NLogFactories class which replaces TargetFactory, LayoutFactory, LayoutRendererFactory, ExtensionUtils, etc.
 10. Root classes of all NLog class hierarchies (Target, Layout, LayoutRenderer, ConditionExpression) were moved to appropriate namespaces (NLog.Targets, NLog.Layouts, NLog.LayoutRenderers, NLog.Conditions)
 11. Replaced ILayout interface with Layout base class and renamed old Layout class to SimpleLayout. ILayoutWithHeaderAndFooter was replaced with LayoutWithHeaderAndFooter correspondingly.
 12. InternalLogger was moved to NLog.Common namespace. This way NLog.Internal will have no public classes (classes such as TcpNetworkSender and UdpNetworkSender were also made internal).
 13. GDC/MDC/NDC names were deprecated in favor of GlobalDiagnosticsContext, MappedDiagnosticsContext and NestedDiagnosticsContext respectively (this is likely to be revisited as I'm still looking for better names).
 14. All factory attributes (\[TargetAttribute\], \[LayoutRendererAttribute\], and so on) were moved to the appropriate namespaces (NLog.Targets, NLog.LayoutRenderers etc.)
After all these moves and renames, the root "NLog" namespace became really clean and now only includes core logging classes which remain backwards-compatible with V1.

 * LogEventInfo
 * LogFactory
 * LogFactory<T>
 * Logger
 * LogLevel
 * LogManager 

I believe that this breaking change policy is a reasonable compromise between maintaining backwards compatibility for existing clients and opening door to evolving NLog in the future. Let me know what you think about it,

Jarek