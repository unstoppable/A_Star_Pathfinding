package com.raisedtech.astar.core
{
	import flash.geom.Point;

	/**
	 * 基于二叉堆的A*寻路<br/>
	 * 使用到了B+树以及完全二叉树的顺序存储 
	 * @author Liu lhw1987654@gmail.com
	 */
	public class ArithmeticFindPathIn8Directions
	{
		public var openedNodeList:IList;
		public var closedNodeList:Vector.<Node>;
		private var manager:NodeManager;
		private var end:Node;
		private var start:Node;
		public var lastPathLength:Number=0;

		public function ArithmeticFindPathIn8Directions(manager:NodeManager, list:IList)
		{
			this.manager=manager;
			openedNodeList=list;
		}

		public function findPath(startPoint:Point, endPoint:Point):Array
		{
			closedNodeList=new Vector.<Node>();
			openedNodeList.reset();
			trace("Using", openedNodeList);
			end=manager.getNode(endPoint.x, endPoint.y);
			start=manager.getNode(startPoint.x, startPoint.y);
			var cur:Node=null;
			openedNodeList.push(start);
			do
			{
				cur=openedNodeList.pop();
				//trace(openedNodeList);
				closedNodeList.push(cur);
				cur.closed=true;
				getNextNode(cur);
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
						openedNodeList.valueChanged(t);
					}
				}
				else
				{
					t.opened=true;
					t.parent=cur;
					t.computeF(cur, end);
					openedNodeList.push(t);
				}
			}
		}
	}
}
import com.raisedtech.astar.core.Node;

class NodeInfo
{
	public var node:Node=null;
	public var f:Number=int.MAX_VALUE;
}
