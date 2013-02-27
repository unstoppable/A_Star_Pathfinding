package com.raisedtech.astar.core
{
	import flash.errors.IllegalOperationError;

	public class BinaryHeaps implements IList
	{
		protected var index:int=-1;
		protected var arr:Vector.<Node>;


		public function BinaryHeaps(size:int)
		{
			arr=new Vector.<Node>(size);
		}

		public function push(node:Node):void
		{
			arr[++index]=node;
			reBuildHeap(index);
		}

		protected function reBuildHeap(cIndex:int):void
		{
			if (cIndex <= 0)
				return;
			var cur:Node=arr[cIndex];
			var pIndex:int=getParentNodeIndex(cIndex);
			var p:Node=arr[pIndex];
			if (1 == Node.compare(cur, p))
			{
				arr[cIndex]=p;
				arr[pIndex]=cur;
			}
			reBuildHeap(pIndex);
		}

		public function pop():Node
		{
			if (index < 0)
				return null;
			if (index == 0)
			{
				index--;
				return arr[0];
			}
			var rs:Node=arr[0];
			arr[0]=arr[index];
			arr[index]=null;
			index--;
			reOrder(0);
			return rs;
		}

		protected function reOrder(cIndex:int):void
		{
			var leftIndex:int=getLeftNodeIndex(cIndex);
			var rightIndex:int=getRightNodeIndex(cIndex);
			if (leftIndex > index && rightIndex > index)
			{
				return;
			}

			var cur:Node=arr[cIndex];
			var leftNode:Node=arr[leftIndex];
			var rightNode:Node=arr[rightIndex];

			if (!leftNode)
			{
				if (-1 == Node.compare(cur, rightNode))
				{
					arr[cIndex]=rightNode;
					arr[rightIndex]=cur;
					reOrder(rightIndex);
				}
				return;
			}

			if (!rightNode)
			{
				if (-1 == Node.compare(cur, leftNode))
				{
					arr[cIndex]=leftNode;
					arr[leftIndex]=cur;
					reOrder(leftIndex);
				}
				return;
			}


			if (1 == Node.compare(rightNode, leftNode))
			{
				if (-1 == Node.compare(cur, rightNode))
				{
					arr[cIndex]=rightNode;
					arr[rightIndex]=cur;
					reOrder(rightIndex);
				}
				else if (-1 == Node.compare(cur, leftNode))
				{
					arr[cIndex]=leftNode;
					arr[leftIndex]=cur;
					reOrder(leftIndex);
				}
			}
			else
			{
				if (-1 == Node.compare(cur, leftNode))
				{
					arr[cIndex]=leftNode;
					arr[leftIndex]=cur;
					reOrder(leftIndex);
				}
				else if (-1 == Node.compare(cur, rightNode))
				{
					arr[cIndex]=rightNode;
					arr[rightIndex]=cur;
					reOrder(rightIndex);
				}
			}
		}

		/**
		 * the node value will only because smaller accordign to the A* Pathfing theory
		 * @param node
		 * 
		 */
		public function valueChanged(node:Node):void
		{
			var cIndex:int=arr.indexOf(node);
			reBuildHeap(cIndex);
		}
		
		private function upOrder(cIndex:int):void
		{
			// TODO Auto Generated method stub
			
		}
		
		////////////////////////////////////////////////////////

		public function get vector():Vector.<Node>
		{
			return arr;
		}

		public function reset():void
		{
			for (var i:int=0; i <= index; i++)
			{
				arr[i]=null;
			}
			index=-1;
		}

		public function get length():uint
		{
			return index + 1;
		}

		////////////////////////////////////////////////////

		/**
		 *
		 * @param i the index of the node. never use 0.
		 * @return
		 *
		 */
		protected function getParentNodeIndex(i:int):int
		{
			if (i == 0)
				throw new IllegalOperationError(" 0 is not allowed");
			if (i & 1 == 1)
			{
				//奇数, 则i为左子树
				//return (i + 1) / 2 - 1;
				return (i + 1 >> 1) - 1;
			}
			else
			{
				//偶数, 则i为右子树
				//return i / 2 - 1;
				return (i >> 1) - 1;
			}
		}

		protected function getLeftNodeIndex(index:int):int
		{
			//return 2 * index + 1;
			return (index << 1) + 1;
		}

		protected function getRightNodeIndex(index:int):int
		{
			//return 2 * (index+1);
			return (index + 1) << 1;
		}

		public function toString():String
		{
			var s:String="[BinaryHeaps] ";
			for (var i:int=0; i <= index; i++)
			{
				s+=arr[i].f + ",";
			}
			return s;
		}

	}
}
