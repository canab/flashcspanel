package
{

	/**
	 * ...
	 * @author Canab
	 */
	public class ScriptLib
	{
		static public var initialize:XML =  <script><![CDATA[

			var removeSpaces = function(str)
			{
			  return str.replace(/\s+/g, '');
			}

			var getDocument = function()
			{
				return fl.getDocumentDOM();
			}
			
			var getLibrary = function()
			{ 
				return getDocument().library;
			}
			
			var getTimeline = function()
			{
				return getDocument().getTimeline();
			}
			
			function addNewText(bounds, text)
			{
				var doc = getDocument();
				var orig = doc.selection;
				doc.addNewText(bounds, text);
				doc.selectAll();
				var txt = doc.selection[0];
				doc.selectNone();
				if (orig)
					doc.selection = orig;
				return txt;
			}
			
			function addItemToDocument(position, namePath)
			{
				var orig = doc.selection;
				lib.addItemToDocument(position, namePath);
				doc.selectAll();
				var obj = doc.selection[0];
				doc.selectNone();
				if (orig)
					doc.selection = orig;
				return obj;
			}
			
			function trace(value)
			{
				fl.trace(value);
			}
			
			/////////////////////////////////////////////////////////////////////////////////////
			//
			// Library function
			//
			/////////////////////////////////////////////////////////////////////////////////////
			function libRefreshSelection()
			{
				var lib = getLibrary();
				var items = lib.getSelectedItems();
				lib.selectNone();
				for each (var item in items)
				{
					lib.selectItem(item.name, false);
				}
			}
			
			/////////////////////////////////////////////////////////////////////////////////////
			//
			// String functions
			//
			/////////////////////////////////////////////////////////////////////////////////////
			var NUMBERS = '0123456789';
			var LOWER_CHARS = 'abcdefghijklmnopqrstuvwxyz';
			var UPPER_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

			function testString(text, chars)
			{
				if (text == "")
					return true;
				
				for (var i = 0; i < text.length; i++)
				{
					if (chars.indexOf(text.charAt(i), 0) == -1)
						return false;
				}
				return true;
			}

			function isNumber(text)
			{
				return testString(text, NUMBERS);
			}
			function isLower(text)
			{
				return testString(text, LOWER_CHARS);
			}
			function isUpper(text)
			{
				return testString(text, UPPER_CHARS);
			}
			function isAlpha(text)
			{
				return testString(text, LOWER_CHARS + UPPER_CHARS);
			}
			function isAlphanum(text)
			{
				return testString(text, LOWER_CHARS + UPPER_CHARS + NUMBERS);
			}			
			
			
		]]></script>
	}
}