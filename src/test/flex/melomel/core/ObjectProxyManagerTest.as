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
	
	[Before]
	public function setUp():void
	{
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
		proxy = new ObjectProxy({});
		manager.addItem(proxy);
		Assert.assertEquals(proxy, manager.getItem(proxy.id));
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function addingNullShouldThrowError():void
	{
		manager.addItem(null);
	}

	[Test]
	public function removingItemShouldMakeItUnavailable():void
	{
		proxy = new ObjectProxy({});
		manager.addItem(proxy);
		manager.removeItem(proxy);
		Assert.assertNull(manager.getItem(proxy.id));
	}

	[Test]
	public function removingAllItemsShouldMakeThemUnavailable():void
	{
		proxy = new ObjectProxy({});
		manager.addItem(proxy);
		manager.removeAllItems();
		Assert.assertNull(manager.getItem(proxy.id));
	}
}
}