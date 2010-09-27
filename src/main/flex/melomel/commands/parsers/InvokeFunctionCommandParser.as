/*
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * @author Nikita Dudnik
 */
package melomel.commands.parsers
{
import melomel.core.ObjectProxy;
import melomel.core.ObjectProxyManager;
import melomel.commands.InvokeFunctionCommand;
import melomel.commands.ICommand;

import flash.events.EventDispatcher;
import flash.errors.IllegalOperationError;

/**
 *	This class parses XML messages to build InvokeFunction commands.
 *
 *	<p>The GET_CLASS command has the following format:</p>
 *	
*	<pre>
 *	&lt;invoke-function name=""&gt;
 *	  &lt;arg value="" dataType=""/&gt;
 *	&lt;/set&gt;
 *	</pre>
 *	
 *	@see melomel.commands.InvokeFunctionCommand
 */
public class InvokeFunctionCommandParser  extends ObjectProxyCommandParser
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
	public function InvokeFunctionCommandParser(manager:ObjectProxyManager)
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
		var action:String       = message.localName();
		var functionName:String = message.@name;
		var throwable:Boolean = (message.@throwable != "false");
		
		// Verify message action
		if(action != "invoke-function") {
			throw new IllegalOperationError("Cannot parse action: '" + action + "'");
		}
		// Verify function name exists
		else if(functionName == null || functionName.length == 0) {
			throw new IllegalOperationError("Function name is required in message");
		}

		// Extract arguments
		var functionArgs:Array = [];
		for each(var argXml:XML in message.args.arg) {
			functionArgs.push(parseMessageArgument(argXml));
		}
		
		// Return command
		return new InvokeFunctionCommand(functionName, functionArgs, throwable);
	}
}
}