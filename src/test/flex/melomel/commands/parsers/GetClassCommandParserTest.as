package melomel.commands.parsers
{
import melomel.core.ObjectProxy;
import melomel.core.ObjectProxyManager;
import melomel.commands.GetClassCommand;

import org.flexunit.Assert;
import org.flexunit.async.Async;

import flash.display.Stage;

public class GetClassCommandParserTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var parser:ICommandParser;
	private var command:GetClassCommand;
	
	[Before]
	public function setUp():void
	{
		parser = new GetClassCommandParser();
	}

	[After]
	public function tearDown():void
	{
		parser  = null;
		command = null;
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
	public function parseWithName():void
	{
		// Assign actual proxy id to the message
		var message:XML = <get-class name="flash.display.Stage"/>;

		// Parse message
		command = parser.parse(message) as GetClassCommand;
		Assert.assertEquals(command.name, "flash.display.Stage");
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithoutMessageThrowsError():void
	{
		parser.parse(null);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithInvalidAction():void
	{
		var message:XML = <foo name="flash.display.Stage"/>;
		parser.parse(message);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithParametersThrowsError():void
	{
		parser.parse(<get-class/>);
	}
}
}