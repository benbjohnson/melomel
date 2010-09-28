package melomel.commands.parsers
{
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
		var message:XML = <get-class name="flash.display.Stage"/>;

		// Parse message
		command = parser.parse(message) as GetClassCommand;
		Assert.assertEquals(command.name, "flash.display.Stage");
		Assert.assertTrue(command.throwable);
	}

	[Test]
	public function parseNonThrowable():void
	{
		var message:XML = <get-class name="flash.display.Stage" throwable="false"/>;
		command = parser.parse(message) as GetClassCommand;
		Assert.assertFalse(command.throwable);
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function parseWithoutMessageThrowsError():void
	{
		parser.parse(null);
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function parseWithInvalidAction():void
	{
		var message:XML = <foo name="flash.display.Stage"/>;
		parser.parse(message);
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function parseWithParametersThrowsError():void
	{
		parser.parse(<get-class/>);
	}
}
}