package common.utils
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	public class KeyboardManager
	{
		private var _pressedKeys:Dictionary = new Dictionary();
		
		public function KeyboardManager(stage:Stage)
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.DEACTIVATE, clearKeys);
		}
		
		public function clearKeys(e:Event = null):void
		{
			_pressedKeys = new Dictionary();
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			_pressedKeys[e.keyCode] = true;
		}

		private function onKeyUp(e:KeyboardEvent):void
		{
			delete _pressedKeys[e.keyCode];
		}
		
		public function isKeyPressed(keyCode:int):Boolean
		{
			return (keyCode in _pressedKeys);
		}
		
		public function get pressedKeys():Array
		{
			var result:Array = [];
			for (var keyCode:Object in _pressedKeys) 
			{
				result.push(keyCode);
			}
			
			return result;
		}
	}
}