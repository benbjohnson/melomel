package melomel.core
{
import melomel.core.uiClasses.Sandbox;

import org.flexunit.Assert;
import org.flexunit.async.Async;
import org.fluint.uiImpersonation.UIImpersonator;

import spark.components.Button;
import spark.components.TextInput;
import mx.controls.DataGrid;
import mx.core.FlexGlobals;
import mx.events.FlexEvent;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

public class UITest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var sandbox:Sandbox;
	
	[Before(async)]
	public function setUp():void
	{
		sandbox = new Sandbox();
		Async.proceedOnEvent(this, sandbox, FlexEvent.CREATION_COMPLETE, 500);
		UIImpersonator.addChild(sandbox);
	}
	
	[After]
	public function tearDown():void
	{
		UIImpersonator.removeChild(sandbox);
		sandbox = null;
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Static methods
	//
	//---------------------------------------------------------------------

	//-----------------------------
	//  Find
	//-----------------------------

	[Test]
	public function shouldFindSingleComponentById():void
	{
		var components:Array = UI.findAll(Button, sandbox, {id:"button1"});
		Assert.assertEquals(1, components.length);
		Assert.assertEquals(sandbox.button1, components[0]);
	}

	[Test]
	public function shouldFindMultipleComponents():void
	{
		var components:Array = UI.findAll(Button, sandbox);
		Assert.assertEquals(2, components.length);
		Assert.assertEquals(sandbox.button1, components[0]);
		Assert.assertEquals(sandbox.button2, components[1]);
	}

	[Test]
	public function shouldFindOnlyVisibleTextInputs():void
	{
		var components:Array = UI.findAll(TextInput, sandbox, {id:'textInput'});
		Assert.assertEquals(1, components.length);
		Assert.assertEquals(sandbox.tab0.textInput, components[0]);
	}

	[Test]
	public function shouldFindNoComponentsIfNoneMatch():void
	{
		var components:Array = UI.findAll(DataGrid, sandbox);
		Assert.assertEquals(0, components.length);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldErrorWhenNoClassNameIsProvided():void
	{
		UI.findAll(null, sandbox);
	}



	//-----------------------------
	//  Find
	//-----------------------------

	[Test]
	public function findChildComponent():void
	{
		var component:DisplayObject = UI.find(Button, sandbox, {label:"Click Me"});
		Assert.assertEquals(sandbox.button1, component);
	}

	[Test]
	public function findWithNoRootSpecified():void
	{
		var button:Button = new Button();
		button.id = "testButton";
		FlexGlobals.topLevelApplication.addChild(button);
		var component:DisplayObject = UI.find(Button, null, {id:"testButton"});
		FlexGlobals.topLevelApplication.removeChild(button);
		Assert.assertEquals(button, component);
	}

	[Test]
	public function findRootComponent():void
	{
		var component:DisplayObject = UI.find(Sandbox, sandbox);
		Assert.assertEquals(sandbox, component);
	}

	[Test]
	public function findWithClassName():void
	{
		var component:DisplayObject = UI.find("spark.components.Button", sandbox, {id:"button2"});
		Assert.assertEquals(sandbox.button2, component);
	}

	[Test]
	public function findWithMultipleProperties():void
	{
		var component:DisplayObject = UI.find(Button, sandbox, {id:"button2", label:"Click Me"});
		Assert.assertEquals(sandbox.button2, component);
	}


	//-----------------------------
	//  Mouse Interactions
	//-----------------------------

	[Test(async)]
	public function clickShouldOccurInMiddleOfComponent():void
	{
		Async.handleEvent(this, sandbox.button1, MouseEvent.CLICK, function(event:MouseEvent,...args):void{
			Assert.assertEquals(50, event.localX);
			Assert.assertEquals(10, event.localY);
		});
		UI.click(sandbox.button1);
	}

	[Test(async,expects="flash.errors.IllegalOperationError")]
	public function clickWhenDisabledThrowsError():void
	{
		sandbox.button1.enabled = false;
		UI.click(sandbox.button1);
	}

	[Test(async,expects="flash.errors.IllegalOperationError")]
	public function clickWhenMouseDisabledThrowsError():void
	{
		sandbox.button1.mouseEnabled = false;
		UI.click(sandbox.button1);
	}

	[Test(async)]
	public function doubleClick():void
	{
		Async.proceedOnEvent(this, sandbox.button1, MouseEvent.CLICK);
		Async.proceedOnEvent(this, sandbox.button1, MouseEvent.CLICK);
		Async.proceedOnEvent(this, sandbox.button1, MouseEvent.DOUBLE_CLICK);
		UI.doubleClick(sandbox.button1);
	}

	[Test(async,expects="flash.errors.IllegalOperationError")]
	public function clickWhenDoubleClickDisabledThrowsError():void
	{
		sandbox.button1.doubleClickEnabled = false;
		UI.doubleClick(sandbox.button1);
	}


	//-----------------------------
	//  Keyboard Interactions
	//-----------------------------

	[Test(async)]
	public function keyDownShouldFireKeyDownEvent():void
	{
		Async.proceedOnEvent(this, sandbox.textInput1, KeyboardEvent.KEY_UP);
		UI.keyUp(sandbox.textInput1, "A");
	}

	[Test(async)]
	public function keyDownWithLowerCaseLetter():void
	{
		Async.handleEvent(this, sandbox.textInput1, KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent,...args):void{
			Assert.assertEquals(97, event.charCode);
			Assert.assertEquals(65, event.keyCode);
		});
		UI.keyDown(sandbox.textInput1, "a");
	}
	
	[Test(async)]
	public function keyDownWithUpperCaseLetter():void
	{
		Async.handleEvent(this, sandbox.textInput1, KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent,...args):void{
			Assert.assertEquals(65, event.charCode);
			Assert.assertEquals(65, event.keyCode);
		});
		UI.keyDown(sandbox.textInput1, "A");
	}
	
	[Test(async)]
	public function keyDownWithKeyCodeValue():void
	{
		Async.handleEvent(this, sandbox.textInput1, KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent,...args):void{
			Assert.assertEquals(65, event.charCode);
			Assert.assertEquals(65, event.keyCode);
		});
		UI.keyDown(sandbox.textInput1, Keyboard.A);
	}

	[Test(async)]
	public function keyDownWithControlCharacterShouldNotHaveACharCode():void
	{
		Async.handleEvent(this, sandbox.textInput1, KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent,...args):void{
			Assert.assertEquals(0, event.charCode);
			Assert.assertEquals(13, event.keyCode);
		});
		UI.keyDown(sandbox.textInput1, Keyboard.ENTER);
	}
	
	[Test(async)]
	public function keyUpShouldFireKeyUpEvent():void
	{
		Async.proceedOnEvent(this, sandbox.textInput1, KeyboardEvent.KEY_UP);
		UI.keyUp(sandbox.textInput1, "A");
	}
	
	[Test(async)]
	public function keyPressShouldFireKeyUpAndKeyDownEvent():void
	{
		Async.proceedOnEvent(this, sandbox.textInput1, KeyboardEvent.KEY_DOWN);
		Async.proceedOnEvent(this, sandbox.textInput1, KeyboardEvent.KEY_UP);
		UI.keyPress(sandbox.textInput1, "A");
	}
	
}
}
