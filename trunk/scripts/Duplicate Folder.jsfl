// ****************************************************************
// Duplicate Library Folder Command
// ****************************************************************
// ****************************************************************
// A Little Note:
// This extension was created to help in the task of duplicating
// skin symbols when using GhostWire Components.  But the
// command can be used in any situation where you wish to
// duplicate folders in the Library (a feature missing in the
// Flash IDE).  With this command, you can now duplicate all
// the symbols and nested folders within the currently
// selected folder in the  Library at once.
// ****************************************************************
// File Name: 	Duplicate Folder.jsfl
// Author: 	  	GhostWire Studios | Sunny Hong
// Version:   		1.00
// Last Modified:	5 July 2004
// ****************************************************************

var level = 0;
var items = fl.getDocumentDOM().library.getSelectedItems();
var j = items.length;
for (var i=0; i<j; i++)
{
	if (items[i].itemType == "folder")
	{
		var n = items[i].name.split("/").length;
		if (n < level || level==0)
		{
			level = n;
		}
	}
}
if (level!=0)
{
	for (var i=0; i<j; i++)
	{
		if (items[i].itemType == "folder" && items[i].name.split("/").length == level)
		{
			duplicateFolder(items[i].name);		
		}
	}
}
else
{
	alert("You need to select a folder!");
}

function duplicateFolder(folderName, destFolder)
{
	var newFolderName;
	if (destFolder!=undefined)
	{
		newFolderName = folderName.split("/");
		newFolderName = destFolder + "/" + newFolderName.pop();
	}
	else
	{
		newFolderName = folderName;
	}
	fl.getDocumentDOM().library.selectItem(folderName);
	var items = fl.getDocumentDOM().library.getSelectedItems();
	var folderLevel = folderName.split("/").length;
	do
	{
		newFolderName = newFolderName+" copy";
	}
	while (fl.getDocumentDOM().library.itemExists(newFolderName))
	fl.getDocumentDOM().library.newFolder(newFolderName);
	var j = items.length;
	for (var i=0; i<j; i++)
	{
		if ( items[i].itemType == "folder" && (items[i].name.split("/").length==(folderLevel+1)) )
		{
			duplicateFolder(items[i].name, newFolderName);
		}
		else
		{
			var folder = items[i].name.split("/");
			folder.pop();
			folder = folder.join("/");
			 if (folder == folderName)
			 {
				var itemName = items[i].name.split("/").pop();
				fl.getDocumentDOM().library.selectNone();
				fl.getDocumentDOM().library.duplicateItem(items[i].name);
				fl.getDocumentDOM().library.moveToFolder(newFolderName);
				fl.getDocumentDOM().library.getSelectedItems()[0].name = itemName;
			 }
		}
	}
}
