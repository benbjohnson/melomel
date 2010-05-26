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
	public function getItem(id:int):ObjectProxy
	{
		return proxies[id] as ObjectProxy;
	}
	
	/**
	 *	Adds a proxy object to the manager.
	 *	
	 *	@param proxy  The object proxy to add to the manager.
	 */
	public function addItem(proxy:ObjectProxy):void
	{
		if(!proxy) {
			throw new IllegalOperationError("Proxy required when adding to ObjectProxyManager");
		}
		
		proxies[proxy.id] = proxy;
	}
	
	/**
	 *	Removes a proxy object from the manager.
	 *	
	 *	@param proxy  The object proxy to remove from the manager.
	 */
	public function removeItem(proxy:ObjectProxy):void
	{
		if(proxy) {
			proxies[proxy.id] = null;
			delete proxies[proxy.id];
		}
	}
	
	/**
	 *	Removes all proxy objects from the manager.
	 */
	public function removeAllItems():void
	{
		for each(var proxy:ObjectProxy in proxies) {
			removeItem(proxy);
		}
		proxies = {};
	}
}
}