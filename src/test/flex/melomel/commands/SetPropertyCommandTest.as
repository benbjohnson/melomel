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
	public function shouldSetAndReturnValue():void
	{
		command.object = object;
		command.property = "foo";
		command.value    = "baz";
		Assert.assertEquals("baz", command.execute());
		Assert.assertEquals("baz", object.foo);
	}

	[Test]
	public function shouldReturnNullIfSetNull():void
	{
		command.object = object;
		command.property = "foo";
		command.value    = null;
		command.execute();
		Assert.assertNull(object.foo);
	}

	[Test(expects="ReferenceError")]
	public function shouldThrowErrorIfSettingMissingPropertyAndThrowable():void
	{
		command.object = new TestClass();
		command.property = "baz";
		command.value = "xxx";
		command.throwable = true;
		command.execute();
	}

	[Test]
	public function shouldNotThrowErrorIfSettingMissingPropertyIfNonThrowable():void
	{
		command.object = new TestClass();
		command.property = "baz";
		command.value = "xxx";
		command.throwable = false;
		Assert.assertNull(command.execute());
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorIfMissingObject():void
	{
		command.property = "foo";
		command.value    = "baz";
		command.execute();
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorIfMissingPropertyName():void
	{
		command.object = object;
		command.value = "baz";
		command.execute();
	}
}
}

class TestClass
{
	public var foo:String = "bar";
}
