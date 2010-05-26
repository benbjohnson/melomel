package melomel.core
{
import org.flexunit.Assert;
import org.flexunit.async.Async;

public class ObjectProxyTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var proxy:ObjectProxy;
	
	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Constructor
	//-----------------------------

	[Test]
	public function constructWithObject():void
	{
		var object:Object = {};
		proxy = new ObjectProxy(object);
		Assert.assertEquals(proxy.object, object);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function constructWithoutObjectThrowsError():void
	{
		proxy = new ObjectProxy(null);
	}


	//-----------------------------
	//  Identifier
	//-----------------------------
	
	[Test]
	public function proxyIdShouldIncrement():void
	{
		var object:Object = {};
		var p0:ObjectProxy = new ObjectProxy(object);
		var p1:ObjectProxy = new ObjectProxy(object);
		Assert.assertEquals(p1.id, p0.id+1);
	}


	//-----------------------------
	//  Destructor
	//-----------------------------
	
	[Test]
	public function destroyUnlinksObject():void
	{
		var object:Object = {};
		proxy = new ObjectProxy(object);
		proxy.destroy();
		Assert.assertNull(proxy.object);
	}
	
}
}