package
{
	import flash.display.Sprite;

	public class BinaryHeaps_Test extends Sprite
	{
		private var bh:BinaryHeaps;

		public function BinaryHeaps_Test()
		{
			super();

			var arr:Array=[152,144,240,242,158,226,152,254,268,158,166,146,206,220,144,150,152,178,248,302,166,316,192,206,172,206,150];
			bh=new BinaryHeaps(20);

			
			var n:Node;
			for (var i:int=0; i < arr.length; i++)
			{
				n=new Node(0, 0, 0);
				n.f=arr[i];
				bh.push(n);
			}
			trace(bh);
			
			var tnew:Node = bh.vector[8];
			tnew.f=0;
			
			bh.valueChanged(tnew);
			trace(bh);
			
			do
			{
				n=bh.pop();
				if (n)
					trace(n.f);
			} while (n);
		}
	}
}
