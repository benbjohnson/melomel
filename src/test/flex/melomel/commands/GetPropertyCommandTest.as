package melomel.commands
{
import org.flexunit.Assert;
import org.flexunit.async.Async;

import flash.display.Stage;

public class GetPropertyCommandTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var command:GetPropertyCommand;
	
	[Before]
	public function setUp():void
	{
		command = new GetPropertyCommand();
	}

	[After]
	public function tearDown():void
	{
		command = null;
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Execute
	//-----------------------------

	[Test]
	public function execute():void
	{
		command.object = {foo:"bar"};
		command.property = "foo";
		Assert.assertEquals("bar", command.execute());
	}

	[Test]
	public function shouldPassThroughToMethod():void
	{
		command.object = new TestClass();
		command.property = "foo";
		Assert.assertEquals("bar", command.execute());
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function executeWithoutObject():void
	{
		command.property = "foo";
		command.execute();
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function executeWithoutProperty():void
	{
		command.object = {foo:"bar"};
		command.execute();
	}
}
}

class TestClass
{
	public function foo():String {return "bar"}
}
