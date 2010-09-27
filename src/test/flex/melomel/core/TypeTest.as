package melomel.core
{
import org.flexunit.Assert;
import org.flexunit.async.Async;

import flash.events.Event;

public class TypeTest
{
	//---------------------------------------------------------------------
	//
	//  Static methods
	//
	//---------------------------------------------------------------------

	private var testObj:TestClass;
	
	[Before(async)]
	public function setUp():void
	{
		testObj = new TestClass();
	}



	//---------------------------------------------------------------------
	//
	//  Static methods
	//
	//---------------------------------------------------------------------

	//---------------------------------
	//	Dynamic
	//---------------------------------

	[Test]
	public function shouldReturnTrueForDynamicObject():void
	{
		Assert.assertTrue(Type.isDynamic(new Object()));
	}

	[Test]
	public function shouldReturnFalseForNonDynamicObject():void
	{
		Assert.assertFalse(Type.isDynamic(new Event(Event.COMPLETE)));
	}


	//---------------------------------
	//	Properties
	//---------------------------------

	[Test]
	public function shouldHavePublicVariable():void
	{
		Assert.assertTrue(Type.hasProperty(testObj, "publicVariable"));
	}

	[Test]
	public function shouldNotHavePrivateVariable():void
	{
		Assert.assertFalse(Type.hasProperty(testObj, "privateVariable"));
	}

	[Test]
	public function shouldHavePublicAccessor():void
	{
		Assert.assertTrue(Type.hasProperty(testObj, "publicAccessor"));
	}

	[Test]
	public function shouldHaveReadablePublicAccessor():void
	{
		Assert.assertTrue(Type.hasProperty(testObj, "publicAccessor", Type.READ));
	}

	[Test]
	public function shouldNotHaveWritablePublicAccessor():void
	{
		Assert.assertFalse(Type.hasProperty(testObj, "publicAccessor", Type.WRITE));
	}

	[Test]
	public function shouldHavePublicMutator():void
	{
		Assert.assertTrue(Type.hasProperty(testObj, "publicMutator"));
	}

	[Test]
	public function shouldHaveWriteablePublicMutator():void
	{
		Assert.assertTrue(Type.hasProperty(testObj, "publicMutator", Type.WRITE));
	}

	[Test]
	public function shouldNotHaveReadablePublicMutator():void
	{
		Assert.assertFalse(Type.hasProperty(testObj, "publicMutator", Type.READ));
	}

	[Test]
	public function shouldHavePublicAccessorMutator():void
	{
		Assert.assertTrue(Type.hasProperty(testObj, "publicAccessorMutator"));
	}

	[Test]
	public function shouldHaveReadablePublicAccessorMutator():void
	{
		Assert.assertTrue(Type.hasProperty(testObj, "publicAccessorMutator", Type.READ));
	}

	[Test]
	public function shouldHaveWritablePublicAccessorMutator():void
	{
		Assert.assertTrue(Type.hasProperty(testObj, "publicAccessorMutator", Type.WRITE));
	}

	[Test]
	public function shouldHaveReadWriteAccessorMutator():void
	{
		Assert.assertTrue(Type.hasProperty(testObj, "publicAccessorMutator", Type.READ | Type.WRITE));
	}

	[Test]
	public function shouldHaveDynamicProperty():void
	{
		Assert.assertTrue(Type.hasProperty({name:"Bob"}, "name"));
	}

	[Test]
	public function shouldNotHaveMissingDynamicProperty():void
	{
		Assert.assertFalse(Type.hasProperty({name:"Bob"}, "foo"));
	}


	//---------------------------------
	//	Methods
	//---------------------------------

	[Test]
	public function shouldHaveMethod():void
	{
		Assert.assertTrue(Type.hasMethod(testObj, "zeroArgMethod"));
	}

	[Test]
	public function shouldNotHaveMissingMethod():void
	{
		Assert.assertFalse(Type.hasMethod(testObj, "noSuchMethod"));
	}


	[Test]
	public function shouldHaveZeroParameters():void
	{
		Assert.assertEquals(0, Type.getMethodParameterCount(testObj, "zeroArgMethod"));
	}

	[Test]
	public function shouldHaveMultipleParameters():void
	{
		Assert.assertEquals(2, Type.getMethodParameterCount(testObj, "multiArgMethod"));
	}
}
}


class TestClass
{
	public var publicVariable:String;
	private var privateVariable:String;

	public function get publicAccessor():String {return ""}
	public function set publicMutator(value:String):void {}

	public function get publicAccessorMutator():String {return ""}
	public function set publicAccessorMutator(value:String):void {}


	public function zeroArgMethod():void {}
	public function multiArgMethod(a:String, b:String):void {}
}
