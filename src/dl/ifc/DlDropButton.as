package dl.ifc
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class DlDropButton extends DlButton
	{
		
		public function DlDropButton(_a:Array) 
		{
			super(_a);
			addEventListener(MouseEvent.MOUSE_OVER, open);
		}
		
		override protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addEventListener(MouseEvent.MOUSE_UP, mStop);
			addEventListener(MouseEvent.MOUSE_DOWN, mStop);
		}
		
		
		private function open(e:MouseEvent):void {
			if (!e.buttonDown) {
				
		
			trace("open");
			
			stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
			removeEventListener(MouseEvent.MOUSE_OVER, open);

			var box:Sprite = new Sprite();
			box.name = "box";
			box.y = this.height;
			for (var i:int = 0; i < a.length; i++) 
			{
				if (!(_n == a[i])) {
					var bt:Sprite = mkOption(a[i]);
					bt.y = box.height;
					//bt.addEventListener(MouseEvent.MOUSE_UP, mStop);
					box.addChild(bt);
				}
				
			}
			//box.addEventListener(MouseEvent.MOUSE_UP, mStop);
			addChild(box);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, close);	
			}
		}
		private function close(e:MouseEvent = null):void {
			trace("close")
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, close);	
			
			if(e) e.stopPropagation();
			var box:Sprite = getChildByName("box") as Sprite;
			if(box)removeChild(box);
			box = null;
			addEventListener(MouseEvent.MOUSE_OVER, open);

		}
		
		private function select(e:MouseEvent):void {
			e.stopPropagation();
			changeIcon(e.target.name);
			action(e);
			close();
		}

		private function mkOption(_s:String):Sprite {
			var tmp:Sprite = new Sprite();
			tmp.name = _s;
			var g:Graphics = tmp.graphics;
			g.beginFill(Library.c2, 1);
			g.drawRoundRect(0, 0, 32, 32, 8, 8);
			var b:Bitmap = new Library[_s]();
			tmp.addChild(b);
			tmp.useHandCursor = true;
			tmp.buttonMode = true;
			tmp.addEventListener(MouseEvent.MOUSE_DOWN, mStop);
			tmp.addEventListener(MouseEvent.MOUSE_UP, select);
			return tmp;
		}
		
	}

}