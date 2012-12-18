package dl.ifc 
{
	import dl.ifc.DlArrow;
	import dl.ifc.DlButton;
	import dl.ifc.DlPen;
	import dl.ifc.DlPencil;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class DlToolBox extends Sprite
	{
		public var arrow:DlArrow = new DlArrow();
		public var pen:DlPen = new DlPen();
		public var pencil:DlPencil = new DlPencil();
		public var eraser:EraserButton = new EraserButton();
		
		public var _selected:Shadow = null;
		public function DlToolBox() 
		{
			addChild(arrow);
			arrow.marked = true;
			pen.x = 32;
			addChild(pen);
			pencil.x = 64;
			addChild(pencil);
			eraser.x = 96;
			eraser.active = false;
			addChild(eraser);
			//graphics.beginFill(0, 1);
			//graphics.drawRect(0, 0, width, height);
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null):void 
		{
			stage.addEventListener("selectedShadow", selectedShadow);
			stage.addEventListener("toolChanged", toolChanged);
		}
		private function selectedShadow(e:MouseEvent):void {
			trace("selectedShadow", e.relatedObject);
			selected = e.relatedObject as Shadow;;
		}
		public function set selected(s:Shadow):void {
			//if (slider.parent) removeChild(slider);
			_selected = s;
			//if (_selected) type.active = true; else type.active = false;
			if (_selected is ShadowRaster && (_selected as ShadowRaster).action == "pencil" && (_selected as ShadowRaster).closed == true ) eraser.active = true; else eraser.active = false;
		
		}
		private function toolChanged(e:DataEvent):void {
			arrow.marked = false;
			pen.marked = false;
			pencil.marked = false;
			eraser.marked = false;
			
			this[e.data].marked = true;
			
			
			if (e.data == "pencil" || e.data == "eraser") {
				eraser.active = true;
			}else {
				eraser.active = false;
			}
		}
		
	}

}