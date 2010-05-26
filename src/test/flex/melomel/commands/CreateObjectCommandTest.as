package melomel.commands
{
import org.flexunit.Assert;
import org.flexunit.async.Async;

import flash.geom.Point;

public class CreateObjectCommandTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var command:CreateObjectCommand;
	private var object:Object;
	
	[Before]
	public function setUp():void
	{
		command = new CreateObjectCommand();
	}

	[After]
	public function tearDown():void
	{
		command = null;
		object = null;
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
		command.clazz = Point;
		object = command.execute();
		Assert.assertTrue(object is Point);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function executeWithMissingClass():void
	{
		command.clazz = null;
		command.execute();
	}
}
}