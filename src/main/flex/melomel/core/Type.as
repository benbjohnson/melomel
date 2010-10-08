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
	//  Static constants
	//
	//-------------------------------------------------------------------------

	public static const READ:int        = 1;

	public static const WRITE:int       = 2;


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

	//---------------------------------
	//	Class Utilities
	//---------------------------------
	
	/**
	 *	Retrieves a reference to a class by name.
	 *	
	 *	@param className  The name of the class.
	 *	
	 *	@return           A reference to the class.
	 */
	static public function getClass(className:String):Class
	{
		// Find class reference
		var clazz:Class;
		try {
			clazz = getDefinitionByName(className as String) as Class;
		}
		catch(e:Error) {}
		
		return clazz;
	}
	
	/**
	 *	Checks if an object is an instance of a class. This method is unique in
	 *	that it uses a class name instead of a class reference.
	 *	
	 *	@param object     The object to check the subclass of.
	 *	@param className  The name of the class.
	 *	
	 *	@return           Returns true if object is a subclass of class.
	 */
	static public function typeOf(object:Object, className:String):Boolean
	{
		// Find class reference
		var clazz:Class = getClass(className);
		if(!clazz) {
			return false;
		}
		
		// Check instance
		return (object is clazz);
	}


	//---------------------------------
	//	Type Descriptors
	//---------------------------------

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


	//---------------------------------
	//	Class Inspection
	//---------------------------------

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


	//---------------------------------
	//	Property Inspection
	//---------------------------------

	/**
	 *	Checks if a property exists on an object.
	 *	
	 *	@param obj       The object.
	 *	@param propName  The property name.
	 *	
	 *	@return          A flag stating if the property exists.
	 */
	static public function hasProperty(obj:Object, propName:String,
									   flags:uint=0):Boolean
	{
		// Return false for null objects.
		if(obj == null) {
			return false;
		}
		// Return true for all dynamic objects
		else if(isDynamic(obj) && !(obj is Class)) {
			return true;
		}
		
		// Retrieve descriptor and find property
		var descriptor:XML = Type.describeType(obj);
		var property:XML;
		
		// Search accessors first
		for each(var accessor:XML in descriptor.accessor) {
			if(accessor.@name == propName) {
				property = accessor;
				break;
			}
		}

		// If not found, try variables
		if(!property) {
			for each(var variable:XML in descriptor.variable) {
				if(variable.@name == propName) {
					property = variable;
					break;
				}
			}
		}
		
		// If found, check for flags
		if(property) {
			// Check access types
			if(flags && flags & Type.READ && property.@access == "writeonly") {
				return false;
			}
			else if(flags && flags & Type.WRITE && property.@access == "readonly") {
				return false;
			}
			else {
				return true;
			}
		}
		// If no property found, just return false.
		else {
			return false;
		}
	}


	//---------------------------------
	//	Method Inspection
	//---------------------------------

	/**
	 *	Checks if a method exists on an object.
	 *	
	 *	@param obj         The object.
	 *	@param methodName  The method name.
	 *	
	 *	@return          A flag stating if the method exists.
	 */
	static public function hasMethod(obj:Object, methodName:String):Boolean
	{
		// Return false for null objects.
		if(obj == null) {
			return false;
		}
		
		// Retrieve descriptor and find property
		var descriptor:XML = Type.describeType(obj);
		
		// Dynamic objects have all methods
		if(isDynamic(obj) && !(obj is Class)) {
			return true;
		}
		
		// Search methods
		for each(var method:XML in descriptor.method) {
			if(method.@name == methodName) {
				return true;
			}
		}
		
		// If not found by now, it doesn't exist.
		return false;
	}

	/**
	 *	Retrieves the number of parameters passed to a method.
	 *	
	 *	@param obj         The object.
	 *	@param methodName  The method name.
	 *	
	 *	@return            The number of parameters needed to call the method.
	 */
	static public function getMethodParameterCount(obj:Object,
												   methodName:String):uint
	{
		// Return false for null objects.
		if(obj == null) {
			return 0;
		}
		
		// Retrieve descriptor and find property
		var descriptor:XML = Type.describeType(obj);
		
		// Search methods
		for each(var method:XML in descriptor.method) {
			if(method.@name == methodName) {
				return method.parameter.length();
			}
		}
		
		// If no method found, return zero
		return 0;
	}
}
}