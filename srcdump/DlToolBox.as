package ump 
{
	import flash.display.Sprite;
	import dl.ifc.*;
	import flash.events.MouseEvent;
	import flash.events.DataEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class DlToolBox extends Sprite
	{
		public var type:TypeButton = new TypeButton();
		public var tool:ToolButton = new ToolButton();
		public var eraser:EraserButton = new EraserButton();
		
		private var ps:SliderDraw = new SliderDraw(100, 32, "pencil");
		private var es:SliderDraw = new SliderDraw(100, 32, "eraser");

		public function DlToolBox() 
		{
			type.active = false;
			addChild(type);
			
			//tool.addEventListener("changeTool",changeTool)
			tool.x = 32;
			addChild(tool);

			eraser.x = 64;
			//eraser.addEventListener("changeTool", changeTool);
			eraser.active = false;
			addChild(eraser);
			
			//useHandCursor = true;
			//buttonMode = true;
			
			addEventListener(MouseEvent.MOUSE_DOWN, mStop);
			addEventListener(MouseEvent.MOUSE_UP, mStop);
			addEventListener(MouseEvent.CLICK, mStop);
			addEventListener(MouseEvent.MOUSE_MOVE, mStop);
			addEventListener(MouseEvent.MOUSE_OVER, mFix);
			
			addEventListener("changeTool",changeTool)
			
		}
		
		private function changeTool(e:DataEvent):void {
			trace("changeTool", e.data)
			if (ps.parent) removeChild(ps);
			if (es.parent) removeChild(es);
			switch (e.data) 
			{
				case "pencil":
					eraser.active = true;
					ps.y = 32;
					ps.x = 32;
					addChildAt(ps, 0);
					
					ps.dispatchEvent(new DataEvent("setupBrush",true,false,e.data))
				break;
				case "eraser":
					es.x = 64;
					es.y = 32;
					addChildAt(es,0);
					es.dispatchEvent(new DataEvent("setupBrush",true,false,e.data))
				break;
				
				default:
					eraser.active = false;
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