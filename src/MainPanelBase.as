﻿package  
{
	import common.utils.StringUtil;
	import flash.events.Event;
	import flash.system.Security;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import mx.containers.Canvas;
	import mx.controls.TextInput;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class MainPanelBase extends Canvas
	{
		[Bindable] public var nameTemplateInput:TextInput;
		
		[Embed(source = '../scripts/Duplicate Folder.jsfl', mimeType = 'application/octet-stream')]
		static private const DUPLICATTE_FOLDER_SCRIPT:Class;
		
		public function MainPanelBase() 
		{
			Security.allowDomain('*');
			CSUtil.initialize();
			super();
		}
		
		protected function TEMPLATE():void 
		{
			var script:XML = <script><![CDATA[
			]]></script>
			CSUtil.ExecuteScript(script);
		}
		
		protected function onCompileClick(destFolder:String):void 
		{
			var template:XML = <script><![CDATA[
			
				fl.trace("=========== Convert to compiled clip =============");
				
				var doc = fl.getDocumentDOM();
				var lib = doc.library;
				var selection = lib.getSelectedItems();
				var destFolder = ":destFolder";
				
				if (selection.length == 0)
					alert("Please select at least one item in the library.");
					
				if (!lib.itemExists(destFolder))
					lib.addNewItem("folder", destFolder);
					
				for (var i = 0; i < selection.length; i++)
				{
					var item = selection[i];
					
					if (item.itemType != "component" && item.itemType != "movie clip")
						continue;
					
					var destName = destFolder + "/" + item.name.split("/").pop() + " SWF";
					
					fl.trace(item.name + " > " + destName);
					
					if (lib.itemExists(destName))
						lib.deleteItem(destName);
					
					item.convertToCompiledClip();
					
					var newName = item.name + " SWF"
					lib.selectItem(newName);
					var newItem = lib.getSelectedItems()[0];
					
					if (newItem.name == newName)
					{
						//newItem.linkageClassName = "";
						//newItem.linkageExportForAS = false;					
						lib.moveToFolder(destFolder, newItem.name, true);
						newItem.name = item.name.split("/").pop();
					}
					else
					{
						trace("FAILED!")
					}
				}
				
			]]></script>
			
			var script:String = String(template)
				.replace(":destFolder", destFolder);
			
			CSUtil.ExecuteScript(script);
		}
		
		protected function onRenameFRClick(find:String, replace:String):void 
		{
			var template:XML = <script><![CDATA[
			
				fl.trace("=========== Rename selection =============");
				
				var doc = fl.getDocumentDOM();
				var selection = doc.library.getSelectedItems();
				
				if (selection.length == 0)
				{
					alert("Please select at least one item in the library.");
				}
				else
				{
					for (var i = 0; i < selection.length; i++)
					{
						var item = selection[i];
						
						if (item.itemType == "folder")
							continue;
						
						var currentName = item.name.split("/").pop();
						var newName = currentName.replace(":find", ":replace");
						item.name = newName;
						fl.trace("renaming " + currentName + " to: "+newName);
					}
				}				
				
			]]></script>
			
			var script:String = String(template)
				.replace(":find", find)
				.replace(":replace", replace);
				
			CSUtil.ExecuteScript(script);
		}
		
		protected function onDuplicateFolderClick():void 
		{
			runEmbedScript(DUPLICATTE_FOLDER_SCRIPT);
		}
		
		private function runEmbedScript(classRef:Class):void 
		{
			var script:String = String(new classRef());
			var xml:XML = <script/>;
			xml.appendChild(new XMLNode(XMLNodeType.CDATA_NODE, script));
			CSUtil.ExecuteScript(xml);
		}
		
		protected function findInLibrary():void 
		{
			var script:XML = <script><![CDATA[
			
				var currDom = fl.getDocumentDOM();
				var selItem = currDom.selection[0];
				var currLib = currDom.library;
				
				if (!selItem)
				{
					fl.trace('Error: Nothing selected.');
				}
				else if (!selItem.libraryItem)
				{
					fl.trace('Error: Not a valid symbol.');
				}
				else
				{
					
				}
				
				var libItem = selItem.libraryItem;
				var tmp = libItem.name.split('/');
				tmp.pop();
				
				var n = '';
				for (var i=0;i<tmp.length;i++) {
					n += tmp[i];
					currLib.expandFolder(true,false,n);
					n += '/';
				}
				currLib.selectItem(libItem.name);
				/*var openBoundClassUri = fl.configURI+'/Commands/OpenBoundClasses.jsfl';
				if (libItem.linkageClassName) {
					if (fl.fileExists(openBoundClassUri)) {
						fl.runScript(openBoundClassUri, 'openBoundClasses');
					}
				}*/			
			
			]]></script>
			CSUtil.ExecuteScript(script);
		}
		
		protected function onPublishClick():void 
		{
			var script:XML = <script><![CDATA[
			
				fl.trace("=========== Bublish =============");
			
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
			
				fl.trace("=========== Compact =============");
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
		
		protected function snapToPixels():void 
		{
			var script:XML = <script><![CDATA[
			
				var doc = getDocument();
				var elements = doc.selection;
				for (var i = 0; i < elements.length; i++) 
				{
					var element = elements[i];
					element.x = Math.round(element.x);
					element.y = Math.round(element.y);
				}
				
			]]></script>
				
			CSUtil.ExecuteScript(script);
		}
		
		protected function onLinkageClick():void 
		{
			var script:XML = <script><![CDATA[
				
				fl.trace("=========== Linkage =============");
				
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
						&& item.itemType != 'component'
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
				
				fl.trace("=========== Clear Linkage =============");
				
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
				
				fl.trace("=========== Rename =============");
				
				var template = "$(template)";
				
				var items = getLibrary().getSelectedItems();
				for each (var item in items)
				{
					if (item.itemType == "folder")
						continue;
						
					var name = item.name.split("/").pop();
					var newName = template.replace('*', name);
					item.name = newName;
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