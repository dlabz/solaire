package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BevelFilter;
	
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class Button extends Sprite
	{
		public var status:Boolean = true;
		
		//
		private var _n:String;
		public function Button(n:String = "evergreen") 
		{
					
			name = n;
			var g:Graphics = graphics;
			//g.lineStyle(0,0,.3)
			g.beginFill(Library.c1, 1);
			g.drawRoundRect(0, 0, 32, 32, 8, 8);
			//filters = [new BevelFilter(2,2)]
			
			var b:Bitmap = new Library[n]();
			//b.width = b.height = 28;
				//b.x = b.y = 2;
			addChild(b);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addEventListener(MouseEvent.MOUSE_DOWN, mDown);
			useHandCursor = true;
			buttonMode = true;
			if (parent is Main) {
				addEventListener(MouseEvent.CLICK, mStop);
				addEventListener(MouseEvent.MOUSE_MOVE, mStop);
				addEventListener(MouseEvent.MOUSE_OVER, mFix);

			}
		}
		
		private function mDown(e:MouseEvent):void {
			e.stopPropagation();
			trace("btn mdwn", name);
			dispatchEvent(new DataEvent("button", true, false, name));
			
			var g:Graphics = graphics;
			switch (name) 
			{
				case "eraser":
					name = "eraser"
					g.clear();
					g.beginFill(0x999999,1);
					g.drawRoundRect(0, 0, 32, 32, 8, 8);
				break;
				case "pencil":
					name = "eraser"
					g.clear();
					g.beginFill(0x666666, 1);
					g.drawRoundRect(0, 0, 32, 32, 8, 8);
				break;
				default:
			}
			
		}
		private function mStop(e:MouseEvent):void {
			
			e.stopPropagation()
		}
		private function mFix(e:MouseEvent):void {
			
			dispatchEvent(new Event("fixCursor",true))
		}
		private function setOn():void {
			
			this.filters = []
		}
		private function setOff():void {
			
			this.filters = [dBW.BW()]
		}
		
	}

}