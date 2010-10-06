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
import melomel.errors.MelomelError;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.getDefinitionByName;

/**
 *	This class provides user interface related utility methods for finding
 *	display objects and appropriately interacting with them.
 */
public class UI
{
	//--------------------------------------------------------------------------
	//
	//	Static methods
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Search
	//---------------------------------
	
	/**
	 *	Recursively searches the display hiearchy to find a display object.
	 *	
	 *	@param clazz       The class to match.
	 *	@param root        The root display object to start from.
	 *	@param properties  A hash of property values to match.
	 *	
	 *	@return            A list of display objects matching the class and
	 *	                   properties specified in the criteria.
	 */
	static public function findAll(clazz:Object, root:DisplayObject,
								   properties:Object=null):Array
	{
		// Attempt to default root if not specified
		if(!root) {
			root = Melomel.stage;
		}
		
		// Verify class is not null
		if(!clazz) {
			throw new MelomelError("A class name or reference is required");
		}
		// Find root if not passed in
		if(!root) {
			throw new MelomelError("The root display object is required");
		}
		
		// Convert class name to class reference, if necessary
		if(clazz is String) {
			try {
				clazz = getDefinitionByName(clazz as String);
			}
			catch(e:Error) {
				throw new MelomelError("Cannot find class: " + clazz);
			}
		}
		
		// Match root object first
		var objects:Array = new Array();

		if(root is (clazz as Class)) {
			var isMatch:Boolean = true;

			if(properties) {
				// Match display object on properties
				for(var propName:String in properties) {
					if(!root.hasOwnProperty(propName) ||
					   root[propName] != properties[propName])
					{
						isMatch = false;
						break;
					}
				}
			}
			
			// If class and properties match then add to list of components
			if(isMatch && isVisible(root)) {
				objects.push(root);
			}
		}
		
		// Recursively search over children
		if(root is DisplayObjectContainer) {
			var numChildren:int = (root as DisplayObjectContainer).numChildren;
			for(var i:int=0; i<numChildren; i++) {
				var child:DisplayObject = (root as DisplayObjectContainer).getChildAt(i);
				
				// If matching descendants are found then append to list
				var arr:Array = findAll(clazz, child, properties);
				if(arr.length) {
					objects = objects.concat(arr);
				}
			}
		}
		
		// Return list of objects
		return objects;
	}
	
	/**
	 *	Recursively searches the display hiearchy to find a display object.
	 *	
	 *	@param clazz       The class to match.
	 *	@param root        The root display object to start from.
	 *	@param properties  A hash of property values to match.
	 *	
	 *	@return            A display object matching the class and properties
	 *	                   specified in the criteria.
	 */
	static public function find(clazz:Object, root:DisplayObject,
								properties:Object=null):*
	{
		var objects:Array = findAll(clazz, root, properties);
		return objects.shift();
	}

	/**
	 *	Checks if a display object is visible and all of its parents are
	 *	visible.
	 *	
	 *	@param object  The display object to verify.
	 *	
	 *	@return        True if all parents and object are visible. Otherwise,
	 *                 returns false.
	 */
	static public function isVisible(object:DisplayObject):Boolean
	{
		// If we have no display object, return false
		if(object == null) {
			return false;
		}
		
		// Iterate up the parent hierarchy looking for invisible parents
		while(object != null) {
			// If we find an invisible parent, return false.
			if(!object.visible) {
				return false;
			}
			
			object = object.parent;
		}
		
		// If no parents were invisible, return true.
		return true;
	}


	//---------------------------------
	//	UI interactions
	//---------------------------------

