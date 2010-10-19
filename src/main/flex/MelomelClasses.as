package
{
internal class MelomelClasses
{
	Melomel;
	
	// Core
	import melomel.core.Bridge; Bridge;
	import melomel.core.ObjectProxy; ObjectProxy;
	import melomel.core.ObjectProxyManager; ObjectProxyManager;
	import melomel.core.UI; UI;
	
	// Commands
	import melomel.commands.GetClassCommand; GetClassCommand;
	import melomel.commands.GetPropertyCommand; GetPropertyCommand;
	import melomel.commands.SetPropertyCommand; SetPropertyCommand;
	import melomel.commands.InvokeMethodCommand; InvokeMethodCommand;
	import melomel.commands.CreateObjectCommand; CreateObjectCommand;
	import melomel.commands.InvokeFunctionCommand; InvokeFunctionCommand;
	
	// Parsers
	import melomel.commands.parsers.GetClassCommandParser; GetClassCommandParser;
	import melomel.commands.parsers.GetPropertyCommandParser; GetPropertyCommandParser;
	import melomel.commands.parsers.SetPropertyCommandParser; SetPropertyCommandParser;
	import melomel.commands.parsers.InvokeMethodCommandParser; InvokeMethodCommandParser;
	import melomel.commands.parsers.CreateObjectCommandParser; CreateObjectCommandParser;
	import melomel.commands.parsers.InvokeFunctionCommandParser; InvokeFunctionCommandParser;

	// Formatters
	import melomel.commands.formatters.ObjectFormatter; ObjectFormatter;

	// MXML
	import melomel.mxml.MXMLMelomel; MXMLMelomel;
}
}
