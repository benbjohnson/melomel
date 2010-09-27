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
import melomel.core.Type;
import melomel.commands.ICommand;

import flash.events.EventDispatcher;
import flash.errors.IllegalOperationError;

/**
 *	This class represents an action of returning a property from an object.
 *	
 *	@see melomel.commands.parsers.GetPropertyCommandParser
 */
public class GetPropertyCommand implements ICommand
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 *	
	 *	@param object    The object to retrieve from.
	 *	@param property  The name of the property to retrieve.
	 */
	public function GetPropertyCommand(object:Object=null, property:String=null)
	{
		this.object   = object;
		this.property = property;
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


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	Retrieves the value of the property on a given object.
	 *	
	 *	@return  The value of the property on the object.
	 */
	public function execute():Object
	{
		// Verify object exists
		if(object == null) {
			throw new IllegalOperationError("Cannot retrieve property from a null object");
		}
		// Verify property exists
		if(property == null || property == "") {
			throw new IllegalOperationError("Property name cannot be null or blank.");
		}

		// Try to access as property first.
		if(Type.hasProperty(object, property, Type.READ)) {
			return object[property];
		}
		// Otherwise try a zero-arg method.
		else if(Type.hasMethod(object, property) &&
		        Type.getMethodParameterCount(object, property) == 0)
		{
			return object[property]();
		}
		// Finally, if nothing works then act like we're trying to access a
		// property so we throw the appropriate error.
		else {
			return object[property];
		}
	}
}
}