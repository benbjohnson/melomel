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
import melomel.commands.ICommand;
import melomel.commands.formatters.ErrorFormatter;
import melomel.commands.formatters.ObjectFormatter;
import melomel.commands.parsers.ICommandParser;
import melomel.commands.parsers.GetClassCommandParser;
import melomel.commands.parsers.GetPropertyCommandParser;
import melomel.commands.parsers.SetPropertyCommandParser;
import melomel.commands.parsers.InvokeMethodCommandParser;
import melomel.commands.parsers.CreateObjectCommandParser;
import melomel.commands.parsers.InvokeFunctionCommandParser;


import flash.events.DataEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import melomel.errors.MelomelError;
import flash.net.XMLSocket;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

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
		_objectProxyManager = new ObjectProxyManager();
		
		// Setup standard parsers
		setParser("get-class", new GetClassCommandParser());
		setParser("get", new GetPropertyCommandParser(objectProxyManager));
		setParser("set", new SetPropertyCommandParser(objectProxyManager));
		setParser("invoke", new InvokeMethodCommandParser(objectProxyManager));
		setParser("invoke-function", new InvokeFunctionCommandParser(objectProxyManager));
		setParser("create", new CreateObjectCommandParser());
		
		// Setup formatters
		objectFormatter = new ObjectFormatter(objectProxyManager);
		errorFormatter = new ErrorFormatter(objectProxyManager);
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
	 *	The socket connection used to communicate with the external interface.
	 */
	protected var socket:XMLSocket;

	/**
	 *	The class to instantiate the socket from.
	 */
	protected var socketClass:Class = XMLSocket;

	/**
	 *	The hostname to connect to.
	 */
	public var host:String;

	/**
	 *	The port to connect to on the host.
	 */
	public var port:int;

	/**
	 *	The length of time, in milliseconds, to wait in between retries when
	 *	connecting to the external interface. If this is set to zero, the
	 *	connection is not retried when it fails.
	 */
	public var retryDelay:int = 1000;

	/**
	 *	The timeout identifier for connection attempts.
	 */
	private var connectTimeoutId:int = 0;


	//---------------------------------
	//	Object proxy manager
	//---------------------------------

	private var _objectProxyManager:ObjectProxyManager;

	/**
	 *	The proxy manager.
	 */
	public function get objectProxyManager():ObjectProxyManager
	{
		return _objectProxyManager;
	}


	//---------------------------------
	//	Parsers
	//---------------------------------

	/**
	 *	A lookup of parsers by action.
	 */
	private var parsers:Object = {};


	//---------------------------------
	//	Formatter
	//---------------------------------

	/**
	 *	The formatter to use for outgoing messages.
	 */
	public var objectFormatter:ObjectFormatter;

	/**
	 *	The formatter to use for outgoing errors.
	 */
	public var errorFormatter:ErrorFormatter;


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
		socket = new socketClass();
		socket.addEventListener(Event.CONNECT, socket_onConnect);
		socket.addEventListener(Event.CLOSE, socket_onClose);
		socket.addEventListener(DataEvent.DATA, socket_onData);
		socket.addEventListener(IOErrorEvent.IO_ERROR, socket_onIOError);
		socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_onSecurityError);
		socket.connect(host, port);
		
		// Attempt connection again if not connected
		if(retryDelay > 0) {
			connectTimeoutId = setTimeout(connect, retryDelay);
		}
	}
	
	/**
	 *	Disconnects the from the host.
	 */
	public function disconnect():void
	{
		// Stop any retries
		clearTimeout(connectTimeoutId);
		connectTimeoutId = 0;
		
		// If a socket has been created, close it out.
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
		if(Melomel.debug) trace("send> " + message.toXMLString());
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
		if(Melomel.debug) trace("recv> " + message.toXMLString());

		var error:Error;

		// Locate parser for message
		var action:String = message.localName().toString();
		var parser:ICommandParser = getParser(action);
		
		if(!parser) {
			throw new MelomelError("No parser found for action: " + action);
		}
		
		// Parse message
		var command:ICommand;
		try {
			command = parser.parse(message);
		}
		catch(e:Error) {
			error = e;
			send(errorFormatter.format(e));
			return;
		}
		
		// Execute command and return value
		var result:Object;
		try {
			result = command.execute();
		}
		catch(e:Error) {
			error = e;
			send(errorFormatter.format(e));
			return;
		}

		// If no error was caught, send back the result
		if(!error) {
			send(objectFormatter.format(result));
		}
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
		if(Melomel.debug) trace("[CONNECT]");
		Melomel.initialize();
		clearTimeout(connectTimeoutId);
		connectTimeoutId = 0;
		send(<connect/>);
		dispatchEvent(new Event(Event.CONNECT));
	}
	
	private function socket_onClose(event:Event):void
	{
		if(Melomel.debug) trace("[CLOSE]");
		disconnect();
		dispatchEvent(new Event(Event.CLOSE));
	}
	
	private function socket_onData(event:DataEvent):void
	{
		receive(new XML(event.data));
	}
	
	private function socket_onIOError(event:IOErrorEvent):void
	{
		if(Melomel.debug) trace("[IO_ERROR] " + event.text);
	}
	
	private function socket_onSecurityError(event:SecurityErrorEvent):void
	{
		if(Melomel.debug) trace("[SECURITY_ERROR] " + event.text);
	}
}
}