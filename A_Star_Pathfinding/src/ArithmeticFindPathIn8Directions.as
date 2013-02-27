package
{
	import flash.geom.Point;

	public class ArithmeticFindPathIn8Directions
	{
		public var openedNodeList:Vector.<Node>;
		public var closedNodeList:Vector.<Node>;
		private var manager:NodeManager;
		private var end:Node;
		private var start:Node;
		public var lastPathLength:Number=0;

		public function ArithmeticFindPathIn8Directions(manager:NodeManager)
		{
			this.manager=manager;
		}

		public function findPath(startPoint:Point, endPoint:Point):Array
		{
			openedNodeList=new Vector.<Node>();
			closedNodeList=new Vector.<Node>();
			end=manager.getNode(endPoint.x, endPoint.y);
			start=manager.getNode(startPoint.x, startPoint.y);
			var cur:Node=null;
			openedNodeList.push(start);
			do
			{
				cur=openedNodeList.pop();
				removeNodeFromOpenedNodeList(cur);
				closedNodeList.push(cur);
				cur.closed=true;
				getNextNode(cur);
				openedNodeList.sort(Node.compare);
			} while (cur != end && openedNodeList.length > 0);

			if (openedNodeList.length == 0)
				return [];

			var rs:Array=[];
			lastPathLength=cur ? cur.f : NaN;
			while (cur)
			{
				rs.push(cur.index);
				cur=cur.parent;
			}
			return rs;
		}

		private function removeNodeFromOpenedNodeList(cur:Node):void
		{
			var index:int=openedNodeList.indexOf(cur);
			if (index != -1)
				openedNodeList.splice(index, 1);
		}



		protected function getNextNode(cur:Node):void
		{
			var tnd:Node=null;

			var t:Node=manager.getTopNode(cur.x, cur.y);

			addToOpenedNodeList(t, cur);

			var r:Node=manager.getRightNode(cur.x, cur.y);
			addToOpenedNodeList(r, cur);

			var b:Node=manager.getBottomNode(cur.x, cur.y);
			addToOpenedNodeList(b, cur);

			var l:Node=manager.getLeftNode(cur.x, cur.y);
			addToOpenedNodeList(l, cur);
			//////////////////////////////////////////

			if (t != null && t.accessable)
			{
				if (l != null && l.accessable)
				{
					tnd=manager.getTopLeftNode(cur.x, cur.y);
					addToOpenedNodeList(tnd, cur);
				}

				if (r != null && r.accessable)
				{
					tnd=manager.getTopRightNode(cur.x, cur.y);
					addToOpenedNodeList(tnd, cur);
				}
			}


			if (b != null && b.accessable)
			{
				if (r != null && r.accessable)
				{
					tnd=manager.getBottomRightNode(cur.x, cur.y);
					addToOpenedNodeList(tnd, cur);
				}


				if (l != null && l.accessable)
				{
					tnd=manager.getBottomLeftNode(cur.x, cur.y);
					addToOpenedNodeList(tnd, cur);
				}

			}

		}

		private function addToOpenedNodeList(t:Node, cur:Node):void
		{
			if (t && t.accessable && !t.closed)
			{
				if (t.opened)
				{
					if (t.g > t.getG(cur))
					{
						t.parent=cur;
						t.computeF(cur, end);
					}
				}
				else
				{
					openedNodeList.push(t);
					t.opened=true;
					t.parent=cur;
					t.computeF(cur, end);
				}
			}
		}
	}
}

class NodeInfo
{
	public var node:Node=null;
	public var f:Number=int.MAX_VALUE;
}
