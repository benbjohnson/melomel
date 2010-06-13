package melomel.commands.parsers
{
import melomel.core.ObjectProxy;
import melomel.core.ObjectProxyManager;
import melomel.commands.InvokeMethodCommand;

import org.flexunit.Assert;
import org.flexunit.async.Async;

import flash.display.Stage;

public class InvokeMethodCommandParserTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var manager:ObjectProxyManager;
	private var parser:ICommandParser;
	private var command:InvokeMethodCommand;

	private var object:Object;
	private var proxy:ObjectProxy;
	
	[Before]
	public function setUp():void
	{
		object = {};
		manager = new ObjectProxyManager();
		proxy = manager.addItem(object);
		parser = new InvokeMethodCommandParser(manager);
	}

	[After]
	public function tearDown():void
	{
		parser  = null;
		command = null;
		object  = null;
		proxy   = null;
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Parse
	//-----------------------------

	[Test]
	public function parseWithObjectAndMethodAndArgs():void
	{
		// Assign actual proxy id to the message
		var message:XML = <invoke method="foo"><args><arg value="John"/><arg value="12" dataType="int"/></args></invoke>;
		message.@object = proxy.id;

		// Parse message
		command = parser.parse(message) as InvokeMethodCommand;
		Assert.assertEquals(command.object, object);
		Assert.assertEquals(command.methodName, "foo");
		Assert.assertEquals(command.methodArgs.length, 2);
		Assert.assertEquals(command.methodArgs[0], "John");
		Assert.assertEquals(command.methodArgs[1], 12);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithoutMessageThrowsError():void
	{
		parser.parse(null);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithInvalidActionThrowsError():void
	{
		var message:XML = <foo property="foo"><arg value="bar"/></foo>;
		message.@object = proxy.id;
		parser.parse(message);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithNoParametersThrowsError():void
	{
		parser.parse(<invoke/>);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithMissingObjectThrowsError():void
	{
		parser.parse(<invoke property="foo"><args><arg value="bar"/></args></invoke>);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithMissingPropertyThrowsError():void
	{
		var message:XML = <invoke><args><arg value="foo"/></args></invoke>;
		message.@object = proxy.id;
		parser.parse(message);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithInvalidObjectProxy():void
	{
		parser.parse(<invoke object="100000" property="foo"><arg value="bar"/></invoke>);
	}
}
}