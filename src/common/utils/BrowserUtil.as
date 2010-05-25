package common.utils
{
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class BrowserUtil
	{
		static public function navigate(url:String, window:String = '_blank'):void
		{
			if (ExternalInterface.available)
			{
				try
				{
					var browser:String = ExternalInterface.call(
						'function getBrowser(){return navigator.userAgent}') as String;
					
					if (browser.indexOf("Firefox") != -1 || browser.indexOf("MSIE 7.0") != -1)
					{
						ExternalInterface.call('window.open("' + url + '","' + window + '")');
					}
					else
					{
					   navigateToURL(new URLRequest(url), window);
					}
				}
				catch (e:Error)
				{
				   navigateToURL(new URLRequest(url), window);
				}
			}
			else
			{
			   navigateToURL(new URLRequest(url), window);
			}
		}
	}
}