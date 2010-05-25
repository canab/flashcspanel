package  
{
	import common.utils.StringUtil;
	import flash.events.Event;
	import flash.system.Security;
	import mx.containers.Canvas;
	import mx.controls.TextInput;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class MainPanelBase extends Canvas
	{
		[Bindable] public var nameTemplateInput:TextInput;
		
		public function MainPanelBase() 
		{
			Security.allowDomain('*');
			CSUtil.initialize();
			super();
		}
		
		protected function onPublishClick():void 
		{
			var script:XML = <script><![CDATA[
				for (var i in fl.documents) {
					var doc = fl.documents[i]
					fl.trace(doc.name);
					doc.publish();
					doc.save();
				}
			]]></script>
			CSUtil.ExecuteScript(script);
		}
		
		protected function onCompactClick():void 
		{
			var script:XML = <script><![CDATA[
				trace('------------------------------------');
				trace('All: Save compact+close');
				trace('------------------------------------');
				for (var i=0; i<fl.documents.length; i++)
				{
					fl.trace(fl.documents[0].name);
					fl.documents[0].saveAndCompact();
				}
				trace('OK!');
			]]></script>
			CSUtil.ExecuteScript(script);
		}
		
		protected function newLayerAndStop():void 
		{
			var script:XML = <script><![CDATA[
				getTimeline().setSelectedLayers(0, true);
				getTimeline().addNewLayer();
				getTimeline().layers[0].name = 'as'

				getTimeline().insertBlankKeyframe(fl.getDocumentDOM().getTimeline().frameCount-1)
				getTimeline().layers[0].frames[fl.getDocumentDOM().getTimeline().frameCount-1].actionScript = 'stop();';
				getTimeline().setSelectedLayers(0, true);
			]]></script>
			CSUtil.ExecuteScript(script);
		}
		
		
		protected function onTestClick():void 
		{
			var script:String = 'addNewText({top:0, left:0, right:100,bottom:100}, "this is JSFL")';
			CSUtil.ExecuteScript(script);
		}
		
		protected function onSelectAllClick():void 
		{
			CSUtil.ExecuteScript("getLibrary().selectAll();");
		}
		
		protected function moveSelectionTo0():void 
		{
			var script:XML = <script><![CDATA[
				var doc = getDocument();
				var rect = doc.getSelectionRect();
				doc.moveSelectionBy( { x: -rect.left, y: -rect.top } );
			]]></script>
				
			CSUtil.ExecuteScript(script);
		}
		
		protected function onLinkageClick():void 
		{
			var script:XML = <script><![CDATA[
				
				var items = getLibrary().getSelectedItems();
				for each (var item in items)
				{
					if (item.itemType == "folder")
						continue;
						
					var className = "";
					for (var i = 0; i < item.name.length; i++)
					{
						var char = item.name.charAt(i);
						if (isAlphanum(char))
							className += char;
						else if (char == "/")
							className += ".";
					}
					
					var baseClass = '';
					if (item.itemType != 'movie clip'
						&& item.itemType != 'button'
						&& item.itemType != 'bitmap'
						&& item.itemType != 'font'
						&& item.itemType != 'sound'
					)
					{
						continue;
					}
					
					if (item.linkageImportForRS == true)
					{
						item.linkageImportForRS = false;
					}
					item.linkageExportForAS = true;
					item.linkageExportForRS = false;
					item.linkageExportInFirstFrame = true;
					item.linkageClassName = className;
					
					//trace(item.name);
					//trace(className);
				}
				
				libRefreshSelection();
			
			]]></script>
			
			CSUtil.ExecuteScript(script);
			
		}
		
		protected function onLinkageClearClick():void 
		{
			var script:XML = <script><![CDATA[
				
				var items = getLibrary().getSelectedItems();
				for each (var item in items)
				{
					if (item.itemType == "folder")
						continue;
						
					item.linkageClassName = "";
					item.linkageExportForAS = false;
					//trace(item.name);
					//trace(className);
				}
				
				libRefreshSelection();
				
			]]></script>
			
			CSUtil.ExecuteScript(script);
			
		}
		
		protected function onRenameClick():void 
		{
			var scriptTemplate:XML = <script><![CDATA[
				
				var template = "$(template)";
				
				var items = getLibrary().getSelectedItems();
				for each (var item in items)
				{
					if (item.itemType == "folder")
						continue;
						
					var path;
					var name;
					var pathIndex = item.name.lastIndexOf("/");
					if (pathIndex >= 0)
					{
						path = "";
						name = item.name;
					}
					else
					{
						path = item.name.substring(0, pathIndex + 1);
						name = item.name.substring(pathIndex + 1);
					}
					var newName = template.replace('*', name);
					item.name = newName;
					
					//trace('---------------')
					//trace(item.name)
					//trace(newName)
				}
				
				alert("" + items.length + " items renamed.")
			
			]]></script>
			
			var template:String = StringUtil.trim(nameTemplateInput.text);
			if (template == "" || template == "*")
				template = "-*";
			if (template.indexOf('*') == -1)
				template += '*';
				
			var script:String = String(scriptTemplate).replace('$(template)', template);
			CSUtil.ExecuteScript(script);
		}
		
	}

}