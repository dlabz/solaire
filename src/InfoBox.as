package  
{
	import flash.display.Sprite;
	import flash.events.DataEvent;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class InfoBox extends Sprite
	{
		private var b:ButtonDrop = new ButtonDrop(["object", "evergreen", "decidious"]);
		private var es:Slider = new Slider(100, 32, "evergreen");
		
		private var ds:Slider = new Slider(100, 32, "decidious");
		private var ls:Slider = new Slider(100, 32, "leaffree");
		public function InfoBox() 
		{
			b.addEventListener("buttonDrop", switchType);
			addChild(b);
		}
		private function switchType(e:DataEvent):void {
			while (numChildren > 0) removeChildAt(0);
			addChild(b);
			switch (e.data) 
			{
				case "object":
				break;
				case "evergreen":
					es.x = b.width;
					addChild(es);
				break;
				case "decidious":
					ds.x = b.width;
					addChild(ds);
					ls.x = b.width + ds.width;
					addChild(ls);
				break;
				
			}
		}
	}

}