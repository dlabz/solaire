package dl.ifc
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class DlButton extends Sprite
	{
		protected var b:Bitmap;
		protected var a:Array;
		protected var _n:String;
		protected var s:Boolean = true;

		public function DlButton(_a:Array) 
		{
			a = _a;
			name = _a[0];
			var g:Graphics = graphics;
			g.beginFill(Library.c1, 1);
			g.drawRoundRect(0, 0, 32, 32, 8, 8);
			
			setIcon(a[0]);
			addChild(b);
			

			useHandCursor = true;
			buttonMode = true;

			addEventListener(MouseEvent.MOUSE_MOVE, mStop);
			addEventListener(MouseEvent.MOUSE_OVER, mFix);
			addEventListener(MouseEvent.CLICK, mStop);
			addEventListener(MouseEvent.MOUSE_UP, mStop);
			

			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		protected function action(e:MouseEvent):void {
			e.stopPropagation();
			dispatchEvent(new Event(this._n+"Clicked"));
			trace("action", e.target.name);
		}

		protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addEventListener(MouseEvent.MOUSE_DOWN, action);
		}
		
		protected function changeIcon(_s:String):void {
			removeChild(b);
			setIcon(_s);
			addChild(b);
		}
		protected function setIcon(_s:String):void {
			b = new Library[_s];
			
			_n = _s;
		}
		protected function mStop(e:MouseEvent):void
		{
			e.stopPropagation();
		}

		private function mFix(e:MouseEvent):void {
			dispatchEvent(new Event("fixCursor",true))
		}
		
		public function set active(_s:Boolean):void {
			
			switch (_s) 
			{
				case true:
					useHandCursor = true;
					//mouseEnabled = true;
					removeEventListener(MouseEvent.MOUSE_DOWN, mStop);
					addEventListener(MouseEvent.MOUSE_DOWN, action);
					
				break;
				
				case false:
					useHandCursor = false;
					//mouseEnabled = false;
					addEventListener(MouseEvent.MOUSE_DOWN, mStop);
					removeEventListener(MouseEvent.MOUSE_DOWN, action);
					
				break;
			}
			act = _s;
		}
		
		public function set act(_s:Boolean):void {
			filters = (_s)?[]:[dBW.BW()];
			s = _s;
		}
		
		public function get act():Boolean {
			return s;
		}
		public function set marked(_m:Boolean):void {
			//trace("marking");
			var g:Graphics = graphics;
			g.clear()

			switch (_m) 
			{
				case true:
					g.beginFill(Library.c2, 1);
				break;
				
				case false:
					g.beginFill(Library.c1, 1);
				break;
			}
			g.drawRoundRect(0, 0, 32, 32, 8, 8);
		}

	}

}