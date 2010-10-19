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
	public function shouldRetrieveDyamicProperty():void
	{
		command.object = {foo:"bar"};
		command.property = "foo";
		Assert.assertEquals("bar", command.execute());
	}
	
	[Test]
	public function executeForUndefinedProperty():void
	{
		command.object = {foo:"bar"};
		command.property = "fee";
		Assert.assertEquals(command.execute(), null);
	}

	[Test]
	public function shouldRetrieveNonDyamicProperty():void
	{
		command.object = new TestClass();
		command.property = "variable";
		Assert.assertEquals("x", command.execute());
	}

	[Test]
	public function shouldRetrieveAccessor():void
	{
		command.object = new TestClass();
		command.property = "accessor";
		Assert.assertEquals("y", command.execute());
	}

	[Test]
	public function shouldRetrieveAccessorMutator():void
	{
		command.object = new TestClass();
		command.property = "accessorMutator";
		Assert.assertEquals("z", command.execute());
	}

	[Test(expects="ReferenceError")]
	public function shouldThrowErrorWhenRetrievingMutator():void
	{
		command.object = new TestClass();
		command.property = "mutator";
		command.execute();
	}

	[Test]
	public function shouldReturnNullWhenRetrievingMutatorAndNotThrowable():void
	{
		command.object = new TestClass();
		command.property = "mutator";
		command.throwable = false;
		Assert.assertNull(command.execute());
	}

	[Test]
	public function shouldRetrieveStaticProperty():void
	{
		command.object = TestClass;
		command.property = "staticVariable";
		Assert.assertEquals("a", command.execute());
	}

	[Test]
	public function shouldRetrieveStaticAccessor():void
	{
		command.object = TestClass;
		command.property = "staticAccessor";
		Assert.assertEquals("b", command.execute());
	}

	[Test]
	public function shouldRetrieveStaticAccessorMutator():void
	{
		command.object = TestClass;
		command.property = "staticAccessorMutator";
		Assert.assertEquals("c", command.execute());
	}

	[Test(expects="ReferenceError")]
	public function shouldThrowErrorWhenRetrievingStaticMutator():void
	{
		command.object = new TestClass()
		command.property = "staticMutator";
		command.execute();
	}

	[Test]
	public function shouldReturnNullWhenRetrievingStaticMutatorAndNotThrowable():void
	{
		command.object = TestClass;
		command.property = "staticMutator";
		command.throwable = false;
		Assert.assertNull(command.execute());
	}

	[Test]
	public function shouldPassThroughToMethod():void
	{
		command.object = new TestClass();
		command.property = "foo";
		Assert.assertEquals("bar", command.execute());
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function shouldThrowErrorWhenMissingObject():void
	{
		command.property = "foo";
		command.execute();
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function shouldThrowErrorWhenMissingProperty():void
	{
		command.object = {foo:"bar"};
		command.execute();
	}

	[Test(expects="ReferenceError")]
	public function shouldThrowErrorOnInvalidProperty():void
	{
		command.object = new TestClass();
		command.property = "baz";
		command.throwable = true;
		command.execute();
	}

	[Test(expects="ReferenceError")]
	public function shouldThrowErrorOnInvalidStaticProperty():void
	{
		trace("---");
		command.object = TestClass;
		command.property = "noSuchProperty";
		command.throwable = true;
		command.execute();
	}

	[Test]
	public function shouldNotThrowErrorOnInvalidPropertyWhenNotThrowable():void
	{
		command.object = new TestClass();
		command.property = "baz";
		command.throwable = false;
		command.execute();
	}

	[Test]
	public function shouldAccessArrayElement():void
	{
		command.object = ["foo", "bar", "baz"];
		command.property = "[1]";
		command.throwable = false;
		Assert.assertEquals("bar", command.execute());
	}
}
}

class TestClass
{
	static public var staticVariable:String = "a";
	static public function get staticAccessor():String {return "b"}
	static public function set staticMutator(value:String):void {}
	static public function get staticAccessorMutator():String {return "c"}
	static public function set staticAccessorMutator(value:String):void {}

	public var variable:String = "x";
	public function get accessor():String {return "y"};
	public function set mutator(value:String):void {};
	public function get accessorMutator():String {return "z"};
	public function set accessorMutator(value:String):void {};

	public function foo():String {return "bar"}
}
