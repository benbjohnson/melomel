package melomel.net
{
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.setTimeout;

public class MockXMLSocket extends EventDispatcher implements ISocket
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function MockXMLSocket()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	private var _connected:Boolean = false;
	
	public function get connected():Boolean
	{
		return _connected;
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	public function connect(host:String, port:int):void {
		var self:MockXMLSocket = this;
		_connected = true;
		setTimeout(function():void{self.dispatchEvent(new Event(Event.CONNECT))}, 50);
	}

	public function close():void {
		var self:MockXMLSocket = this;
		_connected = false;
		setTimeout(function():void{dispatchEvent(new Event(Event.CLOSE))}, 50);
	}

	public function send(object:*):void
	{
		var data:String;
		if(object == null) {
			data = "";
		}
		if(object is XML) {
			data = object.toXMLString();
		}
		else {
			data = object.toString();
		}
		
		dispatchEvent(new DataEvent("send", false, false, data));
	}

	public function receive(data:String):void
	{
		dispatchEvent(new DataEvent(DataEvent.DATA, false, false, data));
	}

}
}