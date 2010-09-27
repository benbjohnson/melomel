package melomel.core
{
import org.flexunit.Assert;
import org.flexunit.async.Async;

import flash.events.Event;

public class TypeTest
{
	//---------------------------------------------------------------------
	//
	//  Static methods
	//
	//---------------------------------------------------------------------

	[Test]
	public function shouldReturnTrueForDynamicObject():void
	{
		Assert.assertTrue(Type.isDynamic(new Object()));
	}

	[Test]
	public function shouldReturnFalseForNonDynamicObject():void
	{
		Assert.assertFalse(Type.isDynamic(new Event(Event.COMPLETE)));
	}
}
}
