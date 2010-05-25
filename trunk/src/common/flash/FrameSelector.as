package common.flash
{
	import common.utils.GraphUtil;
	import common.utils.MathUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class FrameSelector
	{
		private var _content:Sprite;
		
		public function FrameSelector(content:Sprite)
		{
			_content = content;
			initialize();
			frameNum = 1;
		}
		
		private function initialize():void
		{
			prevButon.addEventListener(MouseEvent.CLICK, onPrevClick);
			nextButon.addEventListener(MouseEvent.CLICK, onNextClick);
		}
		
		private function onPrevClick(e:MouseEvent):void
		{
			frameNum--;
		}
		
		private function onNextClick(e:MouseEvent):void
		{
			frameNum++;
		}
		
		public function refresh():void
		{
			GraphUtil.setBtnEnabled(prevButon, frames.currentFrame > 1);
			GraphUtil.setBtnEnabled(nextButon, frames.currentFrame < frames.totalFrames);
		}
		
		public function get frameNum():int
		{
			return frames.currentFrame;
		}
		
		public function set frameNum(value:int):void
		{
			value = MathUtil.claimRange(value, 1, frames.totalFrames);
			frames.gotoAndStop(value);
			refresh();
		}
		
		public function get nextButon():SimpleButton
		{
			return _content['btnNext'];
		}
		
		public function get prevButon():SimpleButton
		{
			return _content['btnPrev'];
		}
		
		public function get frames():MovieClip
		{
			return _content['mcFrames'];
		}
		
		public function get content():Sprite { return _content; }
	}
	
}