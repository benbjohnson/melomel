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
	public function shouldExecuteDynamicMethod():void
	{
		command.object = object;
		command.methodName = "testFunc";
		command.methodArgs = ["John", "Smith"];
		Assert.assertEquals("Hello John Smith", command.execute());
	}

	[Test]
	public function shouldExecuteInstanceMethod():void
	{
		command.object = new TestClass();
		command.methodName = "instanceMethod";
		command.methodArgs = [];
		Assert.assertEquals("foo", command.execute());
	}

	[Test]
	public function shouldExecuteStaticMethod():void
	{
		command.object = TestClass;
		command.methodName = "staticMethod";
		command.methodArgs = [];
		Assert.assertEquals("foo", command.execute());
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
		command.object = new TestClass();
		command.methodName = "baz";
		command.methodArgs = [];
		command.throwable = false;
		Assert.assertNull(command.execute());
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function shouldThrowErrorWhenMissingObject():void
	{
		command.methodName = "testFunc";
		command.methodArgs = ["John", "Smith"];
		command.execute();
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function shouldThrowErrorWhenMissingMethodName():void
	{
		command.object = object;
		command.methodArgs = ["John", "Smith"];
		command.execute();
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function shouldThrowErrorWhenMissingMethodArgs():void
	{
		command.object = object;
		command.methodName = "testFunc";
		command.execute();
	}
}
}

class TestClass
{
	static public function staticMethod():String {return "foo"}
	public function instanceMethod():String {return "foo"}
}
