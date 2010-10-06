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
package melomel.commands
{
import melomel.commands.ICommand;
import melomel.core.Type;

import flash.events.EventDispatcher;
import melomel.errors.MelomelError;

/**
 *	This class represents an action of setting a property on an object to a
 *	given value.
 *	
 *	@see melomel.commands.parsers.SetPropertyCommandParser
 */
public class SetPropertyCommand implements ICommand
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 *	
	 *	@param object     The object to retrieve from.
	 *	@param property   The name of the property to retrieve.
	 *	@param value      The value to set the property to.
	 *	@param throwable  A flag stating if missing property errors are thrown.
	 */
	public function SetPropertyCommand(object:Object=null,
									   property:String=null,
									   value:Object=null,
									   throwable:Boolean=true)
	{
		this.object    = object;
		this.property  = property;
		this.value     = value;
		this.throwable = throwable;
	}
	

	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	/**
	 *	The object to retrieve the property from.
	 */
	public var object:Object;

	/**
	 *	The name of the property to retrieve.
	 */
	public var property:String;

	/**
	 *	The value to set the property to.
	 */
	public var value:Object;

	/**
	 *	A flag stating if the command will throw an error for missing
	 *	properties.
	 */
	public var throwable:Boolean;



	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	Sets the property on a given object to a given value. The new value of
	 *	the property is returned. This is used for property chaining.
	 *	
	 *	@return  The value of the property.
	 */
	public function execute():Object
	{
		// Verify object exists
		if(object == null) {
			throw new MelomelError("Cannot set property on a null object");
		}
		// Verify property exists
		if(property == null || property == "") {
			throw new MelomelError("Property name cannot be null or blank.");
		}

		// Set value. If property doesn't exist, set it if command is throwable
		if(Type.hasProperty(object, property, Type.WRITE) || throwable) {
			object[property] = value;
		}
		
		// Return new property value. This could be different than 'value'.
		if(Type.hasProperty(object, property, Type.READ)) {
			return object[property];
		}
		else {
			return null;
		}
	}
}
}