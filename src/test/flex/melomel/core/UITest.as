package melomel.core
{
import melomel.core.uiClasses.Sandbox;

import org.flexunit.Assert;
import org.flexunit.async.Async;
import org.fluint.uiImpersonation.UIImpersonator;

import spark.components.Button;
import spark.components.ComboBox;
import spark.components.TextInput;
import mx.collections.ArrayList;
import mx.controls.ComboBox;
import mx.controls.DataGrid;
import mx.containers.Panel;
import mx.core.FlexGlobals;
import mx.events.FlexEvent;
import mx.managers.PopUpManager;

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

	[Test(timeout="1000")]
	public function shouldFindSingleComponentById():void
	{
		var components:Array = UI.findAll(Button, sandbox, {id:"button1"});
		Assert.assertEquals(1, components.length);
		Assert.assertEquals(sandbox.button1, components[0]);
	}

	[Test(timeout="1000")]
	public function shouldFindMultipleComponents():void
	{
		var components:Array = UI.findAll(Button, sandbox);
		Assert.assertEquals(2, components.length);
		Assert.assertEquals(sandbox.button1, components[0]);
		Assert.assertEquals(sandbox.button2, components[1]);
	}

	[Test(timeout="1000")]
	public function shouldFindMultipleComponentsAsString():void
	{
		var components:Array = UI.findAll("spark.components.Button", sandbox);
		Assert.assertEquals(2, components.length);
		Assert.assertEquals(sandbox.button1, components[0]);
		Assert.assertEquals(sandbox.button2, components[1]);
	}

	[Test(timeout="1000")]
	public function shouldFindMultipleClasses():void
	{
		var components:Array = UI.findAll([Button, TextInput], sandbox);
		Assert.assertEquals(5, components.length);
		Assert.assertEquals(sandbox.button1, components[0]);
		Assert.assertEquals(sandbox.textInput1, components[1]);
		Assert.assertEquals(sandbox.button2, components[2]);
		Assert.assertEquals(sandbox.barField, components[3]);
		Assert.assertEquals(sandbox.tab0.textInput, components[4]);
	}

	[Test(timeout="1000")]
	public function shouldFindMultipleClassesAsStrings():void
	{
		var components:Array = UI.findAll(["spark.components.Button", "spark.components.TextInput"], sandbox);
		Assert.assertEquals(5, components.length);
		Assert.assertEquals(sandbox.button1, components[0]);
		Assert.assertEquals(sandbox.textInput1, components[1]);
		Assert.assertEquals(sandbox.button2, components[2]);
		Assert.assertEquals(sandbox.barField, components[3]);
		Assert.assertEquals(sandbox.tab0.textInput, components[4]);
	}

	[Test(timeout="1000")]
	public function shouldFindMultipleClassesAsStrings2():void
	{
		var components:Array = UI.findAll(["spark.components.Button", "no.such.class"], sandbox);
		Assert.assertEquals(2, components.length);
		Assert.assertEquals(sandbox.button1, components[0]);
		Assert.assertEquals(sandbox.button2, components[1]);
	}

	[Test(timeout="1000")]
	public function shouldFindOnlyVisibleTextInputs():void
	{
		var components:Array = UI.findAll(TextInput, sandbox, {id:'textInput'});
		Assert.assertEquals(1, components.length);
		Assert.assertEquals(sandbox.tab0.textInput, components[0]);
	}

	[Test(timeout="1000")]
	public function shouldFindNoComponentsIfNoneMatch():void
	{
		var components:Array = UI.findAll(DataGrid, sandbox);
		Assert.assertEquals(0, components.length);
	}

	[Test(expects="melomel.errors.MelomelError")]
	public function shouldErrorWhenNoClassNameIsProvided():void
	{
		UI.findAll(null, sandbox);
	}

	[Test(timeout="1000")]
	public function shouldFindLabeledHaloComponent():void
	{
		var component:Object = UI.findLabeled("mx.controls.TextInput", "Foo Field", sandbox);
		Assert.assertEquals(sandbox.fooField, component);
	}

	[Test(timeout="1000")]
	public function shouldFindLabeledSparkComponent():void
	{
		var component:Object = UI.findLabeled("spark.components.TextInput", "Bar Field", sandbox);
		Assert.assertEquals(sandbox.barField, component);
	}

	[Test(timeout="1000")]
	public function shouldNotFindInvalidLabeledComponent():void
	{
		var component:Object = UI.findLabeled("mx.controls.TextInput", "Baz", sandbox);
		Assert.assertNull(component);
	}

	[Test(timeout="1000")]
	public function shouldFindLabeledLabel():void
	{
		var component:Object = UI.findLabeled("mx.controls.Label", "First Name", sandbox);
		Assert.assertEquals(sandbox.firstNameLabel, component);
	}



	//-----------------------------
	//  Find
	//-----------------------------

	[Test(timeout="1000")]
	public function findChildComponent():void
	{
		var component:DisplayObject = UI.find(Button, sandbox, {label:"Click Me"});
		Assert.assertEquals(sandbox.button1, component);
	}

	[Test(timeout="1000")]
	public function findWithNoRootSpecified():void
	{
		Melomel.initialize();

		var button:Button = new Button();
		button.id = "testButton";
		FlexGlobals.topLevelApplication.addChild(button);
		var component:DisplayObject = UI.find(Button, null, {id:"testButton"});
		FlexGlobals.topLevelApplication.removeChild(button);
		Assert.assertEquals(button, component);
	}

	[Test(timeout="1000")]
	public function findRootComponent():void
	{
		var component:DisplayObject = UI.find(Sandbox, sandbox);
		Assert.assertEquals(sandbox, component);
	}

	[Test(timeout="1000")]
	public function findWithClassName():void
	{
		var component:DisplayObject = UI.find("spark.components.Button", sandbox, {id:"button2"});
		Assert.assertEquals(sandbox.button2, component);
	}

	[Test(timeout="1000")]
	public function findWithMultipleProperties():void
	{
		var component:DisplayObject = UI.find(Button, sandbox, {id:"button2", label:"Click Me"});
		Assert.assertEquals(sandbox.button2, component);
	}

	[Test(timeout="1000")]
	public function shouldFindPopUp():void
	{
		var panel:Panel = new Panel();
		panel.title = "Foo";
		PopUpManager.addPopUp(panel, FlexGlobals.topLevelApplication as DisplayObject);
		var component:DisplayObject = UI.find(Panel, null, {title:"Foo"});
		PopUpManager.removePopUp(panel);
		Assert.assertEquals(panel, component);
	}


	//-----------------------------
	//  Mouse Interactions
	//-----------------------------

	[Ignore]
	[Test(async)]
	public function clickShouldOccurInMiddleOfComponent():void
	{
		Async.handleEvent(this, sandbox.button1, MouseEvent.CLICK, function(event:MouseEvent,...args):void{
			Assert.assertEquals(50, event.localX);
			Assert.assertEquals(10, event.localY);
		});
		UI.click(sandbox.button1);
	}

	[Test(async,expects="melomel.errors.MelomelError")]
	public function clickWhenDisabledThrowsError():void
	{
		sandbox.button1.enabled = false;
		UI.click(sandbox.button1);
	}

	[Test(async,expects="melomel.errors.MelomelError")]
	public function clickWhenMouseDisabledThrowsError():void
	{
		sandbox.button1.mouseEnabled = false;
		UI.click(sandbox.button1);
	}

	[Ignore]
	[Test(async)]
	public function doubleClick():void
	{
		Async.proceedOnEvent(this, sandbox.button1, MouseEvent.CLICK);
		Async.proceedOnEvent(this, sandbox.button1, MouseEvent.CLICK);
		Async.proceedOnEvent(this, sandbox.button1, MouseEvent.DOUBLE_CLICK);
		UI.doubleClick(sandbox.button1);
	}

	[Test(async,expects="melomel.errors.MelomelError")]
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
	
	
	//-----------------------------
	//  Data Control Interaction
	//-----------------------------

	[Test]
	public function shouldGenerateLabelsFromHaloComboBox():void
	{
		var combo:mx.controls.ComboBox = new mx.controls.ComboBox();
		combo.labelField = "label";
		var data:Array = [{label:"foo"}, {label:"bar"}];
		var labels:Array = UI.itemsToLabels(combo, data);
		Assert.assertEquals(2, labels.length);
		Assert.assertEquals("foo", labels[0]);
		Assert.assertEquals("bar", labels[1]);
	}

	[Test]
	public function shouldGenerateLabelsFromSparkComboBox():void
	{
		var combo:spark.components.ComboBox = new spark.components.ComboBox();
		combo.labelField = "label";
		var data:ArrayList = new ArrayList([{label:"foo"}, {label:"bar"}]);
		var labels:Array = UI.itemsToLabels(combo, data);
		Assert.assertEquals(2, labels.length);
		Assert.assertEquals("foo", labels[0]);
		Assert.assertEquals("bar", labels[1]);
	}
}
}
