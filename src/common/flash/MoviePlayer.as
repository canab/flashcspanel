package common.flash 
{
	import common.commands.IAsincCommand;
	import common.commands.ICancelableCommand;
	import common.events.EventSender;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author Canab
	 */
	public class MoviePlayer implements ICancelableCommand
	{
		public var clip:MovieClip;
		public var toFrame:int;
		public var fromFrame:int;
		
		private var _completeEvent:EventSender = new EventSender(this);
		
		public function MoviePlayer(clip:MovieClip = null, fromFrame:int = 1, toFrame:int = 0) 
		{
			this.clip = clip;
			this.fromFrame = fromFrame;
			this.toFrame = (toFrame > 0)
				? toFrame
				: clip.totalFrames;
		}
		
		public function play(fromFrame:int = 1, toFrame:int = 0):void 
		{
			this.fromFrame = fromFrame;
			this.toFrame = (toFrame > 0)
				? toFrame
				: clip.totalFrames;
			
			execute();
		}
		
		public function playTo(toFrame:int):void 
		{
			play(clip.currentFrame, toFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (clip.currentFrame == toFrame)
			{
				clip.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_completeEvent.sendEvent();
			}
			else if (clip.currentFrame < toFrame)
			{
				clip.nextFrame();
			}
			else
			{
				clip.prevFrame();
			}
		}
		
		/* INTERFACE common.commands.IAsincCommand */
		
		public function get completeEvent():EventSender
		{
			return _completeEvent;
		}
		
		public function execute():void
		{
			clip.gotoAndStop(fromFrame);
			clip.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/* INTERFACE common.commands.ICancelableCommand */
		
		public function cancel():void
		{
			clip.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
	}

}