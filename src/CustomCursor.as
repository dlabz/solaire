package
{
	import dl.events.DlEvt;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.ui.*;
	import flash.geom.Point;
	
	import Library;
	
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class CustomCursor extends Sprite
	{
		private var lastCursor:String = "auto";
		private var hidden:Boolean = false;
		//private var peace:Boolean = false;
		public function CustomCursor()
		{
			var slk:Shape = new Shape();
			slk.graphics.lineStyle(0, 0x666666);
			slk.graphics.moveTo(0, 0);
			slk.graphics.lineTo(0, -Math.sqrt(3) * 10 / 3);
			slk.graphics.moveTo(0, 0);
			slk.graphics.lineTo(-5, Math.sqrt(3) * 10 / 6);
			slk.graphics.moveTo(0, 0);
			slk.graphics.lineTo(5, Math.sqrt(3) * 10 / 6);
			var b:BitmapData = new BitmapData(10, 10, true, 0);
			b.draw(slk, new Matrix(1, 0, 0, 1, 5, 5));
			slk = null;
			
			var peaceCursorData:MouseCursorData = new MouseCursorData()
			peaceCursorData.hotSpot = new Point(5, 5);
			peaceCursorData.data = new Vector.<BitmapData>(1, true);
			peaceCursorData.data[0] = b;
			Mouse.registerCursor("peaceCursor", peaceCursorData);
			
			var penCursorData:MouseCursorData = new MouseCursorData()
			penCursorData.hotSpot = new Point(0, 15);
			penCursorData.data = new Vector.<BitmapData>(1, true);
			penCursorData.data[0] = (new Library.mpen()).bitmapData;
			Mouse.registerCursor("penCursor", penCursorData);
			
			var benzeeCursorData:MouseCursorData = new MouseCursorData()
			benzeeCursorData.hotSpot = new Point(5, 0);
			benzeeCursorData.data = new Vector.<BitmapData>(1, true);
			benzeeCursorData.data[0] = (new Library.benzee()).bitmapData;
			Mouse.registerCursor("benzeeCursor", benzeeCursorData);
			
			var hReadyCursorData:MouseCursorData = new MouseCursorData()
			hReadyCursorData.hotSpot = new Point(5, 0);
			hReadyCursorData.data = new Vector.<BitmapData>(1, true);
			hReadyCursorData.data[0] = (new Library.hReady()).bitmapData;
			Mouse.registerCursor(DlEvt.CURSOR_HR, hReadyCursorData);
			
			var hGrabCursorData:MouseCursorData = new MouseCursorData()
			hGrabCursorData.hotSpot = new Point(5, 0);
			hGrabCursorData.data = new Vector.<BitmapData>(1, true);
			hGrabCursorData.data[0] = (new Library.hGrab()).bitmapData;
			Mouse.registerCursor(DlEvt.CURSOR_HG, hGrabCursorData);
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			stage.addEventListener("peaceCursor", peaceCursor);
			stage.addEventListener("noPeaceCursor", noPeaceCursor);
			stage.addEventListener("penCursor", penCursor);
			stage.addEventListener("benzeeCursor", benzeeCursor);
			stage.addEventListener("hReadyCursor", hReadyCursor);
			stage.addEventListener("hGrabCursor", hGrabCursor);
			stage.addEventListener("removeCursor", removeCursor);
			stage.addEventListener("resetCursor", resetCursor);
			stage.addEventListener("fixCursor", fixCursor);
			stage.addEventListener("unfixCursor", unFixCursor);
		}
		
		private function peaceCursor(e:Event):void
		{
			lastCursor = Mouse.cursor;
			Mouse.show();
			hidden = false;
			Mouse.cursor = "peaceCursor";
			
			//trace(e.currentTarget,Mouse.cursor)
		}
		
		private function noPeaceCursor(e:Event):void {
			Mouse.show();
			hidden = false;
			Mouse.cursor = lastCursor;
		}
		
		private function penCursor(e:Event):void
		{
			Mouse.show();
			hidden = false;
			lastCursor = Mouse.cursor = "penCursor";
			//trace(e.currentTarget,Mouse.cursor)
		}
		
		private function benzeeCursor(e:Event):void
		{
			
			Mouse.show();
			hidden = false;
			lastCursor = Mouse.cursor = "benzeeCursor";
			//trace(e.currentTarget,Mouse.cursor)
		}
		
		private function hReadyCursor(e:Event):void
		{
			
			Mouse.show();
			hidden = false;
			lastCursor = Mouse.cursor = "hReadyCursor";
			trace(e.currentTarget,Mouse.cursor)
		}
		
		private function hGrabCursor(e:Event):void
		{
			
			Mouse.show();
			hidden = false;
			lastCursor = Mouse.cursor = "hGrabCursor";
			trace(e.currentTarget,Mouse.cursor)
		}
		
		private function resetCursor(e:Event):void
		{
			Mouse.show();
			hidden = false;
			
			lastCursor = Mouse.cursor = MouseCursor.AUTO;
			//trace(e.currentTarget,Mouse.cursor)
		}
		
		private function removeCursor(e:Event):void
		{
			Mouse.hide();
			hidden = true;
		
			//trace(e.currentTarget,Mouse.cursor)
		}
		
		private function fixCursor(e:Event):void
		{
			Mouse.show();
			
			//trace(e.target, "fix")
			//lastCursor = Mouse.cursor.valueOf();
			Mouse.cursor = MouseCursor.AUTO;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, unFixCursor);
		}
		
		private function unFixCursor(e:Event):void
		{
			if (hidden == true)
				Mouse.hide() //; else Mouse.show();
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, unFixCursor)
			//trace(e.currentTarget,"unfix",lastCursor)
			Mouse.cursor = lastCursor;
		}
	
	}

}