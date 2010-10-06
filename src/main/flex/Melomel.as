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
package
{
import melomel.core.Bridge;
import melomel.core.Type;
import melomel.errors.MelomelError;

import flash.events.EventDispatcher;
import flash.display.Stage;

/**
 *	This class serves as a global singleton of the bridge. This is sufficient
 *	for most applications. For applications that need multiple
 *	<code>Bridge</code>, you will need to instantiate and manage those
 *	individually.
 */
public class Melomel extends EventDispatcher
{
	MelomelClasses;

	//--------------------------------------------------------------------------
	//
	//	Static properties
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Bridge
	//---------------------------------
	
	static private var _bridge:Bridge;
	
	/**
	 *	A singleton instance of the bridge.
	 */
	static public function get bridge():Bridge
	{
		// Create a new bridge if it hasn't been accessed yet.
		if(!_bridge) {
			_bridge = new Bridge();
		}
		return _bridge;
	}


	//---------------------------------
	//	Stage
	//---------------------------------
	
	/**
	 *	A reference to the stage. This is initialized automatically for Flex
	 *	applications but has to be set manually when using a Flash-only
	 *	application.
	 */
	static public var stage:Stage;
	


	//---------------------------------
	//	Debug
	//---------------------------------
	
	/**
	 *	A flag stating if the melomel library will issue debug trace statements.
	 */
	static public var debug:Boolean = false;


	//--------------------------------------------------------------------------
	//
	//	Static methods
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Initialization
	//---------------------------------
	
	static private var initialized:Boolean = false;
	
	/**
	 *	Initializes Melomel. This only has to be done once.
	 */
	static public function initialize():void
	{
		// Only initialize once.
		if(initialized) return;
		
		// Set stage property if this is a Flex app.
		if(Type.getClass("mx.core.FlexGlobals")) {
			stage = Type.getClass("mx.core.FlexGlobals").topLevelApplication.stage as Stage;
		}
		else if(Type.getClass("mx.core.Application")) {
			stage = Type.getClass("mx.core.Application").application.stage as Stage;
		}
	}


	//---------------------------------
	//	Bridge
	//---------------------------------

	/**
	 *	Attempts to connect the bridge to the external interface.
	 *	
	 *	@param host  The host to connect to.
	 *	@param port  The port on the host to connect to.
	 */
	static public function connect(host:String="localhost", port:int=10101):void
	{
		bridge.host = host;
		bridge.port = port;
		bridge.connect();
	}
	

	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function Melomel()
	{
		throw new MelomelError("Melomel is a singleton and cannot be instantiated");
	}
}
}