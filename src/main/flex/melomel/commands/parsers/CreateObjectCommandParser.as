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
import melomel.commands.CreateObjectCommand;
import melomel.commands.ICommand;

import flash.events.EventDispatcher;
import melomel.errors.MelomelError;
import flash.utils.getDefinitionByName;

/**
 *	This class parses XML messages to build CreateObject commands.
 *
 *	<p>The CREATE command has the following format:</p>
 *	
 *	<pre>
 *	&lt;create class="<i>class name</i>" throwable="<i>true|false</i>"/&gt;
 *	</pre>
 *	
 *	@see melomel.commands.CreateObjectCommand
 */
public class CreateObjectCommandParser implements ICommandParser
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function CreateObjectCommandParser()
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
			throw new MelomelError("Message is required for parsing");
		}

		// Extract data from message
		var action:String    = message.localName();
		var className:String = message['@class'];
		var throwable:Boolean = (message.@throwable != "false");
		
		// Verify message action
		if(action != "create") {
			throw new MelomelError("Cannot parse action: '" + action + "'");
		}
		// Verify name exists
		else if(className == null || className.length == 0) {
			throw new MelomelError("Class name is required in message");
		}
		
		// Find class by name
		var clazz:Class;
		try {
			clazz = getDefinitionByName(className) as Class;
		}
		catch(e:Error) {
			if(throwable) {
				throw new MelomelError("Cannot find class: " + className);
			}
		}

		// Return command
		return new CreateObjectCommand(clazz, throwable);
	}
}
}