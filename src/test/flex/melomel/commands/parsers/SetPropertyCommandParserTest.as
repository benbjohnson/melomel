package melomel.commands.parsers
{
import melomel.core.ObjectProxy;
import melomel.core.ObjectProxyManager;
import melomel.commands.SetPropertyCommand;

import org.flexunit.Assert;
import org.flexunit.async.Async;

import flash.display.Stage;

public class SetPropertyCommandParserTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var manager:ObjectProxyManager;
	private var parser:ICommandParser;
	private var command:SetPropertyCommand;

	private var object:Object;
	private var proxy:ObjectProxy;
	
	[Before]
	public function setUp():void
	{
		object = {};
		manager = new ObjectProxyManager();
		proxy = manager.addItem(object);
		parser = new SetPropertyCommandParser(manager);
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
	public function parseWithObjectAndPropertyAndValue():void
	{
		// Assign actual proxy id to the message
		var message:XML = <set property="foo"><arg value="bar"/></set>;
		message.@object = proxy.id;

		// Parse message
		command = parser.parse(message) as SetPropertyCommand;
		Assert.assertEquals(command.object, object);
		Assert.assertEquals(command.property, "foo");
		Assert.assertEquals(command.value, "bar");
		Assert.assertTrue(command.throwable);
	}

	[Test]
	public function parseNonThrowable():void
	{
		var message:XML = <set property="foo" throwable="false"><arg value="bar"/></set>;
		message.@object = proxy.id;
		command = parser.parse(message) as SetPropertyCommand;
		Assert.assertFalse(command.throwable);
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function parseWithoutMessageThrowsError():void
	{
		parser.parse(null);
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function parseWithInvalidActionThrowsError():void
	{
		var message:XML = <foo property="foo"><arg value="bar"/></foo>;
		message.@object = proxy.id;
		parser.parse(message);
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function parseWithNoParametersThrowsError():void
	{
		parser.parse(<set/>);
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function parseWithMissingObjectThrowsError():void
	{
		parser.parse(<set property="foo"><arg value="bar"/></set>);
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function parseWithMissingPropertyThrowsError():void
	{
		var message:XML = <set><arg value="foo"/></set>;
		message.@object = proxy.id;
		parser.parse(message);
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function parseWithMissingValueThrowsError():void
	{
		var message:XML = <set property="foo"/>;
		message.@object = proxy.id;
		parser.parse(message);
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function parseWithInvalidObjectProxy():void
	{
		parser.parse(<set object="100000" property="foo"><arg value="bar"/></set>);
	}


	//-----------------------------
	//  Parse arguments
	//-----------------------------

	[Test]
	public function parseNullArgument():void
	{
		var message:XML = <set property="foo"><arg dataType="null"/></set>;
		message.@object = proxy.id;
		command = parser.parse(message) as SetPropertyCommand;
		Assert.assertEquals(command.value, null);
	}

	[Test]
	public function parseStringArgumentWithExplicitDataType():void
	{
		var message:XML = <set property="foo"><arg value="bar" dataType="string"/></set>;
		message.@object = proxy.id;
		command = parser.parse(message) as SetPropertyCommand;
		Assert.assertEquals(command.value, "bar");
	}

	[Test]
	public function parseStringArgumentWithoutDataType():void
	{
		var message:XML = <set property="foo"><arg value="bar"/></set>;
		message.@object = proxy.id;
		command = parser.parse(message) as SetPropertyCommand;
		Assert.assertEquals("bar", command.value);
	}

	[Test]
	public function parseIntArgument():void
	{
		var message:XML = <set property="foo"><arg value="12" dataType="int"/></set>;
		message.@object = proxy.id;
		command = parser.parse(message) as SetPropertyCommand;
		Assert.assertEquals(12, command.value);
	}

	[Test]
	public function parseFloatArgument():void
	{
		var message:XML = <set property="foo"><arg value="100.12" dataType="float"/></set>;
		message.@object = proxy.id;
		command = parser.parse(message) as SetPropertyCommand;
		Assert.assertEquals(100.12, command.value);
	}

	[Test]
	public function parseBooleanTrueArgument():void
	{
		var message:XML = <set property="foo"><arg value="true" dataType="boolean"/></set>;
		message.@object = proxy.id;
		command = parser.parse(message) as SetPropertyCommand;
		Assert.assertTrue(command.value);
	}

	[Test]
	public function parseBooleanFalseArgument():void
	{
		var message:XML = <set property="foo"><arg value="false" dataType="boolean"/></set>;
		message.@object = proxy.id;
		command = parser.parse(message) as SetPropertyCommand;
		Assert.assertFalse(command.value);
	}

	[Test]
	public function parseObjectArgument():void
	{
		var object:Object = {};
		var proxy2:ObjectProxy = manager.addItem(object);

		var message:XML = <set property="foo"><arg dataType="object"/></set>;
		message.@object = proxy.id;
		message.arg[0].@value = proxy2.id;
		command = parser.parse(message) as SetPropertyCommand;
		Assert.assertEquals(object, command.value);
	}
}
}