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
		command.functionArgs = ["John"];
		Assert.assertEquals("String", command.execute());
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function executeWithoutObject():void
	{
		command.functionName = "";
		command.functionArgs = ["John"];
		command.execute();
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function executeWithoutFunctionName():void
	{
		command.functionName = "flash.utils.getQualifiedClassName";
		command.functionArgs = null;
		command.execute();
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function executeWithoutFunctionArgs():void
	{
		command.functionName = "testFunc";
		command.execute();
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function shouldThrowErrorForMissingMethodIfThrowable():void
	{
		command.functionName = "no.such.function";
		command.functionArgs = ["John"];
		command.throwable = true;
		command.execute();
	}

	[Test]
	public function shouldReturnNullForMissingMethodIfNotThrowable():void
	{
		command.functionName = "no.such.function";
		command.functionArgs = ["John"];
		command.throwable = false;
		Assert.assertNull(command.execute());
	}
}
}