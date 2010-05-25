package common.utils
{
	import common.commands.CallFuntionCommand;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class TimerUtil
	{
		public static function callAfter(func:Function, interval:uint = 100, thisObject:Object = null, args:Array = null):void
		{
			new CallFuntionCommand(func, interval, thisObject, args).execute();
		}
	}
	
}