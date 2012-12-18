package  
{
	import flash.ui.*;
	import flash.display.*;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class customNativeCursor extends Sprite
	{
		
		public function customNativeCursor() 
		{

			var penCursorData:MouseCursorData = new MouseCursorData()
			//penCursorData.hotSpot = new Point(15,15);
			penCursorData.data = new Vector.<BitmapData>(1, true);
			penCursorData.data[0] = (new Library.pen()).bitmapData;
			Mouse.registerCursor("penCursor", penCursorData);
			
			
			// whenever we neeed to show it, we pass the alias to the existing cursor property
			Mouse.cursor = "penCursor";


		}
		
	}

}