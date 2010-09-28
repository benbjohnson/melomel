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
package melomel.core
{
import flash.events.EventDispatcher;
import melomel.errors.MelomelError;

/**
 *	This class represents a pointer to an object in the Flash virtual machine.
 *	This object can be accessed by an external interface by referencing its
 *	proxy id.
 *	
 *	Object proxies are managed by the <code>ObjectProxyManager</code>.
 *	
 *	@see melomel.managers.ObjectProxyManager
 */
public class ObjectProxy
{
	//--------------------------------------------------------------------------
	//
	//	Static properties
	//
	//--------------------------------------------------------------------------

	/**
	 *	Stores the identifier to be used for the next object proxy. Proxy ids
	 *	autoincrement with the creation of each new proxy.
	 */
	static public var currentId:int = 1;


	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function ObjectProxy(object:Object)
	{
		// Throw an error if we don't have an object to proxy
		if(object == null) {
			throw new MelomelError("Object is required for object proxy");
		}
		
		// Set identifier and link object
		_id = currentId++;
		_object = object;
	}
	

	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Identifier
	//---------------------------------

	private var _id:int;
	
	/**
	 *	The proxy identifier.
	 */
	public function get id():int
	{
		return _id;
	}


	//---------------------------------
	//	Object
	//---------------------------------

	private var _object:Object;
	
	/**
	 *	The proxied object.
	 */
	public function get object():Object
	{
		return _object;
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Destroy
	//---------------------------------
	
	/**
	 *	Unlinks the object from the proxy. This is needed for garbage
	 *	collection.
	 */
	public function destroy():void
	{
		_object = null;
	}
}
}