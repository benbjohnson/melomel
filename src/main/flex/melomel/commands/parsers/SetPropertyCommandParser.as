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
import melomel.commands.SetPropertyCommand;
import melomel.commands.ICommand;

import flash.events.EventDispatcher;
import flash.errors.IllegalOperationError;

/**
 *	This class parses XML messages to build SetProperty commands. The parser
 *	handles the object proxy translation.
 *
 *	<p>The SET command has the following format:</p>
 *	
 *	<pre>
 *	&lt;set object="<i>proxy_id</i>" property="" throwable="true|false"&gt;
 *	  &lt;arg value="" dataType=""/&gt;
 *	&lt;/set&gt;
 *	</pre>
 *	
 *	@see melomel.commands.SetPropertyCommand
 */
public class SetPropertyCommandParser extends ObjectProxyCommandParser
								   implements ICommandParser
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function SetPropertyCommandParser(manager:ObjectProxyManager)
	{
		super(manager);
	}
	

	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	@copy ICommandParser#parse
	 */
	public function parse(message:XML):ICommand
	{
		// Verify message action
		if(!message) {
			throw new IllegalOperationError("Message is required for parsing");
		}
		else if(message.arg.length() == 0) {
			throw new IllegalOperationError("Message arg is required");
		}

		// Extract data from message
		var action:String     = message.localName();
		var proxyId:Number    = parseInt(message.@object);
		var object:Object     = manager.getItemById(proxyId);
		var property:String   = message.@property;
		var throwable:Boolean = (message.@throwable != "false");
		
		// Verify message action
		if(action != "set") {
			throw new IllegalOperationError("Cannot parse action: '" + action + "'");
		}
		// Verify proxy id
		else if(isNaN(proxyId)) {
			throw new IllegalOperationError("Missing 'object' reference in message");
		}
		// Verify proxy exists
		else if(!object) {
			throw new IllegalOperationError("Object #" + proxyId + " does not exist");
		}
		// Verify property exists
		else if(property == null || property.length == 0) {
			throw new IllegalOperationError("Property is required in message");
		}

		// Extract value argument
		var value:Object = parseMessageArgument(message.arg[0]);
		
		// Return command
		return new SetPropertyCommand(object, property, value, throwable);
	}
}
}