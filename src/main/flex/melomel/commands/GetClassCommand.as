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

import flash.events.EventDispatcher;
import flash.errors.IllegalOperationError;
import flash.utils.getDefinitionByName;

/**
 *	This class represents an action that returns a reference to a class.
 *	
 *	@see melomel.commands.parsers.GetClassCommandParser
 */
public class GetClassCommand implements ICommand
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 *	
	 *	@param name  The qualified class name.
	 */
	public function GetClassCommand(name:String=null)
	{
		this.name = name;
	}
	

	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	/**
	 *	The qualified class name.
	 */
	public var name:String;


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	Retrieves a reference to a class.
	 *	
	 *	@return  The class reference.
	 */
	public function execute():Object
	{
		// Verify class name exists
		if(name == null || name == "") {
			throw new IllegalOperationError("Class name cannot be null or blank.");
		}

		// Find class by name
		var clazz:Class;
		try {
			clazz = getDefinitionByName(name) as Class;
		}
		catch(e:Error) {
			throw new IllegalOperationError("Cannot find class: " + name);
		}

		// Return class
		return clazz;
	}
}
}