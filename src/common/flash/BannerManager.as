package common.flash 
{
	import Box2D.Dynamics.b2DestructionListener;
	import common.comparing.IRequirement;
	import common.comparing.NameRequirement;
	import common.comparing.TypeRequirement;
	import common.utils.ArrayUtil;
	import common.utils.BrowserUtil;
	import common.utils.GraphUtil;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Canab
	 */
	public class BannerManager
	{
		private var _requirements:Dictionary = new Dictionary();
		
		public function BannerManager() 
		{
		}
		
		public function registerClass(classRef:Class, url:String):void 
		{
			var requirement:IRequirement = new TypeRequirement(classRef);
			_requirements[requirement] = url;
		}
		
		public function registerName(name:String, url:String):void 
		{
			var requirement:IRequirement = new NameRequirement(name);
			_requirements[requirement] = url;
		}
		
		public function scanContent(content:Sprite):void 
		{
			var children:Array = GraphUtil.getAllChildren(content,
				new TypeRequirement(InteractiveObject));
				
			for each (var child:InteractiveObject in children) 
			{
				for (var key:Object in _requirements)
				{
					if (IRequirement(key).accept(child))
						applyUrl(child, _requirements[key]);
				}
			}
		}
		
		private function applyUrl(target:InteractiveObject, url:String):void
		{
			if (target is DisplayObjectContainer)
			{
				DisplayObjectContainer(target).mouseChildren = false;
				
				if (target is Sprite)
				{
					Sprite(target).buttonMode = true;
					GraphUtil.addBoundsRect(Sprite(target));
				}
			}
				
			target.addEventListener(MouseEvent.CLICK, getClickHandler(url));
		}
		
		private function getClickHandler(url:String):Function
		{
			return function(e:MouseEvent):void {
				BrowserUtil.navigate(url);
			}
		}
	}

}