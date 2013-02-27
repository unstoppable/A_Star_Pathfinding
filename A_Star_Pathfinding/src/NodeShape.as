package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class NodeShape extends NodeUI
	{
		public static const COLOR_UNACCESSABLE:uint=0;
		public static const COLOR_CLOSED:uint=0x008080;
		public static const COLOR_OPENED:uint=0x808000;
		public static const COLOR_AVAILALE:uint=0x55b551;
		public static const COLOR_A_PATH:uint=0xff0000;

		public static const SIZE:int=35;
		public var _color:uint=0;
		public var index:uint=0;

		public function NodeShape()
		{
			this.mouseChildren=false;
			this.useHandCursor=true;
			this.buttonMode=true;

			this.arrow.visible=false;
			color=COLOR_AVAILALE;
			txt.text="";
		}


		public function setTitle(f:Number, g:Number, h:Number):void
		{
			txt.text="F:" + f + "\nG:" + g + "\nH:" + h;
			var fmt:TextFormat=txt.defaultTextFormat;
			fmt.size=8;
			txt.setTextFormat(fmt);
		}

		public function clearSatus():void
		{
			txt.text="";
			this.arrow.visible=false;
			if (color !=COLOR_UNACCESSABLE)
				color=COLOR_AVAILALE;
		}

		public function set angle(value:uint):void
		{
			if (value < 360)
			{
				this.arrow.visible=true;
				this.arrow.rotation=value;
			}
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
