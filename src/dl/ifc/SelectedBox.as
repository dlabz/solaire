package dl.ifc 
{
	import dl.events.DlEvt;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class SelectedBox extends Sprite
	{
		public var type:TypeButton = new TypeButton();
		public var slider:SliderDraw; 
		
		public var _selected:Shadow = null;
		public function SelectedBox() 
		{
			type.active = false;
			addChild(type);
			//slider.y = 32;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null):void 
		{
			addEventListener(MouseEvent.MOUSE_OVER, mFix);
			addEventListener(MouseEvent.MOUSE_MOVE, mStop);
			addEventListener(MouseEvent.CLICK, mStop);
			addEventListener(MouseEvent.MOUSE_UP, mStop);
			addEventListener(MouseEvent.MOUSE_DOWN, mStop);

			stage.addEventListener("selectedShadow", selectedShadow);
			stage.addEventListener(DlEvt.TOOL_CHANGED, toolChanged);
		}
		private function toolChanged(e:Event):void {
			if (slider) removeChild(slider);
			if (_selected is ShadowRaster && (_selected as ShadowRaster).action != null) {
				trace((_selected as ShadowRaster).action,(_selected as ShadowRaster).lastBrushSize)
				slider = new SliderDraw(100, 32, (_selected as ShadowRaster).action, (_selected as ShadowRaster).lastBrushSize);
				slider.y = 32;
				addChildAt(slider, 0);
			}else {
				slider = null;
			}
		}
		private function selectedShadow(e:MouseEvent):void {
			trace("selectedShadow", e.relatedObject);
			selected = e.relatedObject as Shadow;;
		}
		public function set selected(s:Shadow):void {
			if (slider) removeChild(slider);
			_selected = s;
			if (_selected) {
				type.active = true; 
				
				
			}else type.active = false;
			if (_selected is ShadowRaster && (_selected as ShadowRaster).action != null) {
				trace((_selected as ShadowRaster).action,(_selected as ShadowRaster).lastBrushSize)
				slider = new SliderDraw(100, 32, (_selected as ShadowRaster).action, (_selected as ShadowRaster).lastBrushSize);
				slider.y = 32;
				addChildAt(slider, 0);
			}else {
				slider = null;
			}
		}
		
		private function mStop(e:MouseEvent):void
		{
			e.stopPropagation();
		}

		private function mFix(e:MouseEvent):void {
			dispatchEvent(new Event("fixCursor",true))
		}

	}

}