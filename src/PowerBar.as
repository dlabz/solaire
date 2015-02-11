package  
{
	import dl.events.CalcEvent;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class PowerBar extends Sprite
	{
		public var bmp:Bitmap = new Library.powerBar();
		private var powerMask:Shape = new Shape();
		private var g:Graphics;
		public function PowerBar() 
		{
			
			addChild(bmp);
			g = powerMask.graphics;
			
			var h:Number = 482
			g.clear();
			g.beginFill(0x999999, .5);
			g.moveTo(36, 28);
			g.curveTo(47.5, 11.5, 59, 28);
			g.lineTo(59, 28+h);
			g.curveTo(47.5, (23 + h), 36, 28+h);
			g.endFill();
			
			addChild(powerMask);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(CalcEvent.CHANGE, update);
			//stage.addEventListener("calcUpdate", calcUpdate);
			
			
		}
		
		public function update(e:CalcEvent):void {
			
			//trace("//TODO: PowerBar -> update -> " + e.energy);
			//var c:Calculate = e.relatedObject as Calculate;
			
			trace("calcEvent", e);
			var s:Number = ((e.shadow * 100));
			var t:Number = (1 - e.orientation );// * s;
			
			//TODO: formula for h max 482
			
			var h:Number = 482 * ( 1 - e.energy/600);
			var p:Number =( 482-h)/482;
			trace("//TODO: PowerBar -> update -> " + s + " " + p + " " + h);
			g.clear();
			g.beginFill(0x999999, .5);
			g.moveTo(36, 28);
			g.curveTo(47.5, 10, 59, 28);
			g.lineTo(59, 28+h);
			g.curveTo(47.5, (28+ h-18*p ), 36, 28+h);
			g.endFill();
			
		}
	}

}