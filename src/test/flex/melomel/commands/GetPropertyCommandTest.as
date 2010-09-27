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
		Assert.assertEquals(command.execute(), "bar");
	}
	
	[Test]
	public function executeForUndefinedProperty():void
	{
		command.object = {foo:"bar"};
		command.property = "fee";
		Assert.assertEquals(command.execute(), null);
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