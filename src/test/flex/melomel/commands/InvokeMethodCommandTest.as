package melomel.commands
{
import org.flexunit.Assert;
import org.flexunit.async.Async;

public class InvokeMethodCommandTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var command:InvokeMethodCommand;
	private var object:Object;
	
	[Before]
	public function setUp():void
	{
		command = new InvokeMethodCommand();
		object = {testFunc:function(firstName:String, lastName:String):String{
			return "Hello " + firstName + " " + lastName;
		}};
	}

	[After]
	public function tearDown():void
	{
		command = null;
		object  = null;
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
		command.methodName = "testFunc";
		command.methodArgs = ["John", "Smith"];
		Assert.assertEquals("Hello John Smith", command.execute());
	}

	[Test(expects="TypeError")]
	public function shouldThrowErrorIfMissingMethodAndThrowable():void
	{
		command.object = object;
		command.methodName = "baz";
		command.methodArgs = [];
		command.throwable = true;
		command.execute();
	}

	[Test]
	public function shouldNotThrowErrorIfMissingMethodAndNotThrowable():void
	{
		command.object = object;
		command.methodName = "baz";
		command.methodArgs = [];
		command.throwable = false;
		Assert.assertNull(command.execute());
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function executeWithoutObject():void
	{
		command.methodName = "testFunc";
		command.methodArgs = ["John", "Smith"];
		command.execute();
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function executeWithoutMethodName():void
	{
		command.object = object;
		command.methodArgs = ["John", "Smith"];
		command.execute();
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function executeWithoutMethodArgs():void
	{
		command.object = object;
		command.methodName = "testFunc";
		command.execute();
	}
}
}

class TestClass
{
	public function foo():String {return "bar"}
}
