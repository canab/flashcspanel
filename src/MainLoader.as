package  
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class MainLoader extends Sprite
	{
		static public const MAIN_PATH:String = 'file:///d|/projects/FlashCSPanel/bin/FlashCSPanel.swf';
		
		private var _loader:Loader;
		
		public function MainLoader() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick);
			loadPanel();
		}
		
		private function onStageClick(e:MouseEvent):void 
		{
			if (e.ctrlKey && e.shiftKey)
				reloadPanel();
		}
		
		private function reloadPanel():void
		{
			if (_loader)
				removeChild(_loader);
			
			loadPanel();
		}
		
		private function onReload(e:Event):void 
		{
			loadPanel();
		}
		
		private function loadPanel():void
		{
			_loader = new Loader();
			_loader.load(new URLRequest(MAIN_PATH));
			addChild(_loader);
		}
		
		
	}

}