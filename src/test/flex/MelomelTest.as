package
{
import mx.core.UIComponent;

import flash.display.Stage;

import org.flexunit.Assert;
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
	public function tearDow():void
	{
		UIImpersonator.removeChild(component);
		component = null;
		stage = null;
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
}
}