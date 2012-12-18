package  
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class CalculateFormula extends Sprite
	{
		[Embed(source = '../lib/Capture.PNG')]
		private var Cap:Class;
		private var ref:Bitmap = new Cap();
		
		private var s:Shape = new Shape();
		public function CalculateFormula() 
		{
			addChild(ref);
			ref.x = -20;
			
			addChild(s);
			s.y = 7;
			var g:Graphics = s.graphics;
			g.lineStyle(3, 0x999966, .3);
			var xs:Number = 840 / 130;
			var ys = 330 / 45;
			for (var i:int = 0; i <= 130; i++) 
			{
				g.lineTo(i*xs, f(i)*ys);
			}
			addEventListener(Event.ENTER_FRAME, eF);
		}
		private function f(_x:Number):Number {
			return _x*_x / 385;
		}
		private function eF(e:Event):void {
			trace(s.mouseX, s.mouseY,f(s.mouseX*130/840));
		}
	}

}