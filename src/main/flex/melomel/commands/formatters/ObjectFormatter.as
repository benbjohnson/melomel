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
package melomel.commands.formatters
{
import melomel.core.ObjectProxy;
import melomel.core.ObjectProxyManager;

import flash.events.EventDispatcher;
import melomel.errors.MelomelError;

/**
 *	This class formats objects into XML messages in the following format:
 *
 *	<pre>
 *	&lt;return value="" dataType=""/&gt;
 *	</pre>
 */
public class ObjectFormatter
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function ObjectFormatter(manager:ObjectProxyManager)
	{
		// Throw an error if proxy manager is missing
		if(!manager) {
			throw new MelomelError("Object proxy manager is required for formatter");
		}
		
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
	 *	Formats a value as a return object.
	 *	
	 *	@param value  The value to format.
	 *	
	 *	@return       An XML formatted return message.
	 */
	public function format(value:Object):XML
	{
		var message:XML = new XML('<return/>');
		
		// Format null
		if(value == null) {
			message.@dataType = "null";
		}
		// Format objects
		else if(typeof(value) == "object") {
			var proxy:ObjectProxy = manager.addItem(value);
			message.@value    = proxy.id;
			message.@dataType = "object";
		}
		// Format numbers
		else if(typeof(value) == "number") {
			message.@value    = value;
			message.@dataType = (Math.floor(value as Number) == value ? "int" : "float");
		}
		// Format boolean values
		else if(typeof(value) == "boolean") {
			message.@value    = value;
			message.@dataType = "boolean";
		}
		// Format everything else as a string
		else {
			message.@value    = value;
			message.@dataType = "string";
		}
		
		return message;
	}
}
}