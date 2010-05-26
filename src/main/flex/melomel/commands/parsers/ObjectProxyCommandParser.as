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
package melomel.commands.parsers
{
import melomel.core.ObjectProxy;
import melomel.core.ObjectProxyManager;
import melomel.commands.ICommand;

import flash.events.EventDispatcher;
import flash.errors.IllegalOperationError;

/**
 *	This is the base class for parsers that use an object proxy manager.
 */
public class ObjectProxyCommandParser
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function ObjectProxyCommandParser(manager:ObjectProxyManager)
	{
		// Throw an error if proxy manager is missing
		if(!manager) {
			throw new IllegalOperationError("Object proxy manager is required for parser");
		}
		
		// Set manager
		this.manager = manager;
	}
	

	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Object proxy manager
	//---------------------------------

	/**
	 *	The proxy manager used for translating proxy ids into objects.
	 */
	protected var manager:ObjectProxyManager;


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	Parses an argument node. Argument nodes are references to values that
	 *	contain the value and data type.
	 *	
	 *	@param xml      The argument node.
	 *	
	 *	@return         The primitive value.
	 */
	protected function parseMessageArgument(xml:XML):Object
	{
		// Verify node
		if(!xml) {
			throw new IllegalOperationError("Message argument xml is required");
		}

		// Extract data from node
		var valueString:String = xml.@value;
		var dataType:String    = xml.@dataType;
		
		// Parse object proxy
		if(dataType == "object") {
			var proxy:ObjectProxy = manager.getItem(parseInt(valueString));
			if(!proxy) {
				throw new IllegalOperationError("Object #" + valueString + " does not exist");
			}
			return proxy.object;
		}
		// Parse int
		else if(dataType == "int") {
			return parseInt(valueString);
		}
		// Parse float
		else if(dataType == "float") {
			return parseFloat(valueString);
		}
		// Parse boolean
		else if(dataType == "boolean") {
			return (valueString == "true");
		}
		// Parse string
		else if(dataType == "string" || dataType == "" || !dataType) {
			return valueString;
		}
		// Invalid data type
		else {
			throw new IllegalOperationError("Invalid data type: " + dataType);
		}
	}
}
}