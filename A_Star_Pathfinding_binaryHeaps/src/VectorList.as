package
{

	public class VectorList implements IList
	{
		protected var arr:Vector.<Node>;

		public function VectorList()
		{
			arr=new Vector.<Node>();
		}

		public function push(node:Node):void
		{
			arr.push(node);
		}

		public function pop():Node
		{
			arr.sort(Node.compare);
			return arr.pop();
		}

		public function get length():uint
		{
			return arr.length;
		}

		public function get vector():Vector.<Node>
		{
			return arr;
		}

		public function reset():void
		{
			arr.splice(0, arr.length);
		}
		
		public function toString():String
		{
			var s:String="[VectorList] ";
			for each (var j:Node in arr) 
			{
				s+=arr[j].f + ",";
			}
			return s;
		}
		
		public function valueChanged(node:Node):void{
			// useless for this List, we leave this function empty here
		}
	}
}
