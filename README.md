melomel -- An external ActionScript interface
=============================================

## DESCRIPTION

Melomel is an API for accessing ActionScript objects in the Flash virtual
machine through external languages.

The API communicates through commands sent using XML over sockets so any
language with socket support can work with Melomel. The following commands
are available:

* Create Object
* Get Class
* Get Property
* Set Property
* Invoke Method

The implementation in external languages should conceal these commands in the
implementation so that developers in the external language can naturally work
with the object as if they were native to their programming language. For
example, Ruby uses `method_missing` to allow developers to get and set
properties and invoke methods on objects as if they were native Ruby objects.

Melomel is not a data transport protocol. Primitive data types are passed back
and forth but objects are sent as references. The objects only exist within the
Flash virtual machine and only a pointer is sent to the external language to
reference it. This makes it so that there are no syncing issues between the
external language and the Flash virtual machine.

Melomel follows the rules of [Semantic Versioning](http://semver.org/) and uses
[asdoc](http://livedocs.adobe.com/flex/3/html/asdoc_1.html) for inline
documentation.


## INSTALLATION

To install Melomel, include the compiled `melomel.swc` into your project:

	$ mxmlc --include-library+=melomel.swc MyApp.mxml

Inside your application, make a single call to `Melomel.connect()` and Melomel
will asynchronously attempt to connect to an external language once per second
until successful.

	Melomel.connect();

Note that no import is needed as `Melomel` is in the default package.

To view debugging trace statements, you can also set `Melomel.debug` to `true`.


## API DEFINITIONS

### Introduction

All messages passed back and forth between the Flash virtual machine and the
external language are in XML. There are 5 different commands documented below.

All the commands work with object references and values. Values passed back
and forth are contained within a single XML element. Values can be represented
in two ways:

1. Primitives (String, int, float, boolean & null) are copied and sent in a
   message. These values have a `value` attribute equal to their literal
   representation and a `dataType` attribute equal signifying their type.

2. Objects are sent by reference. These XML element elements are represented
   with a `value` attribute set to the object's proxy identifier and the
   `dataType` attribute is set to "object".

Proxy identifiers are used by the external language to reference objects that
have already been accessed. These identifiers are also used in some commands
(Get Property, Set Property, & Invoke Method) to reference the object which
has the property or method being used.

### Create Object Command

This command creates an object given a fully qualified class name. The format
for this command is:

	<create class="flash.geom.Point"/>

This will create a `Point` object and return a reference to the object. The
Create Object command is limited in that it can only instantiate objects from
zero-argument constructors.

### Get Class Command

This command returns a reference to a class given a fully qualified class name.
The format for this command is:

	<get-class name="flash.display.Stage"/>

This command is useful when a reference is needed to a class in order to read
static methods or properties.

### Get Property Command

This command returns the value of a property on an object. Because classes are
objects in ActionScript, this works on classes as well. The format for this
command is:

	<get object="123" property="name"/>

This command can return a primitive value or a reference to an object.

### Set Property Command

This command sets a property on an object to a given value. The format for this
command is:

	<set object="123" property="name">
	  <arg value="bar" dataType="string"/>
	</set>

This command will return the value of the property that is being set so that it
can be chained in the external language.

### Invoke Method Command

This command invokes a method on an object and passes zero or more arguments.
The format for this command is:

	<invoke object="123" property="concatenate">
	  <args>
	    <arg value="foo" dataType="string"/>
	    <arg value="bar" dataType="string"/>
	  </args>
	</set>

This example method invocation would return this message:

	<return value="foobar" dataType="string"/>
	
### Invoke Function

This command invokes a package level function and passes zero or more arguments.
The format of this command is:
	
	<invoke-function name="flash.utils.getQualifiedClassName">
	  <args>
	    <arg value="foo" dataType="string"/>
	  </args>
	</set>

This example method invocation would return this message:

		<return value="String" dataType="string"/>



### Return Values

All return values are represented with a value element in the following format:

	<return value="foo" dataType="string"/>


## CONTRIBUTE

To get involved in Melomel, join us at our Lighthouse project listed above to
discuss features.

If you'd like to contribute to Melomel, start by forking the repository on GitHub:

http://github.com/benbjohnson/melomel

Then follow these steps to send your 

1. Clone down your fork
1. Create a topic branch to contain your change
1. Code like the wind
1. All code must have FlexUnit test coverage.
1. If you are adding new functionality, document it in the README
1. If necessary, rebase your commits into logical chunks, without errors
1. Push the branch up to GitHub
1. Send me a pull request for your branch