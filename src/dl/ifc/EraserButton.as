package dl.ifc 
{
	import flash.events.MouseEvent;
	import flash.events.DataEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class EraserButton extends DlButton 
	{
		
		public function EraserButton() 
		{
			super(["eraser"]);
			addEventListener(MouseEvent.MOUSE_DOWN,mStop);
		}
		override protected function action(e:MouseEvent):void {
			trace("action", _n);
			e.stopPropagation();
			dispatchEvent(new DataEvent("setupBrush", true,false,_n));
		}
		
	}

}