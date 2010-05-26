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
import melomel.commands.InvokeMethodCommand;
import melomel.commands.ICommand;

import flash.events.EventDispatcher;
import flash.errors.IllegalOperationError;

/**
 *	This class parses XML messages to build InvokeMethod commands. The parser
 *	handles the object proxy translation.
 *
 *	<p>The SET command has the following format:</p>
 *	
 *	<pre>
 *	&lt;set object="<i>proxy_id</i>" property=""&gt;
 *	  &lt;arg value="" dataType=""/&gt;
 *	&lt;/set&gt;
 *	</pre>
 *	
 *	@see melomel.commands.InvokeMethodCommand
 */
public class InvokeMethodCommandParser extends ObjectProxyCommandParser
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
	public function InvokeMethodCommandParser(manager:ObjectProxyManager)
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

		// Extract data from message
		var action:String     = message.localName();
		var proxyId:Number    = parseInt(message.@object);
		var proxy:ObjectProxy = manager.getItem(proxyId);
		var methodName:String = message.@method;
		
		// Verify message action
		if(action != "invoke") {
			throw new IllegalOperationError("Cannot parse action: '" + action + "'");
		}
		// Verify proxy id
		else if(isNaN(proxyId)) {
			throw new IllegalOperationError("Missing 'object' reference in message");
		}
		// Verify proxy exists
		else if(!proxy) {
			throw new IllegalOperationError("Object #" + proxyId + " does not exist");
		}
		// Verify method name exists
		else if(methodName == null || methodName.length == 0) {
			throw new IllegalOperationError("Method name is required in message");
		}

		// Extract arguments
		var methodArgs:Array = [];
		for each(var argXml:XML in message.args.arg) {
			methodArgs.push(parseMessageArgument(argXml));
		}
		
		// Return command
		return new InvokeMethodCommand(proxy.object, methodName, methodArgs);
	}
}
}