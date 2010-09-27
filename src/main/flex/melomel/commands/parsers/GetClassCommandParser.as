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
import melomel.commands.GetClassCommand;
import melomel.commands.ICommand;

import flash.events.EventDispatcher;
import flash.errors.IllegalOperationError;

/**
 *	This class parses XML messages to build GetClass commands.
 *
 *	<p>The GET_CLASS command has the following format:</p>
 *	
 *	<pre>
 *	&lt;get-class name="<i>class name</i>" throwable="<i>true|false</i>"/&gt;
 *	</pre>
 *	
 *	@see melomel.commands.GetClassCommand
 */
public class GetClassCommandParser implements ICommandParser
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function GetClassCommandParser()
	{
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
		var name:String       = message.@name;
		var throwable:Boolean = (message.@throwable != "false");
		
		// Verify message action
		if(action != "get-class") {
			throw new IllegalOperationError("Cannot parse action: '" + action + "'");
		}
		// Verify name exists
		else if(name == null || name.length == 0) {
			throw new IllegalOperationError("Class name is required in message");
		}
		
		// Return command
		return new GetClassCommand(name, throwable);
	}
}
}