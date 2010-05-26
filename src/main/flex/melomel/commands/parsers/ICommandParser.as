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
import melomel.commands.ICommand;

import flash.events.EventDispatcher;
import flash.errors.IllegalOperationError;

/**
 *	This interface defines the methods for parsing commands.
 *	
 *	@see melomel.commands.GetPropertyCommandParser
 *	@see melomel.commands.SetPropertyCommandParser
 *	@see melomel.commands.InvokeMethodCommandParser
 *	@see melomel.commands.CreateObjectCommandParser
 */
public interface ICommandParser
{
	/**
	 *	Parses an XML message and creates a command object.
	 *	
	 *	@param message  The XML message to parse.
	 *	
	 *	@return         The command object created from the message.
	 */
	function parse(message:XML):ICommand;
}
}