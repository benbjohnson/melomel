package melomel.commands
{
import melomel.commands.formatters.FormattersSuite;
import melomel.commands.parsers.ParsersSuite;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class CommandsSuite
{
	public var s0:FormattersSuite;
	public var s1:ParsersSuite;

	public var t0:GetClassCommandTest;
	public var t1:GetPropertyCommandTest;
	public var t2:SetPropertyCommandTest;
	public var t3:InvokeMethodCommandTest;
	public var t4:CreateObjectCommandTest;
	public var t5:InvokeFunctionCommandTest;
}
}