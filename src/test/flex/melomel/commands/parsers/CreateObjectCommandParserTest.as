package melomel.commands.parsers
{
import melomel.commands.CreateObjectCommand;

import org.flexunit.Assert;
import org.flexunit.async.Async;

import flash.geom.Point;

public class CreateObjectCommandParserTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var parser:ICommandParser;
	private var command:CreateObjectCommand;
	
	[Before]
	public function setUp():void
	{
		parser = new CreateObjectCommandParser();
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
		var message:XML = <create class="flash.geom.Point"/>;

		// Parse message
		command = parser.parse(message) as CreateObjectCommand;
		Assert.assertEquals(command.clazz, Point);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithoutMessageThrowsError():void
	{
		parser.parse(null);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithInvalidAction():void
	{
		var message:XML = <foo class="flash.geom.Point"/>;
		parser.parse(message);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function parseWithParametersThrowsError():void
	{
		parser.parse(<create/>);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorIfInvalidClassAndThrowable():void
	{
		var message:XML = <create class="no.such.class"/>;
		command = parser.parse(message) as CreateObjectCommand;
	}

	[Test]
	public function shouldReturnNullIfInvalidClassAndNotThrowable():void
	{
		var message:XML = <create class="no.such.class" throwable="false"/>;
		command = parser.parse(message) as CreateObjectCommand;
		Assert.assertNull(command.clazz);
	}
}
}