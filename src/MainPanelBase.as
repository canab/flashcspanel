package  
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
		
		protected function layerSwapSymbol():void 
		{
			var script:XML = <script><![CDATA[
			
				var doc = fl.getDocumentDOM();
				var timeline = doc.getTimeline();
				var layer = timeline.layers[timeline.currentLayer];
				var frames = layer.frames;
				
				var selectedItems = doc.library.getSelectedItems();
				if (selectedItems.length != 1)
				{
					alert("One item should be selected in library")
				}
				
				var item = selectedItems[0];
				if (item.itemType != "component"
					&& item.itemType != "movie clip"
					&& item.itemType != "graphic"
					&& item.itemType != "button"
					&& item.itemType != "bitmap"
					&& item.itemType != "compiled clip"
					&& item.itemType != "video")
				{
					alert("Incorrect item type is selected in library");
				}
				
				fl.trace("replace to: " + item.name);
				
				for (var i = 0; i < frames.length; i++)
				{ 
					var frame = frames[i];
					if (frame.startFrame == i) { 
						timeline.setSelectedFrames(i, i);
						doc.swapElement(item.name);
					} 
				}
			
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
					
					var destName = destFolder + "/" + item.name.split("/").pop();
					
					fl.trace(item.name + " > " + destName);
					
					var linkageExportForRS = false;
					var linkageURL = "";
					
					if (lib.itemExists(destName))
					{
						lib.selectItem(destName);
						var destItem = lib.getSelectedItems()[0];
						
						linkageExportForRS = destItem.linkageExportForRS;
						linkageURL = destItem.linkageURL;
						lib.deleteItem(destName);
					}
					
					item.convertToCompiledClip();
					
					var newName = item.name + " SWF"
					lib.selectItem(newName);
					var newItem = lib.getSelectedItems()[0];
					
					if (newItem.name == newName)
					{
						//newItem.linkageExportForAS = true;					
						//newItem.linkageClassName = newItem.linkageClassName;
						newItem.linkageExportForRS = item.linkageExportForRS;					
						newItem.linkageURL = item.linkageURL;					
						
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
			CSUtil.ExecuteScript(script);
		}
		
		protected function applyLibName(counter:String):void 
		{
			var index:int = counter.length > 0 ? int(counter) : -1;
			
			var script:XML = <script><![CDATA[
			
				trace("-- applyLibName: --");
				
				var doc = fl.getDocumentDOM();
				var selection = doc.selection;
				var lib = doc.library;
				
				selection.sort(function(a, b) { return a.x - b.x});
				var index = #index;
				
				for (var i = 0; i < selection.length; i++)
				{
					var item = selection[i];
					var libraryItem = item.libraryItem;
					
					if (libraryItem != null
						&&	(
								libraryItem.itemType == "component"
								|| libraryItem.itemType == "movie clip"
								|| libraryItem.itemType == "graphic"
								|| libraryItem.itemType == "button"
								|| libraryItem.itemType == "bitmap"
								|| libraryItem.itemType == "compiled clip"
								|| libraryItem.itemType == "video"
							)
						)
					{
						var suffix = (index >= 0) ? index++ : "";
							
						var itemName = libraryItem.name.split("/").pop();
						item.name = itemName + suffix;
						trace(item.name);
					}
				}
				
				trace("done");
			]]></script>
			CSUtil.ExecuteScript(String(script).replace("#index", index));
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

				var getClassName = function(path)
				{
					var parts = path.split("/");
					var packages = [];
					for (var i = 0; i < parts.length; i++)
					{
						var part = removeSpaces(parts[i]);
						var prefix = part.substring(0, 1);
						if (prefix != "-")
						packages.push(part);
					}
					return packages.join(".");
				}

				for each (var item in items)
				{
					if (item.itemType == "folder")
						continue;
						
					var className = getClassName(item.name);

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
					trace(className);
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
						
					if (item.linkageExportForAS == true)
					{
						item.linkageClassName = "";
						item.linkageExportForAS = false;
					}
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