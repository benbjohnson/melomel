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
package
{
import melomel.core.Bridge;

import flash.events.EventDispatcher;
import melomel.errors.MelomelError;

/**
 *	This class allows you to automatically start up a Melomel bridge through
 *	MMXL like this:
 *	
 *	<p><pre>
 *	<m:Melomel/>
 *	</pre></p>
 */
public class MXMLMelomel implements IMXMLObject
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function MXMLMelomel()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	/**
	 *	The hostname to connect to.
	 */
	public var host:String = "localhost";

	/**
	 *	The port to connect to on the host.
	 */
	public var port:int = 10101;
	

	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	public function initialized(document:Object, id:String):void
	{
		// Wait until creation complete before we connect
		(document as UIComponent).addEventListener(FlexEvent.CREATION_COMPLETE, document_onCreationComplete);
	}


	//--------------------------------------------------------------------------
	//
	//	Events
	//
	//--------------------------------------------------------------------------

	private function document_onCreationComplete(event:FlexEvent):void
	{
		Melomel.connect(host, port);
	}
}
}