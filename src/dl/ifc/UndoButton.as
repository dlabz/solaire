package dl.ifc 
{
	import flash.events.MouseEvent;
	import flash.events.DataEvent;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class UndoButton extends DlButton
	{
		
		public function UndoButton() 
		{
			super(["undo"])
			addEventListener(MouseEvent.CLICK, mStop);

		}
		override protected function action(e:MouseEvent):void {
			e.stopPropagation();
			dispatchEvent(new DataEvent("undoEvent", true,false,_n));

		}
	}

}