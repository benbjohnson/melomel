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

import melomel.errors.MelomelError;

/**
 *	This class formats objects into XML messages in the following format:
 *
 *	<pre>
 *	&lt;error
 *	  proxyId=""
 *	  errorId=""
 *	  message=""
 *	  name=""
 *	&gt;
 *	  &lt;stackTrace&gt;
 *      <i>stack trace if available</i>
 *	  &lt;/stackTrace&gt;
 *	&lt;/error&gt;
 *	</pre>
 */
public class ErrorFormatter
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function ErrorFormatter(manager:ObjectProxyManager)
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
	//	Settings
	//---------------------------------

	/**
	 *	A flag stating whether the stack trace should be returned.
	 */
	public var stackTraceEnabled:Boolean = true;
	

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
	 *	Formats a value as an error message.
	 *	
	 *	@param error  The error to format.
	 *	
	 *	@return       An XML formatted error message.
	 */
	public function format(error:Error):XML
	{
		var proxy:ObjectProxy = manager.addItem(error);

		// Create error message
		var message:XML = new XML('<error/>');
		message.@proxyId = proxy.id;
		message.@errorId = error.errorID;
		message.@message = error.message;
		message.@name = error.name;
		
		// Append stack trace, if available and enabled.
		if(stackTraceEnabled && error.getStackTrace()) {
			var child:XML = <stackTrace/>;
			child.appendChild(error.getStackTrace());
			message.appendChild(child);
		}

		return message;
	}
}
}