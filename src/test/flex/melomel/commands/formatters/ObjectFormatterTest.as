package melomel.commands.formatters
{
import melomel.core.ObjectProxy;
import melomel.core.ObjectProxyManager;

import org.flexunit.Assert;
import org.flexunit.async.Async;

import flash.display.Stage;

public class ObjectFormatterTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var message:XML;
	private var manager:ObjectProxyManager;
	private var formatter:ObjectFormatter;
	
	[Before]
	public function setUp():void
	{
		manager = new ObjectProxyManager();
		formatter = new ObjectFormatter(manager);
	}

	[After]
	public function tearDown():void
	{
		message    = null;
		manager    = null;
		formatter  = null;
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Format
	//-----------------------------

	[Test]
	public function formatNull():void
	{
		message = formatter.format(null);
		Assert.assertEquals('<return dataType="null"/>', message.toXMLString());
	}

	[Test]
	public function formatString():void
	{
		message = formatter.format("foo");
		Assert.assertEquals('<return value="foo" dataType="string"/>', message.toXMLString());
	}

	[Test]
	public function formatInt():void
	{
		message = formatter.format(12);
		Assert.assertEquals('<return value="12" dataType="int"/>', message.toXMLString());
	}

	[Test]
	public function formatFloat():void
	{
		message = formatter.format(10.23);
		Assert.assertEquals('<return value="10.23" dataType="float"/>', message.toXMLString());
	}

	[Test]
	public function formatBooleanTrue():void
	{
		message = formatter.format(true);
		Assert.assertEquals('<return value="true" dataType="boolean"/>', message.toXMLString());
	}

	[Test]
	public function formatBooleanFalse():void
	{
		message = formatter.format(false);
		Assert.assertEquals('<return value="false" dataType="boolean"/>', message.toXMLString());
	}

	[Test]
	public function formatObject():void
	{
		var object:Object = {};
		var proxy:ObjectProxy = manager.addItem(object);
		message = formatter.format(object);
		Assert.assertEquals('<return value="' + proxy.id + '" dataType="object"/>', message.toXMLString());
	}
}
}