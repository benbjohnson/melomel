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
	public function shouldSetDyamicProperty():void
	{
		command.object = {foo:"bar"};
		command.property = "foo";
		command.value = "baz";
		Assert.assertEquals("baz", command.execute());
		Assert.assertEquals("baz", command.object.foo);
	}

	[Test]
	public function shouldSetNonDyamicProperty():void
	{
		command.object = new TestClass();
		command.property = "variable";
		command.value = "foo"
		Assert.assertEquals("foo", command.execute());
		Assert.assertEquals("foo", command.object.variable);
	}

	[Test(expects="ReferenceError")]
	public function shouldThrowErrorWhenSettingAccessor():void
	{
		command.object = new TestClass();
		command.property = "accessor";
		command.value = "foo";
		command.execute();
	}

	[Test]
	public function shouldReturnOriginalValueWhenSettingAccessorAndNotThrowable():void
	{
		command.object = new TestClass();
		command.property = "accessor";
		command.value = "bar"
		command.throwable = false;
		Assert.assertEquals("y", command.execute());
	}


	[Test]
	public function shouldSetAccessorMutator():void
	{
		command.object = new TestClass();
		command.property = "accessorMutator";
		command.value = "foo";
		Assert.assertEquals("foo", command.execute());
		Assert.assertEquals("foo", command.object.accessorMutator);
	}

	[Test]
	public function shouldSetMutator():void
	{
		command.object = new TestClass();
		command.property = "mutator";
		command.value = "foo";
		command.execute();
		Assert.assertEquals("foo", command.object._mutator);
	}

	[Test]
	public function shouldSetStaticProperty():void
	{
		command.object = TestClass;
		command.property = "staticVariable";
		command.value = "foo";
		Assert.assertEquals("foo", command.execute());
	}

	[Test(expects="ReferenceError")]
	public function shouldThrowErrorWhenSettingStaticAccessor():void
	{
		command.object = TestClass;
		command.property = "staticAccessor";
		command.value = "foo";
		command.execute();
	}

	[Test]
	public function shouldReturnOriginalValueWhenSettingStaticAccessorAndNotThrowable():void
	{
		command.object = TestClass;
		command.property = "staticAccessor";
		command.throwable = false;
		command.value = "bar";
		Assert.assertEquals("b", command.execute());
	}

	[Test]
	public function shouldSetStaticAccessorMutator():void
	{
		command.object = TestClass;
		command.property = "staticAccessorMutator";
		command.value = "foo";
		Assert.assertEquals("foo", command.execute());
	}

	/**
	 *	[KNOWN_BUG]
	 *	NOTE: Setting a static write-only mutator results in a Flash error. Not
	 *	      sure why.
	 */
	[Ignore]
	[Test]
	public function shouldSetStaticMutator():void
	{
		command.object = new TestClass()
		command.property = "staticMutator";
		command.value = "foo";
		Assert.assertNull(command.execute());
		Assert.assertEquals("foo", command.object._staticMutator);
	}

	[Test]
	public function shouldSetNull():void
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

	[Test(expects="melomel.errors.MelomelError")]
	public function shouldThrowErrorIfMissingObject():void
	{
		command.property = "foo";
		command.value    = "baz";
		command.execute();
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function shouldThrowErrorIfMissingPropertyName():void
	{
		command.object = object;
		command.value = "baz";
		command.execute();
	}

	[Test]
	public function shouldMutateArrayElement():void
	{
		command.object = ["foo", "bar", "baz"];
		command.property = "[1]";
		command.value = "xxx";
		command.execute();
		Assert.assertEquals("xxx", command.object[1]);
	}
}
}

class TestClass
{
	static public var staticVariable:String;
	static public function get staticAccessor():String {return "b"}
	static public var _staticMutator:String;
	static public function set staticMutator(value:String):void {_staticMutator = value;}
	static private var _staticAccessorMutator:String;
	static public function get staticAccessorMutator():String {return _staticAccessorMutator}
	static public function set staticAccessorMutator(value:String):void {_staticAccessorMutator = value;}

	public var variable:String;
	public function get accessor():String {return "y"};
	public var _mutator:String;
	public function set mutator(value:String):void {_mutator = value;};
	private var _accessorMutator:String;
	public function get accessorMutator():String {return _accessorMutator;};
	public function set accessorMutator(value:String):void {_accessorMutator = value};

	public var foo:String = "bar";
}
