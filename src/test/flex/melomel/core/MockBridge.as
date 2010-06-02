package melomel.core
{
import melomel.net.ISocket;
import melomel.net.MockXMLSocket;

public class MockBridge extends Bridge
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *	Constructor.
	 */
	public function MockBridge(host:String="localhost", port:int=10101)
	{
		super(host, port);
		socketClass = MockXMLSocket;
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	public function getSocket():ISocket
	{
		return socket;
	}
}
}