package dl.ifc 
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class ToolButton extends DlDropButton
	{
		
		public function ToolButton() 
		{
			super(["arrow", "pen", "pencil"]);
		}
		override protected function init(e:Event = null):void {
			stage.addEventListener("toolChanged", toolChanged);
		}
		private function toolChanged(e:DataEvent):void {
			
			changeIcon(e.data);
		}
		override protected function action(e:MouseEvent):void {
			e.stopPropagation();
			trace("action", _n);
			dispatchEvent(new DataEvent("changeTool", true,false,_n));
		}
		override protected function setIcon(_s:String):void {
			removeEventListener(MouseEvent.MOUSE_DOWN, action);
			b = new Library[_s];
			_n = _s;
			if (_s == "pencil") {
				addEventListener(MouseEvent.MOUSE_DOWN, action);
							stage.dispatchEvent(new Event("pencilCursor"))

			}
			
		}
		
	}

}