package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class RasterShape extends Sprite
	{
		private var g:Graphics;
		private var b:BitmapData;
		private var brush:Shape = new Shape();
		private var bbrush:BitmapData;
		private var stroke:Shape = new Shape();
		public function RasterShape() 
		{
			g = this.graphics;
			mkBrush(10,1);
			addChild(brush);
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			b = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
			var bm:Bitmap = addChild(new Bitmap(b)) as Bitmap
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, bMove);
			stage.addEventListener("setupBrush", setupBrush);
		}
		private function mDown(e:MouseEvent):void {
			//b.draw(brush, brush.transform.matrix, null, BlendMode.DARKEN, b.rect);
			stroke = new Shape();
			graphics.lineStyle(10, 0);
			graphics.lineBitmapStyle(bbrush,brush.transform.matrix,true,true);
			graphics.moveTo(stage.mouseX, stage.mouseY);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, mUp);
			//addChild(stroke);
		}
		private function bMove(e:MouseEvent):void {
			brush.x = stage.mouseX;
			brush.y = stage.mouseY;
		}
		private function mMove(e:MouseEvent):void {
			graphics.lineTo(stage.mouseX, stage.mouseY);
			
		}
		private function mUp(e:MouseEvent):void {
			//b.draw(stroke, stroke.transform.matrix, null, BlendMode.DARKEN, b.rect);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mMove);
			//removeChild(stroke)
		}
		private function setupBrush(e:DataEvent):void {
			trace("setupBrush", e.data);
		}
		private function mkBrush(r:Number,o:Number):void {
			brush.graphics.clear();
			brush.graphics.beginFill(0, o);
			brush.graphics.drawCircle(0, 0, r);
			bbrush = new BitmapData(brush.width, brush.height, true, 0);
			bbrush.draw(brush);
		}
		
	}

}