package
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	public class NodeManager extends Object
	{
		public var nodeList:Vector.<Node>=new Vector.<Node>();
		public var mapWidth:int=0;
		public var mapHeight:int=0;

		public function NodeManager(mapWidth:int, mapHeight:int)
		{
			this.mapWidth=mapWidth;
			this.mapHeight=mapHeight;
		}


		public function reset():void
		{
			for each (var i:Node in nodeList)
			{
				i.reset();
			}

		}

		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		public function getNode(x:uint, y:uint):Node
		{
			return nodeList[y * mapWidth + x];
		}

		public function getTopLeftNode(x:uint, y:uint):Node
		{
			if (y == 0)
				return null;
			if (x == 0)
				return null;
			var index:uint=(y - 1) * mapWidth + x - 1;
			return nodeList[index];
		}


		public function getTopRightNode(x:uint, y:uint):Node
		{
			if (y == 0)
				return null;

			if (mapWidth == x + 1)
				return null;
			var index:uint=(y - 1) * mapWidth + x + 1;
			return nodeList[index];
		}

		public function getTopNode(x:uint, y:uint):Node
		{
			if (y == 0)
				return null;
			var index:uint=(y - 1) * mapWidth + x;
			return nodeList[index];
		}

		public function getLeftNode(x:uint, y:uint):Node
		{
			if (x == 0)
				return null;
			var index:uint=y * mapWidth + x - 1;
			return nodeList[index];
		}

		public function getRightNode(x:uint, y:uint):Node
		{
			if (mapWidth == x + 1)
				return null;
			var index:uint=y * mapWidth + x + 1;
			return nodeList[index];
		}

		public function getBottomLeftNode(x:uint, y:uint):Node
		{
			if (x == 0)
				return null;
			if (mapHeight == y + 1)
				return null;
			var index:uint=(y + 1) * mapWidth + x - 1;
			return nodeList[index];
		}

		public function getBottomRightNode(x:uint, y:uint):Node
		{
			if (mapWidth == x + 1)
				return null;
			if (mapHeight == y + 1)
				return null;
			var index:uint=(y + 1) * mapWidth + x + 1;
			return nodeList[index];
		}

		public function getBottomNode(x:uint, y:uint):Node
		{
			if (mapHeight == y + 1)
				return null;
			var index:uint=(y + 1) * mapWidth + x;
			return nodeList[index];
		}

		public function doTest(x:uint, y:uint, nodesHolder:DisplayObjectContainer):void
		{
			var np:NodeShape=null;
			var n:Node=null;
			var p:Node=this.getNode(x, y);
			NodeShape(nodesHolder.getChildAt(p.index)).color=0xff0000;
			trace("current\t", p)
			n=getTopLeftNode(x, y);
			if (n)
			{
				n.parent=p;
				np=NodeShape(nodesHolder.getChildAt(n.index));
				np.color=0x808000;
				np.angle=n.angle;
				trace("TopLeft\t", n);
			}

			n=getTopNode(x, y);
			if (n)
			{
				n.parent=p;
				np=NodeShape(nodesHolder.getChildAt(n.index));
				np.color=0x808000;
				np.angle=n.angle;
				trace("Top\t", n);
			}

			n=getTopRightNode(x, y);
			if (n)
			{
				n.parent=p;
				np=NodeShape(nodesHolder.getChildAt(n.index));
				np.color=0x808000;
				np.angle=n.angle;
				trace("TopRight\t", n);
			}

			n=getRightNode(x, y);
			if (n)
			{
				n.parent=p;
				np=NodeShape(nodesHolder.getChildAt(n.index));
				np.color=0x808000;
				np.angle=n.angle;
				trace("Right\t", n);
			}

			n=getBottomRightNode(x, y);
			if (n)
			{
				n.parent=p;
				np=NodeShape(nodesHolder.getChildAt(n.index));
				np.color=0x808000;
				np.angle=n.angle;
				trace("BottomRight\t", n);
			}

			n=getBottomNode(x, y);
			if (n)
			{
				n.parent=p;
				np=NodeShape(nodesHolder.getChildAt(n.index));
				np.color=0x808000;
				np.angle=n.angle;
				trace("Bottom\t", n);
			}

			n=getBottomLeftNode(x, y);
			if (n)
			{
				n.parent=p;
				np=NodeShape(nodesHolder.getChildAt(n.index));
				np.color=0x808000;
				np.angle=n.angle;
				trace("BottomLeft\t", n);
			}

			n=getLeftNode(x, y);
			if (n)
			{
				n.parent=p;
				np=NodeShape(nodesHolder.getChildAt(n.index));
				np.color=0x808000;
				np.angle=n.angle;
				trace("Left\t", n);
			}
		}
	}
}
