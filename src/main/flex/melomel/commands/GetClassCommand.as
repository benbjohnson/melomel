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
import melomel.errors.MelomelError;
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
	 *	@param name       The qualified class name.
	 *	@param throwable  A flag stating if missing property errors are thrown.
	 */
	public function GetClassCommand(name:String=null, throwable:Boolean=true)
	{
		this.name      = name;
		this.throwable = throwable;
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

	/**
	 *	A flag stating if the command will throw an error if the class doesn't
	 *	exist.
	 */
	public var throwable:Boolean;


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
			throw new MelomelError("Class name cannot be null or blank.");
		}

		// Find class by name
		var clazz:Class;
		try {
			clazz = getDefinitionByName(name) as Class;
		}
		catch(e:Error) {
			if(throwable) {
				throw new MelomelError("Cannot find class: " + name);
			}
			else {
				return null;
			}
		}

		// Return class
		return clazz;
	}
}
}