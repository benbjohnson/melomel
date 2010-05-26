/*
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * @author Ben Johnson
 */
package melomel.core
{
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.errors.IllegalOperationError;
import flash.net.XMLSocket;

/**
 *	This class manages the connection between the external interface and the
 *	Flash virtual machine. All messages received are delegated to parsers and
 *	commands. All objects returned back to the external interface are run
 *	through a formatter.
 */
public class Bridge extends EventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function Bridge(host:String="localhost", port:int=10101)
	{
		this.host = host;
		this.port = port;
		
		// Setup object proxy manager
		objectProxyManager = new ObjectProxyManager();
		
		// Setup standard parsers
		setParser("get-class", new GetClassCommandParser());
		setParser("get", new GetPropertyCommandParser(objectProxyManager));
		setParser("set", new SetPropertyCommandParser(objectProxyManager));
		setParser("invoke", new InvokeMethodCommandParser(objectProxyManager));
		setParser("create", new CreateObjectCommandParser());
		
		// Setup standard formatter
		formatter = new CommandFormatter(objectProxyManager);
	}
	

	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Connection
	//---------------------------------

	/**
	 *	The hostname to connect to.
	 */
	private var socket:XMLSocket;

	/**
	 *	The hostname to connect to.
	 */
	public var host:String;

	/**
	 *	The port to connect to on the host.
	 */
	public var port:int;


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Connection
	//---------------------------------
	
	/**
	 *	Connects to the host over a socket connection.
	 */
	public function connect():void
	{
		socket = new XMLSocket();
		socket.addEventListener(Event.CONNECT, socket_onConnect);
		socket.addEventListener(Event.CLOSE, socket_onClose);
		socket.addEventListener(DataEvent.DATA, socket_onData);
		socket.addEventListener(IOErrorEvent.IO_ERROR, socket_onIOError);
		socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_onSecurityError);
		socket.connect(host, port);
	}
	
	/**
	 *	Disconnects the from the host.
	 */
	public function disconnect():void
	{
		if(socket) {
			socket.close();
			socket.removeEventListener(Event.CONNECT, socket_onConnect);
			socket.removeEventListener(Event.CLOSE, socket_onClose);
			socket.removeEventListener(DataEvent.DATA, socket_onData);
			socket.removeEventListener(IOErrorEvent.IO_ERROR, socket_onIOError);
			socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_onSecurityError);
			socket = null;
		}
	}

	/**
	 *	Sends a message to the external interface.
	 *	
	 *	@param message  The message to send.
	 */
	public function send(message:XML):void
	{
		trace("send> " + message.toXMLString());
		if(socket && socket.connected) {
			socket.send(message);
		}
		else {
			trace("Socket is closed. Message could not be sent.")
		}
	}

	/**
	 *	Receives a message from the external interface.
	 *	
	 *	@param message  The message from the external interface.
	 */
	public function receive(message:XML):void
	{
		trace("recv> " + message.toXMLString());

		// Locate parser for message
		var action:String = message.localName().toString();
		var parser:ICommandParser = getParser(action);
		
		if(!parser) {
			throw new IllegalOperationError("No parser found for action: " + action);
		}
		
		// Parse message
		var command:ICommand = parser.parse(message);
		
		// Execute command and return value
		send(formatter.format(command.execute()));
	}



	//---------------------------------
	//	Parsers
	//---------------------------------

	/**
	 *	Sets a parser to handle a specific action.
	 *	
	 *	@param action  The action for the parser to handle.
	 *	@param parser  The parser to use for the action.
	 */
	public function setParser(action:String, parser:ICommandParser):void
	{
		parsers[action] = parser;
	}

	/**
	 *	Retrieves the parser for a given action.
	 *	
	 *	@param action  The action to find a parser for.
	 *	
	 *	@return        The parser associated with the action.
	 */
	public function getParser(action:String):ICommandParser
	{
		return parsers[action] as ICommandParser;
	}



	//--------------------------------------------------------------------------
	//
	//	Events
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Socket
	//---------------------------------
	
	private function socket_onConnect(event:Event):void
	{
		trace("[CONNECT]");
		dispatchEvent(new Event(Event.CONNECT));
	}
	
	private function socket_onClose(event:Event):void
	{
		trace("[CLOSE]");
		disconnect();
		dispatchEvent(new Event(Event.CLOSE));
	}
	
	private function socket_onData(event:DataEvent):void
	{
		receive(new XML(event.data));
	}
	
	private function socket_onIOError(event:IOErrorEvent):void
	{
		trace("[IO_ERROR] " + event.text);
	}
	
	private function socket_onSecurityError(event:SecurityErrorEvent):void
	{
		trace("[SECURITY_ERROR] " + event.text);
	}
}
}