package melomel
{
import melomel.core.CoreSuite;
import melomel.commands.CommandsSuite;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class MelomelSuite
{
	public var s0:CoreSuite;
	public var s1:CommandsSuite;

	public var t0:MelomelTest;
}
}