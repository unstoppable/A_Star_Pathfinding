package com.raisedtech.astar.core
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * 用于节点界面， 没啥逻辑，不解释
	 * 
	 * @author  Liu lhw1987654@gmail.com
	 * 
	 */
	public class NodeShape extends NodeUI
	{
		public static const COLOR_UNACCESSABLE:uint=0;
		public static const COLOR_CLOSED:uint=0x008080;
		public static const COLOR_OPENED:uint=0x808000;
		public static const COLOR_AVAILALE:uint=0x55b551;
		public static const COLOR_A_PATH:uint=0x0000ff;

		public static const SIZE:int=10;
		public var _color:uint=0;
		public var index:uint=0;

		public function NodeShape()
		{
			this.mouseChildren=false;
			this.useHandCursor=true;
			this.buttonMode=true;
			color=COLOR_AVAILALE;
		}

		public function clearSatus():void
		{
			if (color != COLOR_UNACCESSABLE)
				color=COLOR_AVAILALE;
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color=value;
			var ct:ColorTransform=new ColorTransform();
			ct.color=value;
			this.colorable.transform.colorTransform=ct;
		}

	}
}
