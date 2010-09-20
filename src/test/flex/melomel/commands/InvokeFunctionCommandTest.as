package melomel.commands
{
import org.flexunit.Assert;
import org.flexunit.async.Async;

public class InvokeFunctionCommandTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var command:InvokeFunctionCommand;
	private var object:Object;
	
	[Before]
	public function setUp():void
	{
		command = new InvokeFunctionCommand();
	}

	[After]
	public function tearDown():void
	{
		command = null;
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Execute
	//-----------------------------

	[Test]
	public function execute():void
	{
		command.functionName = "flash.utils.getQualifiedClassName";
		command.methodArgs = ["John"];
		Assert.assertEquals("String", command.execute());
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function executeWithoutObject():void
	{
		command.functionName = "";
		command.methodArgs = ["John"];
		command.execute();
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function executeWithoutMethodName():void
	{
		command.functionName = "flash.utils.getQualifiedClassName";
		command.methodArgs = null;
		command.execute();
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function executeWithoutMethodArgs():void
	{
		command.functionName = "testFunc";
		command.execute();
	}
}
}