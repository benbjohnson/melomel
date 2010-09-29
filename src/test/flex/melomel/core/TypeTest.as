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
	//	Properties (Instance)
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


	//---------------------------------
	//	Properties (Static)
	//---------------------------------

	[Test]
	public function shouldHaveStaticVariable():void
	{
		Assert.assertTrue(Type.hasProperty(TestClass, "staticVariable"));
	}

	[Test]
	public function shouldNotHaveInvalidStaticVariable():void
	{
		Assert.assertFalse(Type.hasProperty(TestClass, "noSuchProperty"));
	}

	[Test]
	public function shouldHaveStaticAccessor():void
	{
		Assert.assertTrue(Type.hasProperty(TestClass, "staticAccessor"));
	}

	[Test]
	public function shouldHaveReadableStaticAccessor():void
	{
		Assert.assertTrue(Type.hasProperty(TestClass, "staticAccessor", Type.READ));
	}

	[Test]
	public function shouldNotHaveWritableStaticAccessor():void
	{
		Assert.assertFalse(Type.hasProperty(TestClass, "staticAccessor", Type.WRITE));
	}

	[Test]
	public function shouldHaveStaticMutator():void
	{
		Assert.assertTrue(Type.hasProperty(TestClass, "staticMutator"));
	}

	[Test]
	public function shouldHaveWriteableStaticMutator():void
	{
		Assert.assertTrue(Type.hasProperty(TestClass, "staticMutator", Type.WRITE));
	}

	[Test]
	public function shouldNotHaveReadableStaticMutator():void
	{
		Assert.assertFalse(Type.hasProperty(TestClass, "staticMutator", Type.READ));
	}

	[Test]
	public function shouldHaveStaticAccessorMutator():void
	{
		Assert.assertTrue(Type.hasProperty(TestClass, "staticAccessorMutator"));
	}

	[Test]
	public function shouldHaveReadableStaticAccessorMutator():void
	{
		Assert.assertTrue(Type.hasProperty(TestClass, "staticAccessorMutator", Type.READ));
	}

	[Test]
	public function shouldHaveWritableStaticAccessorMutator():void
	{
		Assert.assertTrue(Type.hasProperty(TestClass, "staticAccessorMutator", Type.WRITE));
	}

	[Test]
	public function shouldHaveReadWriteStaticAccessorMutator():void
	{
		Assert.assertTrue(Type.hasProperty(TestClass, "staticAccessorMutator", Type.READ | Type.WRITE));
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
	//-------------------------------------------------------------------------
	//
	//	Static Properties
	//
	//-------------------------------------------------------------------------

	static public var staticVariable:String;

	static public function get staticAccessor():String {return ""}
	static public function set staticMutator(value:String):void {}

	static public function get staticAccessorMutator():String {return ""}
	static public function set staticAccessorMutator(value:String):void {}


	static public function staticZeroArgMethod():void {}
	static public function staticMultiArgMethod(a:String, b:String):void {}


	//-------------------------------------------------------------------------
	//
	//	Properties
	//
	//-------------------------------------------------------------------------

	public var publicVariable:String;
	private var privateVariable:String;

	public function get publicAccessor():String {return ""}
	public function set publicMutator(value:String):void {}

	public function get publicAccessorMutator():String {return ""}
	public function set publicAccessorMutator(value:String):void {}


	public function zeroArgMethod():void {}
	public function multiArgMethod(a:String, b:String):void {}
}
