package common.utils
{
	import common.comparing.IRequirement;
	import common.comparing.PropertyRequirement;
	
	/**
	* ...
	* @author Canab
	*/
	public class ArrayUtil
	{
		static public function findByProperty(source:Array, property:String, value:Object):Object
		{
			return getFirstRequired(source, new PropertyRequirement(property, value));
		}
		
		static public function getByProperty(source:Array, property:String, value:Object):Array
		{
			return getRequired(source, new PropertyRequirement(property, value));
		}
		
		static public function getRequired(source:Object, requirement:IRequirement):Array
		{
			var result:Array = [];
			for each (var item:Object in source)
			{
				if (requirement.accept(item))
					result.push(item);
			}
			return result;
		}
		
		static public function getFirstRequired(source:Object, requirement:IRequirement):Object
		{
			var result:Object = null;
			for each (var item:Object in source)
			{
				if (requirement.accept(item))
				{
					result = item;
					break;
				}
			}
			return result;
		}
		
		static public function hasRequired(source:Object, requirement:IRequirement):Object
		{
			return Boolean(getFirstRequired(source, requirement));
		}
		
		static public function removeItem(source:Array, item:Object):void
		{
			source.splice(source.indexOf(item), 1);
		}
		
		static public function getRandomItem(source: Array):*
		{
			return source[int(Math.random() * source.length)];
		}
		
		static public function getRandomItems(source:Array, count:int):Array
		{
			var result:Array = [];
			var selection:Array = [];
			
			for (var i:int = 0; i < count; i++)
			{
				var index:int = Math.random() * source.length;
				
				while(selection.indexOf(index) >= 0)
				{
					index++;
					if (index == source.length)
						index = 0;
				}
				
				result.push(source[index]);
				selection.push(index);
			}
			
			return result;
		}
		
		
	}
	
}