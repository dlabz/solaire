package dl.ifc 
{
	import flash.events.Event;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class DlPen extends DlButton
	{
		
		public function DlPen() 
		{
			super(["pen"]);
		}
		override protected function action(e:MouseEvent):void {
			trace("action", _n);
			e.stopPropagation();
			stage.dispatchEvent(new Event("removeCursor"))
			dispatchEvent(new DataEvent("changeTool", true,false,_n));
		}

	}

}