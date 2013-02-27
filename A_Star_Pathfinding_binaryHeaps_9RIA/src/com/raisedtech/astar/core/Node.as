package com.raisedtech.astar.core
{

	/**
	 * 节点核心类
	 * @author  Liu lhw1987654@gmail.com
	 * 
	 */
	public class Node extends Object
	{
		public static const IDEAL:uint=0;
		public static const OPENED:uint=1;
		public static const CLOSED:uint=3;

		public static const G:int=10;
		public static const VG:int=14;

		/**
		 * coefficient of friction, 摩擦系数<br/>
		 * 0 means not accessable.
		 */
		public var cof:Number=0;
		public var index:uint=0;
		public var x:uint=0;
		public var y:uint=0;
		public var accessable:Boolean=false;
		////////////////////////////////////
		public var parent:Node;
		public var f:Number=0;
		public var g:Number=0;
		public var h:Number=0;
		////////////////////////////////////
		protected var status:int=0;

		/**
		 * 
		 * @param index 节点ID
		 * @param x 节点坐标X轴
		 * @param y 节点坐标Y轴
		 * @param cof 节点的摩擦系数，这个东东很重要， 比如马路的摩擦系数为0.1， 草地的摩擦系数为0.5。
		 * 
		 */
		public function Node(index:uint, x:uint, y:uint, cof:Number=1)
		{
			this.index=index;
			this.x=x;
			this.y=y;
			this.cof=cof;
			accessable=cof > 0;
		}

		public function get angle():uint
		{
			if (!parent)
				return 360;

			var x:int=this.x - parent.x;
			var y:int=this.y - parent.y;
			var angle:int=0;
			if (x == -1)
			{
				if (y == -1)
				{
					angle=45;
				}
				else if (y == 0)
				{
					angle=0
				}
				else if (y == 1)
				{
					angle=-45
				}
			}
			else if (x == 0)
			{
				if (y == -1)
				{
					angle=90;
				}
				else if (y == 1)
				{
					angle=-90
				}
			}
			else if (x == 1)
			{
				if (y == -1)
				{
					angle=135;
				}
				else if (y == 0)
				{
					angle=180
				}
				else if (y == 1)
				{
					angle=-135
				}
			}

			return uint((angle + 360) % 360);
		}

		public function get opened():Boolean
		{
			return status == 1;
		}

		public function set opened(value:Boolean):void
		{
			status=value ? 1 : 0;
		}

		public function get closed():Boolean
		{
			return status == -1;
		}

		public function set closed(value:Boolean):void
		{
			status=value ? -1 : 0;
		}

		public function reset():void
		{
			status=0;
			parent=null;
			f=0;
			g=0;
			h=0;
		}


		/**
		 *从网格上那个方格移动到终点B的预估移动耗费。
		 * 这经常被称为启发式的，可能会让你有点迷惑。
		 * 这样叫的原因是因为它只是个猜测。
		 * 我们没办法事先知道路径的长度，因为路上可能存在各种障碍(墙，水，等等)。
		 * 虽然本文只提供了一种计算H的方法，但是你可以在网上找到很多其他的方法。
		 * @return
		 *
		 */
		public function getH(end:Node):int
		{
			return (Math.abs(x - end.x) + Math.abs(y - end.y)) * G;
		}

		/**
		 * G表示沿路径从起点到当前点的移动耗费。在这个例子里，我们令水平或者垂直移动的耗费为10，
		 * 对角线方向耗费为14。我们取这些值是因为沿对角线的距离是沿水平或垂直移动耗费的的根号2，
		 * 或者约1.414倍。为了简化，我们用10和14近似。
		 * @param nodeA
		 * @param nodeB
		 * @return
		 *
		 */
		public function getG(parent:Node):int
		{
			var x:int=this.x - parent.x;
			var y:int=this.y - parent.y;
			if (x != 0 && y != 0)
			{
				//trace("getG", x, y, x != 0 && y != 0);
				return VG + parent.g;
			}
			return G + parent.g;
		}

		/**
		 *　F是评分， F的值是G和H的和。
		 * @param nodeA
		 * @param nodeB
		 * @return
		 *
		 */
		public function computeF(parent:Node, end:Node):int
		{
			h=getH(end);
			g=getG(parent);
			f=h + g;
			return f;
		}

		public function toString():String
		{
			return "Node(x,y,f)=(" + x + "," + y + "," + f + ")";
		}

		public static function compare(a:Node, b:Node):int
		{
			if (a.f < b.f)
				return 1;
			if (a.f > b.f)
				return -1;
			return 0;
		}
	}
}
