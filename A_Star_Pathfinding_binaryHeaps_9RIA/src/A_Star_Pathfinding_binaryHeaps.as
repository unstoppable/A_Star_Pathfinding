package
{
	import com.raisedtech.astar.core.ArithmeticFindPathIn8Directions;
	import com.raisedtech.astar.core.BinaryHeaps;
	import com.raisedtech.astar.core.Node;
	import com.raisedtech.astar.core.NodeManager;
	import com.raisedtech.astar.core.NodeShape;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.getTimer;

	[SWF(width="1000", height="1045")]
	
	
	/**
	 * Its my first A* pathfinding demo. I learnt from<br/>
	 * [A* Pathfinding for Beginners] http://www.policyalmanac.org/games/aStarTutorial.htm<br/>
	 * [Using Binary Heaps in A* Pathfinding] http://www.policyalmanac.org/games/binaryHeaps.htm<br/>
	 * Wrote by Patrick Lester. Thanks to Patrick Lester,<br/>  
	 * And thanks to my gril's help on repicking up the thoery of B+ tree and storing complete binnery tree in array.
	 * <p>制作一个100＊100的地图，方格宽高均为10像素。可通过方格为绿色，障碍物方格为黑色。首尾方格为红色。路径线使用蓝色。
要求：在100x100方格内，随机摆放1000个障碍物，可直接设置起始位置和终点位置，使用A＊寻路算法在最短时间内得到可连接收尾点的最短路径。
</p>
	 * @author Liu lhw1987654@gmail.com
	 *
	 */
	public class A_Star_Pathfinding_binaryHeaps extends Sprite
	{
		public static var instance:A_Star_Pathfinding_binaryHeaps;
		private static var MAP_WIDTH:int=100;
		private static var MAP_HEIGHT:int=100;
		public var nodesHolder:Sprite;
		private var manager:NodeManager;
		private var arithmetic:ArithmeticFindPathIn8Directions;
		private var startPoint:Point;
		private var endPoint:Point;
		private var title:Title;

		public function A_Star_Pathfinding_binaryHeaps()
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
			panel.gonow.addEventListener(MouseEvent.CLICK, onGoNow);
		}

		protected function onGoNow(event:MouseEvent):void
		{
			var panel:InfoPanel=InfoPanel(event.target.parent);
			panel.parent.removeChild(panel);
			filters=[];
			mouseChildren=true;
			mouseEnabled=true;
			try
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;
			} 
			catch(error:Error) 
			{
				
			}
		}

		private function initTitle():void
		{
			title=new Title();
			title.bg.width=MAP_WIDTH * NodeShape.SIZE;
			trace("SIZE", MAP_WIDTH * NodeShape.SIZE, MAP_HEIGHT * NodeShape.SIZE);

			var ct:ColorTransform=new ColorTransform();
			ct.color=NodeShape.COLOR_OPENED;
			title.opened.colorable.transform.colorTransform=ct;

			ct.color=NodeShape.COLOR_CLOSED;
			title.closed.colorable.transform.colorTransform=ct;

			ct.color=NodeShape.COLOR_A_PATH;
			title.found.colorable.transform.colorTransform=ct;

			this.addChild(title);
		}

		private function setTitle(s:String):void
		{
			title.info.text=s;
		}

		private function createMap(... arg):void
		{
			initMap();
			arithmetic=new ArithmeticFindPathIn8Directions(this.manager, new BinaryHeaps(100));
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

			var blocks:Vector.<Boolean> = createBlocks(1000, MAP_WIDTH* MAP_HEIGHT);
			
			var ns:NodeShape=null;
			var index:uint=0;
			for (var y:int=0; y < MAP_HEIGHT; y++)
			{
				for (var x:int=0; x < MAP_WIDTH; x++)
				{
					ns=new NodeShape();
					ns.y=y * NodeShape.SIZE;
					ns.x=x * NodeShape.SIZE;
					if (1==blocks[index])
						ns.color=0;
					nodesHolder.addChild(ns);
					manager.nodeList.push(new Node(index++, x, y, ns.color ? 1 : 0));
				}
			}
		}
		
		private function createBlocks(amount:int, total:int):Vector.<Boolean>
		{
			var blocks:Vector.<Boolean> = new Vector.<Boolean>(total);
			var i:uint = 0;
			while(amount--){
				i = ((Math.random()*total*total)>>2)%total;
				if(blocks[i]){
					i++;
				}else{
					blocks[i]=1;
				}
			}
			return blocks;
		}
		
		protected function onClicked(event:MouseEvent):void
		{
			if (event && !(event.target is NodeShape))
			{
				return;
			}
			var target:NodeShape=event.target as NodeShape;
			var node:Node=manager.nodeList[nodesHolder.getChildIndex(target)];
			if (!node.accessable)
			{
				setTitle("No Path");
				return;
			}
			
			if(startPoint==null){
				startPoint = new Point(node.x, node.y);
				NodeShape(target).color=0xff0000;
				return;
			}
			endPoint=new Point(node.x, node.y);

			this.mouseChildren=false;
			this.mouseEnabled=false;
			manager.reset();
			for (var j:int=0; j < nodesHolder.numChildren; j++)
			{
				var np:NodeShape=NodeShape(nodesHolder.getChildAt(j));
				np.clearSatus();
			}

			//计算寻路耗时
			var t:Number=getTimer();
			var path:Array=arithmetic.findPath(startPoint, endPoint);
			t  =getTimer() - t;
			
			if (path.length > 0)
			{
				setTitle("Path:{xx}, Score:{345}, Costs {34}ms.".replace("{xx}", arithmetic.openedNodeList.length).replace("{345}", arithmetic.lastPathLength).replace("{34}", t));
			}
			else
			{
				setTitle("No Path, Costs {34}ms.".replace("{34}", t));
			}

			for each (var k:Node in arithmetic.openedNodeList.vector)
			{
				if (!k)
					break;
				np=NodeShape(nodesHolder.getChildAt(k.index));
				np.color=NodeShape.COLOR_OPENED;
			}

			for each (var gk:Node in arithmetic.closedNodeList)
			{
				np=NodeShape(nodesHolder.getChildAt(gk.index));
				np.color=NodeShape.COLOR_CLOSED;
			}


			for each (var i:int in path)
			{
				NodeShape(nodesHolder.getChildAt(i)).color=NodeShape.COLOR_A_PATH;
			}
			
			if(path.length>0)
				NodeShape(nodesHolder.getChildAt(path[0])).color=0xff0000;
			
			if(path.length>1)
				NodeShape(nodesHolder.getChildAt(path[path.length-1])).color=0xff0000;

			this.mouseChildren=true;
			this.mouseEnabled=true;
			startPoint=null;
		}

	}
}



