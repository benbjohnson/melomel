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
	 *	A running count of matched objects within findAll(). This is not thread
	 *	safe but luckily Flash only has one thread.
	 */
	static private var count:uint = 0;
	
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
								   properties:Object=null, limit:uint=0):Array
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
		
		// Convert clazz into an Array of classes.
		if(!(clazz is Array)) {
			clazz = [clazz];
		}
		
		// Convert class name to class reference, if necessary
		for(var i:int=0; i<clazz.length; i++) {
			if(clazz[i] is String) {
				try {
					clazz[i] = getDefinitionByName(clazz[i] as String);
				}
				catch(e:Error) {
					clazz.splice(i--, 1);
				}
			}
		}
		
		// Throw error if none of the classes passed in were found.
		if(clazz.length == 0) {
			throw new MelomelError("Classes could not be found");
		}

		count = 0;
		return _findAll(clazz as Array, root, properties);
	}

	static private function _findAll(classes:Array, root:DisplayObject,
								     properties:Object, limit:uint=0):Array
	{
		// Match root object first
		var objects:Array = new Array();
		
		// Attempt to match all classes
		var match:Boolean;
		for each(var clazz:Class in classes) {
			match = false;
			
			if(root is clazz) {
				match = true;
				
				if(properties) {
					// Match display object on properties
					for(var propName:String in properties) {
						if(!root.hasOwnProperty(propName) ||
						   root[propName] != properties[propName])
						{
							match = false;
							break;
						}
					}
				}
			}
			
			if(match) {
				break;
			}
		}

		// If class and properties match then add to list of components
		if(match && isVisible(root)) {
			objects.push(root);
			
			if(limit > 0 && ++count >= limit) {
				return objects;
			}
		}
		
		// Recursively search over children
		if(root is DisplayObjectContainer) {
			var numChildren:int = (root as DisplayObjectContainer).numChildren;
			for(var i:int=0; i<numChildren; i++) {
				var child:DisplayObject = (root as DisplayObjectContainer).getChildAt(i);
				
				// If matching descendants are found then append to list
				var arr:Array = _findAll(classes, child, properties);
				if(arr.length) {
					objects = objects.concat(arr);
				}
				
				// Exit if at limit.
				if(limit > 0 && count >= limit) {
					break;
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
		var objects:Array = findAll(clazz, root, properties, 1);
		return objects.shift();
	}

	/**
	 *	Attempts to find a component based on its position relative to a label.
	 *	This method starts by finding the label, then going up the parent
	 *	hierarchy and then recursively searching the parent for the first
	 *	component matching a given class.
	 *	
	 *	@param clazz       The class to match.
	 *	@param labelText   The label text to match.
	 *	@param root        The root display object to start from.
	 *	@param properties  A hash of property values to match.
	 *	
	 *	@return            The display object that is labeled by another
	 *                     display object.
	 */
	static public function findLabeled(clazz:Object, labelText:String,
									   root:DisplayObject,
									   properties:Object=null):*
	{
		// First find label
		var label:DisplayObject = find(['mx.controls.Label', 'spark.components.Label'], root, {text:labelText})
		
		// If found, recursively search parent for component
		if(label && label.parent) {
			var components:Array = findAll(clazz, label.parent, properties);
			if(components.indexOf(label) != -1) {
				components.splice(components.indexOf(label), 1);
			}
			return components.shift();
		}

		// If no label found, return null.
		return null;
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
		mouseDown(component, properties);
		mouseUp(component, properties);
		
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
	

	//---------------------------------
	//	Data Control Interaction
	//---------------------------------

	/**
	 *	Generates a list of labels from a data control.
	 *
	 *	@param component  A data control or column which has an itemToLabel()
	 *	                  method.
	 *	@param data       The dataset to generate labels from.
	 *
	 *	@return           A list of labels generated by the component.
	 */
	static public function itemsToLabels(component:Object, data:Object):Array
	{
		// Use source property if this is an ArrayList.
		if(Type.typeOf(data, "mx.collections.ArrayList")) {
			data = data.source;
		}
		
		// Loop over collection and generate labels
		var labels:Array = [];
		
		for each(var item:Object in data) {
			labels.push(component.itemToLabel(item));
		}
		
		return labels;
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