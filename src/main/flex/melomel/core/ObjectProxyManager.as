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
import melomel.core.ObjectProxy;

import flash.events.EventDispatcher;
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

/**
 *	This class defines a manager of proxied objects. Proxied objects have a
 *	unique identifier that is passed to the external client to reference the
 *	object. To access the object again, the external client sends the proxy id.
 *	
 *	@see melomel.core.ObjectProxy
 */
public class ObjectProxyManager extends EventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function ObjectProxyManager()
	{
		super();
	}
	

	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Proxies
	//---------------------------------

	/**
	 *	A lookup of proxies by proxy id.
	 */
	private var proxies:Object = {};

	/**
	 *	A lookup of proxies by object.
	 */
	private var objects:Dictionary = new Dictionary();


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Object management
	//---------------------------------
	
	/**
	 *	Retrieves a proxied object by proxy id.
	 *	
	 *	@param id  The proxy identifier.
	 *	
	 *	@return    The object proxy.
	 */
	public function getItemById(id:int):Object
	{
		var proxy:ObjectProxy = proxies[id] as ObjectProxy;
		if(proxy) {
			return proxy.object;
		}
		else {
			return null;
		}
	}
	
	/**
	 *	Adds a object to the manager.
	 *	
	 *	@param object  The object proxy to add to the manager.
	 */
	public function addItem(object:Object):ObjectProxy
	{
		var proxy:ObjectProxy;
		
		if(!object) {
			throw new IllegalOperationError("Object is required");
		}
		
		// If object is already proxied, return existing reference
		if(objects[object]) {
			proxy = objects[object] as ObjectProxy;
		}
		// Otherwise create a new proxy
		else {
			proxy = new ObjectProxy(object);
			proxies[proxy.id]     = proxy;
			objects[proxy.object] = proxy;
		}
		
		return proxy;
	}
	
	/**
	 *	Removes an object from the manager.
	 *	
	 *	@param object  The object to remove from the manager.
	 */
	public function removeItem(object:Object):void
	{
		var proxy:ObjectProxy = objects[object] as ObjectProxy;
		if(proxy) {
			delete proxies[proxy.id];
			delete objects[proxy.object];
		}
	}
	
	/**
	 *	Removes all proxy objects from the manager.
	 */
	public function removeAllItems():void
	{
		for each(var object:Object in objects) {
			removeItem(object);
		}
		proxies = {};
		objects = new Dictionary();
	}
}
}