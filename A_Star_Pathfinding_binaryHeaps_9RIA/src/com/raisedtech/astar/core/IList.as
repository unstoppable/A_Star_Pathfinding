package com.raisedtech.astar.core
{
	public interface IList
	{
		function push(node:Node):void;
		function pop():Node;
		function get length():uint;
		function get vector():Vector.<Node>;
		function reset():void;
		function valueChanged(node:Node):void;
	}
}