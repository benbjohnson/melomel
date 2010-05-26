package melomel.commands
{
import org.flexunit.Assert;
import org.flexunit.async.Async;

public class SetPropertyCommandTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var command:SetPropertyCommand;
	private var object:Object;
	
	[Before]
	public function setUp():void
	{
		command = new SetPropertyCommand();
		object = {foo:"bar"};
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
		command.object = object;
		command.property = "foo";
		command.value    = "baz";
		command.execute();
		Assert.assertEquals(object.foo, "baz");
	}

	[Test]
	public function executeWithNullValue():void
	{
		command.object = object;
		command.property = "foo";
		command.value    = null;
		command.execute();
		Assert.assertNull(object.foo);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function executeWithoutObject():void
	{
		command.property = "foo";
		command.value    = "baz";
		command.execute();
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function executeWithoutProperty():void
	{
		command.object = object;
		command.value = "baz";
		command.execute();
	}
}
}