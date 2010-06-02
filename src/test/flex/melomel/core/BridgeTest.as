package melomel.core
{
import melomel.commands.parsers.*;
import melomel.net.MockXMLSocket;

import org.flexunit.Assert;
import org.flexunit.async.Async;

import flash.events.DataEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.ProgressEvent;
import flash.events.ServerSocketConnectEvent;
import flash.net.Socket;
import flash.net.ServerSocket;
import flash.utils.setTimeout;

public class BridgeTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var bridge:Bridge;
	private var socket:MockXMLSocket;
	
	[Before]
	public function setUp():void
	{
		bridge = new MockBridge();
	}
	
	[After(async)]
	public function tearDown():void
	{
		bridge = null;
		socket = null;
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------

	//-----------------------------
	//  Connection
	//-----------------------------

	[Test(async)]
	public function connect():void
	{
		bridge.connect();
		socket = (bridge as MockBridge).getSocket() as MockXMLSocket;
		Async.proceedOnEvent(this, socket, Event.CONNECT);
	}

	[Test(async)]
	public function disconnect():void
	{
		bridge.connect();
		socket = (bridge as MockBridge).getSocket() as MockXMLSocket;
		Async.proceedOnEvent(this, socket, Event.CLOSE);
		bridge.disconnect();
	}


	//-----------------------------
	//  Parser Management
	//-----------------------------

	[Test]
	public function parserCanBeRetrievedByAction():void
	{
		var parser:GetPropertyCommandParser = new GetPropertyCommandParser(bridge.objectProxyManager);
		bridge.setParser("get", parser);
		Assert.assertEquals(parser, bridge.getParser("get"));
	}

	[Test]
	public function defaultActionsAreSetup():void
	{
		Assert.assertTrue(bridge.getParser("get-class") is GetClassCommandParser);
		Assert.assertTrue(bridge.getParser("get") is GetPropertyCommandParser);
		Assert.assertTrue(bridge.getParser("set") is SetPropertyCommandParser);
		Assert.assertTrue(bridge.getParser("invoke") is InvokeMethodCommandParser);
		Assert.assertTrue(bridge.getParser("create") is CreateObjectCommandParser);
	}


	//---------------------------------------------------------------------
	//
	//  Integration Tests
	//
	//---------------------------------------------------------------------

	[Test(async)]
	public function getClass():void
	{
		// Create proxy for class
		var proxy:ObjectProxy = bridge.objectProxyManager.addItem(BridgeTest);

		// Connect and wait on send event
		bridge.connect();
		socket = (bridge as MockBridge).getSocket() as MockXMLSocket;
		Async.proceedOnEvent(this, socket, "send");

		// Check send for correct data and send data to bridge
		socket.addEventListener("send", function(event:DataEvent):void{
			Assert.assertEquals('<return value="' + proxy.id + '" dataType="object"/>', event.data);
		}, false, 100);
		socket.receive('<get-class name="melomel.core.BridgeTest"/>');
	}
	
	[Test(async)]
	public function getProperty():void
	{
		// Create proxy for object
		var object:Object = {foo:"bar"};
		var proxy:ObjectProxy = bridge.objectProxyManager.addItem(object);

		// Connect and wait on send event
		bridge.connect();
		socket = (bridge as MockBridge).getSocket() as MockXMLSocket;
		Async.proceedOnEvent(this, socket, "send");

		// Check send for correct data and send data to bridge
		socket.addEventListener("send", function(event:DataEvent):void{
			Assert.assertEquals('<return value="bar" dataType="string"/>', event.data);
		}, false, 100);
		socket.receive('<get object="' + proxy.id + '" property="foo"/>');
	}
	
	[Test(async)]
	public function setProperty():void
	{
		// Create proxy for object
		var object:Object = {foo:"bar"};
		var proxy:ObjectProxy = bridge.objectProxyManager.addItem(object);

		// Connect and wait on send event
		bridge.connect();
		socket = (bridge as MockBridge).getSocket() as MockXMLSocket;
		Async.proceedOnEvent(this, socket, "send");

		// Check send for correct data and send data to bridge
		socket.addEventListener("send", function(event:DataEvent):void{
			Assert.assertEquals('<return value="baz" dataType="string"/>', event.data);
		}, false, 100);
		socket.receive('<set object="' + proxy.id + '" property="foo"><arg value="baz" dataType="string"/></set>');
	}
	
	[Test(async)]
	public function invokeMethod():void
	{
		// Create proxy for object
		var object:Object = {testFunc:function(name:String):String{return "Hello " + name}};
		var proxy:ObjectProxy = bridge.objectProxyManager.addItem(object);

		// Connect and wait on send event
		bridge.connect();
		socket = (bridge as MockBridge).getSocket() as MockXMLSocket;
		Async.proceedOnEvent(this, socket, "send");

		// Check send for correct data and send data to bridge
		socket.addEventListener("send", function(event:DataEvent):void{
			Assert.assertEquals('<return value="Hello World" dataType="string"/>', event.data);
		}, false, 100);
		socket.receive('<invoke object="' + proxy.id + '" method="testFunc"><args><arg value="World" dataType="string"/></args></invoke>');
	}

	[Test(async)]
	public function createObject():void
	{
		// Connect and wait on send event
		bridge.connect();
		socket = (bridge as MockBridge).getSocket() as MockXMLSocket;
		Async.proceedOnEvent(this, socket, "send");

		// Check send for correct data and send data to bridge
		socket.addEventListener("send", function(event:DataEvent):void{
			var response:XML = new XML(event.data);
			var object:Object = bridge.objectProxyManager.getItemById(parseInt(response.@value));
			Assert.assertEquals("return", response.localName().toString());
			Assert.assertEquals("object", response.@dataType);
			Assert.assertTrue(object is BridgeTest);
		}, false, 100);
		socket.receive('<create class="melomel.core.BridgeTest"/>');
	}
}
}
