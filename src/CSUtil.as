package  
{
	import adobe.utils.MMExecute;
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author Canab
	 */
	public class CSUtil
	{
		static public function initialize():void 
		{
			ExecuteScript(ScriptLib.initialize);
		}
		
		static public function get isDebug():Boolean
		{
			return Capabilities.playerType == 'StandAlone';
		}
		
		static public function ExecuteScript(script:*):String
		{
			if (isDebug)
			{
				trace(script);
				return null;
			}
			else
			{
				return MMExecute(script);
			}
		}		
	}

}