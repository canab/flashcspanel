package common.events
{
	import common.events.EventSender;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class EventManager
	{
		private var _list:Array = [];
		
		public function EventManager()
		{
		}
		
		public function registerEvent(event:EventSender, handler:Function):void
		{
			event.addListener(handler);
			_list.push(new BindInfo(event, handler));
		}
		
		public function unregisterEvent(event:EventSender, handler:Function):void
		{
			event.removeListener(handler);
			
			for (var i:int = 0; i < _list.length; i++)
			{
				var info:BindInfo = _list[i];
				if (info.event == event && info.handler == handler)
				{
					_list.splice(i, 1);
					break;
				}
			}
		}
		
		public function clearEvents():void
		{
			for each (var info:BindInfo in _list)
			{
				info.event.removeListener(info.handler);
			}
			_list = [];
		}
		
		
		
	}
	
}

import common.events.EventSender;

internal class BindInfo
{
	public var event:EventSender;
	public var handler:Function;
	
	public function BindInfo(event:EventSender, handler:Function):void
	{
		this.event = event;
		this.handler = handler;
	}
}