package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BevelFilter;
	
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class Switch extends Sprite
	{
		public var status:Boolean = false;
		
		
		//
		public var b:Bitmap;
		private var a:Array;
		public function Switch(a:Array) 
		{
			buttonMode = true;
			useHandCursor = true;
			this.a = a;
			var g:Graphics = graphics;
			g.lineStyle(0);
			g.beginFill(Library.c1, 1);
			g.drawRoundRect(0, 0, 32, 20, 2, 2);
			//filters = [new BevelFilter(2,2)]
			
			b = new Library[a[0]]();
			
			b.y = 2;
			b.x = 8;
			addChild(b);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addEventListener(MouseEvent.MOUSE_DOWN, mDown);
		}
		
		private function mDown(e:MouseEvent):void {
			e.stopPropagation();
			trace("btn mdwn");
			//dispatchEvent(new DataEvent("button", true, false, name));
			removeChild(b);
			var g:Graphics = graphics;
			switch (status) 
			{
				case true:
					//name = "pencli"
					//g.clear();
					//g.lineStyle(0);
					//g.beginFill(0x666666,1);
					//g.drawRoundRect(0, 0, 32, 20, 2, 2);
					setOff()
				break;
				case false:
					//name = "eraser"
					//g.clear();
					//g.lineStyle(0);
					//g.beginFill(0x999999, 1);
					//g.drawRoundRect(0, 0, 32, 20, 2, 2);
					setOn();
				break;
			
			}
				b.y = 2;
				b.x = 8;
				addChild(b);
				dispatchEvent(new DataEvent("switchBackground", true, false, status.toString()));
		}
		private function setOn():void {
			
			status = true;
			b = new Library[a[1]]();
		}
		private function setOff():void {
			
			status = false;
			b = new Library[a[0]]();
		}
		
	}

}