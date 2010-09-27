package melomel.core
{
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;

/**
 *  This class is used for accessing type descriptors.
 */
public class Type
{
	//-------------------------------------------------------------------------
	//
	//  Static properties
	//
	//-------------------------------------------------------------------------

	/**
	 *	A lookup of descriptors by class name.
	 */
	static private var descriptors:Dictionary = new Dictionary();
	
	/**
	 *	A list of class paths to use when instantiating classes.
	 */
	static public var classPath:Array = [];
	
	
	//-------------------------------------------------------------------------
	//
	//  Static methods
	//
	//-------------------------------------------------------------------------

	/**
	 *	Retrieves an xml descriptor of a class.
	 */
	static public function describeType(value:*):XML
	{
		// Return null if value is null
		if(value == null) {
			return null;
		}
		
		// Generate new descriptor if not cached
		if(!descriptors[value]) {
			descriptors[value] = flash.utils.describeType(value);
		}

		return descriptors[value] as XML;
	}


	/**
	 *	Checks if an object is dynamic.
	 *	
	 *	@param obj  The object to check.
	 *	
	 *	@return      A flag stating if the object is dynamic.
	 */
	static public function isDynamic(obj:Object):Boolean
	{
		var descriptor:XML = Type.describeType(obj);
		return (descriptor && descriptor.@isDynamic == "true");
	}
}
}