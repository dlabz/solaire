package dl.ifc 
{
	import flash.events.Event;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class DlPencil extends DlButton
	{
		
		public function DlPencil() 
		{
			super(["pencil"]);
		}
		override protected function action(e:MouseEvent):void {
			trace("action", _n);
			e.stopPropagation();
			stage.dispatchEvent(new Event("removeCursor"))
			dispatchEvent(new DataEvent("changeTool", true,false,_n));
		}

	}

}