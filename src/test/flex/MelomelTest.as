package
{
import mx.core.UIComponent;
import mx.managers.CursorManager;
import mx.managers.SystemManager;

import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.setTimeout;

import org.flexunit.Assert;
import org.flexunit.async.Async;
import org.fluint.uiImpersonation.UIImpersonator;

public class MelomelTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var component:UIComponent;
	private var stage:Stage;
	
	[Before]
	public function setUp():void
	{
		component = new UIComponent();
		UIImpersonator.addChild(component);
		stage = component.stage;
	}
	
	[After]
	public function tearDown():void
	{
		UIImpersonator.removeChild(component);
		component = null;
		stage = null;
		CursorManager.removeBusyCursor();
	}


	//---------------------------------------------------------------------
	//
	//  Static properties
	//
	//---------------------------------------------------------------------

	[Test]
	public function shouldNotBeBusyIfNoWaitCursorAndNotWaiting():void
	{
		Assert.assertFalse(Melomel.busy);
	}

	[Test]
	public function shouldBeBusyIfWaitCursorVisible():void
	{
		CursorManager.setBusyCursor();
		Assert.assertTrue(Melomel.busy);
	}

	[Test(async,timeout="500")]
	public function shouldBeBusyIfWaiting():void
	{
		var dispatcher:EventDispatcher = new EventDispatcher();
		Async.proceedOnEvent(this, dispatcher, Event.COMPLETE);

		Melomel.wait(1);
		Assert.assertTrue(Melomel.busy);
		
		// Give the test time so it doesn't affect other tests
		setTimeout(function():void{dispatcher.dispatchEvent(new Event(Event.COMPLETE))}, 250);
	}



	//---------------------------------------------------------------------
	//
	//  Static methods
	//
	//---------------------------------------------------------------------

	//---------------------------------
	//	Initialization
	//---------------------------------

	[Test]
	public function shouldFindStageOnInitialization():void
	{
		Melomel.initialize();
		Assert.assertNotNull(Melomel.stage);
		Assert.assertEquals(stage, Melomel.stage);
	}
	
	
	//---------------------------------
	//	Busy state
	//---------------------------------

	[Test]
	public function shouldNotHaveBusyCursor():void
	{
		Assert.assertFalse(Melomel.hasBusyCursor());
	}

	[Test]
	public function shouldHaveBusyCursor():void
	{
		CursorManager.setBusyCursor();
		Assert.assertTrue(Melomel.hasBusyCursor());
	}
}
}