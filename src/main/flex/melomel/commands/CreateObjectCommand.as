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

/**
 *	This class represents an action that creates an object of a given class.
 *	
 *	@see melomel.commands.parsers.CreateObjectCommandParser
 */
public class CreateObjectCommand implements ICommand
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 *	
	 *	@param clazz      The class reference to instantiate from.
	 *	@param throwable  A flag stating if invalid class errors are thrown.
	 */
	public function CreateObjectCommand(clazz:Class=null,
										throwable:Boolean=true)
	{
		this.clazz     = clazz;
		this.throwable = throwable;
	}
	

	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	/**
	 *	The class to instantiate from.
	 */
	public var clazz:Class;

	/**
	 *	A flag stating if the command will throw an error for an invalid class.
	 */
	public var throwable:Boolean;


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	Instantiates an object from a class.
	 *	
	 *	@return  The instantiated object.
	 */
	public function execute():Object
	{
		// Verify class exists
		if(!clazz) {
			if(throwable) {
				throw new MelomelError("Class reference is required for instantiation");
			}
			else {
				return null;
			}
		}

		// Instantiate and return
		return (new clazz());
	}
}
}