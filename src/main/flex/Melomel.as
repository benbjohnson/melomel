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
import melomel.core.UI;
import melomel.errors.MelomelError;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.display.DisplayObjectContainer;
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
	
	static private var _stage:Stage;
	
	/**
	 *	A reference to the stage. This is initialized automatically for Flex
	 *	applications but has to be set manually when using a Flash-only
	 *	application.
	 */
	static public function get stage():Stage
	{
		return _stage;
	}
	
	/**
	 *	@private
	 */
	static public function set stage(value:Stage):void
	{
		if(stage) {
			stage.removeEventListener(Event.ENTER_FRAME, stage_onEnterFrame);
		}
		
		_stage = value;

		if(stage) {
			stage.addEventListener(Event.ENTER_FRAME, stage_onEnterFrame);
		}
	}
	

	//---------------------------------
	//	Frames
	//---------------------------------

	/**
	 *	The default number of frames to wait.
	 */
	static public var defaultFramesToWait:uint = 5;

	/**
	 *	The current frame.
	 */
	static protected var currentFrame:uint = 0;

	/**
	 *	The frame to wait until.
	 */
	static protected var waitFrame:uint = 0;


	//---------------------------------
	//	Top level application
	//---------------------------------
	
	/**
	 *	Determines the top level application for the Flex application. This
	 *	is determined by FlexGlobals in Flex 4 and Application.application in
	 *	Flex 3.
	 */
	static public function get topLevelApplication():*
	{
		// Set stage property if this is a Flex app.
		if(Type.getClass("mx.core.FlexGlobals")) {
			return Type.getClass("mx.core.FlexGlobals").topLevelApplication;
		}
		else if(Type.getClass("mx.core.Application")) {
			return Type.getClass("mx.core.Application").application;
		}
		
		return null;
	}



	//---------------------------------
	//	Busy
	//---------------------------------
	
	/**
	 *	A flag stating if the interface is currently busy. This can occur under
	 *	the following conditions:
	 *
	 *	<ul>
	 *	  <li>A specified number of frames have not passed since the last call
	 *	      to <code>Melomel.wait()</code>.</li>
	 *	  <li>The busy cursor is currently visible to the user.</li>
	 *  </ul>
	 */
	static public function get busy():Boolean
	{
		// If we haven't reached the wait frame then we're busy.
		if(waitFrame > 0 && currentFrame <= waitFrame) {
			return true;
		}

		// If there's a busy cursor then we're busy.
		if(hasBusyCursor()) {
			return true;
		}
		
		// If we're not busy then clear wait frame and return false.
		waitFrame = 0;
		return false;
	}
	
	
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
		
		// Find stage
		if(topLevelApplication) {
			stage = topLevelApplication.stage;
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
	
	
	//---------------------------------
	//	Busy state
	//---------------------------------

	/**
	 *	Sets <code>Melomel.busy</code> to <code>true</code> for the specified
	 *	number of frames.
	 */
	static public function wait(count:int=-1):void
	{
		if(count < 0) {
			count = defaultFramesToWait;
		}
		
		waitFrame = currentFrame + count;
	}
	
	/**
	 *	Determines if a busy cursor is being shown by the CursorManager.
	 *	
	 *	@return  True if there is a visible busy cursor. Otherwise, false.
	 */
	static public function hasBusyCursor():Boolean
	{
		if(topLevelApplication) {
			var busyCursorClass:Class = Type.getClass("mx.skins.halo.BusyCursor");
			var systemManager:Object = topLevelApplication.systemManager;

			for(var i:int=0; i<systemManager.cursorChildren.numChildren; i++) {
				var holder:DisplayObjectContainer = systemManager.cursorChildren.getChildAt(i) as DisplayObjectContainer;
				if(holder.numChildren > 0 && holder.getChildAt(0) is busyCursorClass) {
					return true;
				}
			}
		}

		return false;
	}
	

	//--------------------------------------------------------------------------
	//
	//	Static events
	//
	//--------------------------------------------------------------------------

	static private function stage_onEnterFrame(event:Event):void
	{
		currentFrame++;
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