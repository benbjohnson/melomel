package melomel.core
{
import org.flexunit.Assert;
import org.flexunit.async.Async;

public class ObjectProxyManagerTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var manager:ObjectProxyManager;
	private var proxy:ObjectProxy;
	private var object:Object;
	
	[Before]
	public function setUp():void
	{
		object = {};
		manager = new ObjectProxyManager();
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Item management
	//-----------------------------

	[Test]
	public function addedItemShouldBeAvailableForRetrieval():void
	{
		var object:Object = {};
		proxy = manager.addItem(object);
		Assert.assertEquals(object, manager.getItemById(proxy.id));
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function addingNullShouldThrowError():void
	{
		manager.addItem(null);
	}

	[Test]
	public function addedItemTwiceShouldReuseProxy():void
	{
		var pa:ObjectProxy = manager.addItem(object);
		var pb:ObjectProxy = manager.addItem(object);
		Assert.assertEquals(pa, pb);
	}

	[Test]
	public function addingTwoItemsShouldHaveDifferentProxies():void
	{
		var a:Object = {};
		var b:Object = {};
		var pa:ObjectProxy = manager.addItem(a);
		var pb:ObjectProxy = manager.addItem(b);
		Assert.assertTrue(pa != pb);
	}

	[Test]
	public function removingItemShouldMakeItUnavailable():void
	{
		proxy = manager.addItem(object);
		manager.removeItem(object);
		Assert.assertNull(manager.getItemById(proxy.id));
	}

	[Test]
	public function removingAllItemsShouldMakeThemUnavailable():void
	{
		proxy = manager.addItem(object);
		manager.removeAllItems();
		Assert.assertNull(manager.getItemById(proxy.id));
	}
}
}