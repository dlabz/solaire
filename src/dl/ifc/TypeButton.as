package dl.ifc 
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class TypeButton extends DlDropButton
	{
		
		public function TypeButton() 
		{
			super(["object", "evergreen", "decidious"]);
			addEventListener(MouseEvent.MOUSE_DOWN, mStop);
		}
		override protected function init(e:Event = null):void {
			stage.addEventListener("typeChanged", typeChanged);
		}
		private function typeChanged(e:DataEvent):void {
			changeIcon(e.data);
		}
		override protected function action(e:MouseEvent):void {
			e.stopPropagation();
			dispatchEvent(new DataEvent("changeType", true,false,_n));
		}
		override protected function mStop(e:MouseEvent):void
		{
			trace("stop");
			e.stopPropagation();
		}

	}

}