	/**
	 *	Generalizes the interaction with a component.
	 *	
	 *	@param event       The event.
	 *	@param component   The component to interact with.
	 *	@param properties  A hash of properties to set on the event object.
	 *	@param flags       A list of flags determining the behavior.
	 */
	static private function interact(event:Event, component:Object,
									 properties:Object):void
	{
		// Default properties to an empty hash
		if(properties == null) {
			properties = {};
		}
		
		// If we are using a Flex component, make sure it is enabled
		if(Type.typeOf(component, "mx.core.UIComponent") && !component.enabled) {
			throw new MelomelError("Flex component is disabled");
		}
		
		// Validate mouse-specific actions
		if(event is MouseEvent) {
			// Component must be mouse enabled
			if(!component.mouseEnabled) {
				throw new MelomelError("Mouse events are not enabled on component");
			}

			// Center the click
			if(!properties.localX) {
				properties.localX = Math.floor(component.width/2);
			}
			if(!properties.localY) {
				properties.localY = Math.floor(component.height/2);
			}
		}

		// Validate keyboard-specific actions
		if(event is KeyboardEvent) {
			var char:Object = properties["char"];
			delete properties["char"];
			
			// Verify that a key is specified to be pressed
			if(char == null || char == "") {
				throw new MelomelError("A keyboard key is required");
			}
			// Verify that only one character is specified
			if(char is String && char.length > 1) {
				throw new MelomelError("Only one keyboard key can be pressed at a time");
			}
			
			// Convert to keyCode & charCode
			if(char is String) {
				properties.charCode = char.charCodeAt(0);
				properties.keyCode  = char.toUpperCase().charCodeAt(0);

				// Automatically set the shift key for uppercase characters
				if(char.search(/[A-Z]/) != -1) {
					properties.shiftKey = true;
				}
			}
			else if(char is int) {
				if(String.fromCharCode(char).toUpperCase().search(/[0-9A-Z]/) != -1) {
					properties.charCode = String.fromCharCode(char).toUpperCase().charCodeAt(0);
				}
				else {
					properties.charCode = 0;
				}
				properties.keyCode  = char;
			}
			else {
				throw new MelomelError("Keyboard character must be a string or a key code value");
			}
			
			// Find UITextField inside text components
			var textField:TextField = find(TextField, component as DisplayObject);
			if(textField) {
				component = textField;
			}
		}

		// Copy properties to event
		for(var propName:String in properties) {
			event[propName] = properties[propName];
		}
		
		// Dispatch event
		component.dispatchEvent(event);
	}
	
	/**
	 *	Imitates a click on a component.
	 *	
	 *	@param component   The component to click.
	 *	@param properties  A hash of properties to set on the event object.
	 */
	static public function click(component:InteractiveObject,
								 properties:Object=null):void
	{
		// NOTE: There is currently an error fired from ActiveWindowManager
		//       when the MOUSE_DOWN event is fired.
		// mouseDown(component, properties);
		// mouseUp(component, properties);
		
		interact(new MouseEvent(MouseEvent.CLICK), component, properties)
	}

	/**
	 *	Imitates a double click on a component.
	 *	
	 *	@param component   The component to double click.
	 *	@param properties  A hash of properties to set on the event object.
	 */
	static public function doubleClick(component:InteractiveObject,
									   properties:Object=null):void
	{
		// Component must be mouse enabled
		if(!component.doubleClickEnabled) {
			throw new MelomelError("Double clicking is not enabled on component");
		}

		click(component, properties);
		click(component, properties);
		interact(new MouseEvent(MouseEvent.DOUBLE_CLICK), component, properties)
	}
	
	/**
	 *	Imitates the mouse button clicking down on a component.
	 *	
	 *	@param component   The component to click down.
	 *	@param properties  A hash of properties to set on the event object.
	 */
	static public function mouseDown(component:InteractiveObject,
									 properties:Object=null):void
	{
		interact(new MouseEvent(MouseEvent.MOUSE_DOWN), component, properties)
	}

	/**
	 *	Imitates the mouse button being released on a component.
	 *	
	 *	@param component   The component to click up.
	 *	@param properties  A hash of properties to set on the event object.
	 */
	static public function mouseUp(component:InteractiveObject,
								   properties:Object=null):void
	{
		interact(new MouseEvent(MouseEvent.MOUSE_UP), component, properties)
	}
	
	/**
	 *	Imitates the a keyboard key being pressed down on a component.
	 *	
	 *	@param component   The component that should receive the event.
	 *	@param char        The keyboard character being pressed.
	 *	@param properties  A hash of properties to set on the event object.
	 */
	static public function keyDown(component:InteractiveObject, char:Object,
								   properties:Object=null):void
	{
		if(properties == null) {
			properties = {};
		}
		properties["char"] = char;
		interact(new KeyboardEvent(KeyboardEvent.KEY_DOWN), component, properties)
	}
	
	/**
	 *	Imitates the a keyboard key being released on a component.
	 *	
	 *	@param component   The component that should receive the event.
	 *	@param char        The keyboard character being pressed.
	 *	@param properties  A hash of properties to set on the event object.
	 */
	static public function keyUp(component:InteractiveObject, char:Object,
								 properties:Object=null):void
	{
		if(properties == null) {
			properties = {};
		}
		properties["char"] = char;
		interact(new KeyboardEvent(KeyboardEvent.KEY_UP), component, properties)
	}
	
	/**
	 *	Imitates the a keyboard key being pressed and released on a component.
	 *	
	 *	@param component   The component that should receive the event.
	 *	@param char        The keyboard character being pressed.
	 *	@param properties  A hash of properties to set on the event object.
	 */
	static public function keyPress(component:InteractiveObject, char:Object,
									properties:Object=null):void
	{
		if(properties == null) {
			properties = {};
		}
		properties["char"] = char;

		keyDown(component, char, properties);
		keyUp(component, char, properties);
	}
	

	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function UI()
	{
		throw new MelomelError("Cannot instantiate the UI class")
	}
}
}