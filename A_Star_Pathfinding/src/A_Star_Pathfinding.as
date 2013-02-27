package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;

	[SWF(width="1400",height="700")]
	public class A_Star_Pathfinding extends Sprite
	{
		public static var instance:A_Star_Pathfinding;
		private static var MAP_WIDTH:int=40;
		private static var MAP_HEIGHT:int=20;
		public var nodesHolder:Sprite;
		private var manager:NodeManager;
		private var arithmetic:ArithmeticFindPathIn8Directions;
		private var startPoint:Point;
		private var endPoint:Point;
		private var title:Title;

		public function A_Star_Pathfinding()
		{
			instance=this;
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		public function onAdded(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			initTitle();
			createMap();
			this.addEventListener(MouseEvent.CLICK, onClicked);
			initInfoPanel();
		}

		private function initInfoPanel():void
		{
			this.mouseChildren=false;
			this.mouseEnabled=false;
			var panel:InfoPanel=new InfoPanel();
			panel.x=int((stage.stageWidth - panel.width) / 2);
			panel.y=int((stage.stageHeight - panel.height) / 2);
			stage.addChild(panel);
			filters=[new BlurFilter(10, 10)];
			panel.gonow.addEventListener(MouseEvent.CLICK, function(... arg):void
			{
				stage.removeChild(panel);
				filters=[];
				mouseChildren=true;
				mouseEnabled=true;

			}, false, 0, true);
		}

		private function initTitle():void
		{
			title=new Title();
			title.bg.width=MAP_WIDTH * NodeShape.SIZE;
			trace("SIZE", MAP_WIDTH * NodeShape.SIZE, MAP_HEIGHT * NodeShape.SIZE);

			var ns:NodeShape=new NodeShape();
			ns.color=NodeShape.COLOR_OPENED;
			ns.mouseEnabled=false;
			ns.x=title.opened.x;
			ns.y=title.opened.y;
			title.addChild(ns);

			ns=new NodeShape();
			ns.color=NodeShape.COLOR_CLOSED;
			ns.mouseEnabled=false;
			ns.x=title.closed.x;
			ns.y=title.closed.y;
			title.addChild(ns);

			ns=new NodeShape();
			ns.color=NodeShape.COLOR_A_PATH;
			ns.mouseEnabled=false;
			ns.x=title.found.x;
			ns.y=title.found.y;
			title.addChild(ns);

			title.recreate.addEventListener(MouseEvent.CLICK, createMap);
			this.addChild(title);
		}

		private function setTitle(s:String):void
		{
			title.info.text=s;
		}

		private function createMap(... arg):void
		{
			initMap();
			if (0 == 1)
			{
				doTest();
				return;
			}
			startPoint=new Point(0, 0);
			endPoint=new Point(MAP_WIDTH - 1, MAP_HEIGHT - 1);
			arithmetic=new ArithmeticFindPathIn8Directions(this.manager);

			onClicked(null);
		}


		public function initMap():void
		{
			manager=new NodeManager(MAP_WIDTH, MAP_HEIGHT);

			if (nodesHolder)
			{
				this.removeChild(nodesHolder);
			}
			nodesHolder=new Sprite();
			nodesHolder.y=title.height;
			this.addChild(nodesHolder);

			var ns:NodeShape=null;
			var index:uint=0;
			for (var y:int=0; y < MAP_HEIGHT; y++)
			{
				for (var x:int=0; x < MAP_WIDTH; x++)
				{
					ns=new NodeShape();
					ns.y=y * NodeShape.SIZE;
					ns.x=x * NodeShape.SIZE;
					if (int(Math.random() * 100) % 5 == 0)
						ns.color=0;
					nodesHolder.addChild(ns);
					manager.nodeList.push(new Node(index++, x, y, ns.color ? 1 : 0));
				}
			}
		}

		protected function doTest():void
		{

			manager.doTest(0, 0, nodesHolder);
			manager.doTest(MAP_WIDTH - 1, MAP_HEIGHT - 1, nodesHolder);
			manager.doTest(0, MAP_HEIGHT - 1, nodesHolder);
			manager.doTest(MAP_WIDTH - 1, 0, nodesHolder);
		}

		protected function onClicked(event:MouseEvent):void
		{
			this.mouseChildren=false;
			this.mouseEnabled=false;
			manager.reset();
			for (var j:int=0; j < nodesHolder.numChildren; j++)
			{
				var np:NodeShape=NodeShape(nodesHolder.getChildAt(j));
				np.clearSatus();
			}
			if (event && event.target is NodeShape)
			{
				var dis:NodeShape=event.target as NodeShape;
				var node:Node=manager.nodeList[nodesHolder.getChildIndex(dis)];
				endPoint=new Point(node.x, node.y);
			}

			var t:Number=new Date().getTime();
			var path:Array=arithmetic.findPath(startPoint, endPoint);
			if (path.length > 0)
			{
				setTitle("Path Score:{345}, Costs {34}ms.".replace("{345}", arithmetic.lastPathLength).replace("{34}", new Date().getTime() - t));
			}
			else
			{
				setTitle("No Path, Costs {34}ms.".replace("{34}", new Date().getTime() - t));
			}

			for each (var k:Node in arithmetic.openedNodeList)
			{
				np=NodeShape(nodesHolder.getChildAt(k.index));
				np.color=NodeShape.COLOR_OPENED;
				np.setTitle(k.f, k.g, k.h);
				np.angle=k.angle;
			}

			for each (var gk:Node in arithmetic.closedNodeList)
			{
				np=NodeShape(nodesHolder.getChildAt(gk.index));
				np.color=NodeShape.COLOR_CLOSED;
				np.setTitle(gk.f, gk.g, gk.h);
				np.angle=gk.angle;
			}


			for each (var i:int in path)
			{
				NodeShape(nodesHolder.getChildAt(i)).color=0xff0000;
			}

			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

	}
}



