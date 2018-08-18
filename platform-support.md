## General
Feature|.NET 3.5|.NET 4.0|.NET 4.5|NetStandard|Xamarin iOs|Xamarin Android|Mono|WP8|Silverlight
 -----| -----| -----| -----| -----| -----| -----| -----| -----| -----
read app.config/web.config|✓ |✓ |✓ |✓ |||✓ ||
autoloading .dll|✓ |✓ |✓ |1.5+ |✓ |✓ |✓ ||
auto reload|✓ |✓ |✓ |1.5+ |||✓ ||
stacktrace with source|✓ |✓ |✓ |1.5+|✓ |✓ |✓ ||
fluent interface|||✓ |✓ |||?||
NLogTraceListener|✓ |✓ |✓ |2.0|||✓ ||

> NetStandard 1.5 cannot perform autoload of DLLs from nuget-packages that places dlls in sub-folders.

## Layout Renderers
Layout Renderer|.NET 3.5|.NET 4.0|.NET 4.5|NetStandard|Xamarin iOs|Xamarin Android|Mono|WP8|Silverlight|Remarks	
 -----| -----| -----| -----| -----| -----| -----| -----| -----| -----| -----	
AllEventProperties|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ | Include Caller Information: .NET 4.5 only	
AppDomain|✓ |✓ |✓ |1.5+|✓ |✓ |✓ |||	
AspApplicationValue|✓ |✓ |✓ |||||||	
AspRequestValue|✓ |✓ |✓ |||||||	
AspSessionValue|✓ |✓ |✓ |||||||	
AssemblyVersion|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |See [notes](AssemblyVersion-Layout-Renderer)
BaseDir|✓ |✓ |✓ |✓ |✓ |✓ |✓ |||	
CallSite|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |±|±: no file name or source path	
CallSiteLineNumber|✓ |✓ |✓ |✓ |✓ |✓ |✓ |||	
Counter|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Date|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
DocumentUri|||||||||✓ |	
Environment|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ ||	
EventContext|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
EventProperties|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Exception|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |±|±: no method name	
FileContents|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
GarbageCollectorInfo|✓ |✓ |✓ |✓ |✓ |✓ ||✓ |±|±: no collection count option	
Gdc|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Guid|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Identity|✓ |✓ |✓ |2.0|✓ |✓ |✓ |||	
InstallContext|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Level|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Literal|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Log4JXmlEvent|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |±|±: no file name or source path	
LoggerName|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
LongDate|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
MachineName|✓ |✓ |✓ |✓|✓ |✓ |✓ |✓ ||	
Mdc|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Mdlc||✓ |✓ |✓||||||	
Message|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
NewLine|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Ndc|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Ndlc||✓ |✓ |✓||||||	
NLogDir|✓ |✓ |✓ |1.5+|✓ |✓ |✓ |||	
PerformanceCounter|✓ |✓ |✓ ||||✓ |||	
ProcessId|✓ |✓ |✓ |1.5+||✓ |✓ |||	
ProcessInfo|✓ |✓ |✓ |1.5+|✓ |✓ ||||	
ProcessName|✓ |✓ |✓ |1.5+||✓ |✓ |||	
ProcessTime|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
QueryPerformanceCounter|✓ |✓ |✓ ||||✓ |||	
Registry|✓ |✓ |✓ ||||✓ |||	
ShortDate|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
SilverlightApplicationInfo|||||||||✓ |	
SpecialFolder|✓ |✓ |✓ |2.0|✓ |✓ |✓ |✓ |✓ |	
StackTrace|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
TempDir|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
ThreadId|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
ThreadName|✓ |✓ |✓ |1.5+|✓ |✓ |✓ |✓ |✓ |	
Ticks|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Time|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
TraceActivityId|✓ |✓ |✓ |2.0|✓ |✓ |✓ |||	
Variable|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
WindowsIdentity|✓ |✓ |✓ |± |✓ |✓ |✓ |||±: NLog.WindowsIdentity nuget package

## Layout renderer (wrapped)
Layout renderer|.NET 3.5|.NET 4.0|.NET 4.5|NetStandard|Xamarin iOs|Xamarin Android|Mono|WP8|Silverlight|Remarks	
 -----| -----| -----| -----| -----| -----| -----| -----| -----| -----| -----	
Cached|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
FileSystemNormalize|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
JsonEncode|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Lowercase|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
OnException|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Padding|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Replace|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
ReplaceNewLines|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Rot13|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
TrimWhiteSpace|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Uppercase|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
UrlEncode|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
WrapLine|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
WhenEmpty|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
XmlEncode|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	

## Targets
Target|.NET 3.5|.NET 4.0|.NET 4.5|NetStandard|Xamarin iOs|Xamarin Android|Mono|WP8|Silverlight|Remarks	
 -----| -----| -----| -----| -----| -----| -----| -----| -----| -----| -----	
AspResponse|✓ |✓ |✓ |||||||	
Chainsaw|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
ColoredConsole|✓ |✓ |✓ |1.5+|||✓ |||±: no encoding	
Console|✓ |✓ |✓ |1.5+|±|±|✓ |±|±|±: no encoding	
Database|✓ |✓ |✓ |±|||✓ |||	±: no transactions or reading from .config
Debug|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
Debugger|✓ |✓ |✓ ||✓ |✓ |✓ |✓ |✓ |	
EventLog|✓ |✓ |✓ ||||✓ |||	
File|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
LogReceiverWebService|✓ |✓ |✓ |±|||✓ ||✓ |±: NLog.WCF nuget package
Mail|✓ |✓ |✓ |2.0|✓ |✓ |✓ |||	
Memory|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
MethodCall|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
NLogViewer|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |±|±: no UDP	
Network|✓ |✓ |✓ |✓|✓ |✓ |✓ |✓ |✓ |	
Null|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
OutputDebugString|✓ |✓ |✓ |✓ |||✓ |||	
PerformanceCounter|✓ |✓ |✓ ||||✓ |||	
Trace|✓ |✓ |✓ |1.5+ |✓ |✓ |✓ |||	
WebService|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	

## Target-wrappers
Target|.NET 3.5|.NET 4.0|.NET 4.5|NetStandard|Xamarin iOs|Xamarin Android|Mono|WP8|Silverlight|Remarks	
 -----| -----| -----| -----| -----| -----| -----| -----| -----| -----| -----	
AsyncWrapper |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
AutoFlushWrapper |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
BufferingWrapper |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
FilteringWrapper |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
FallbackGroup |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
FilteringWrapper |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
ImpersonatingWrapper |✓ |✓ |✓ ||||✓ |||	
LimitingWrapper |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
PostFilteringWrapper |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
RandomizeGroup |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
RepeatingWrapper |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
RetryingWrapper |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
RoundRobinGroup|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
SplitGroup|✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |✓ |	
