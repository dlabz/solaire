package  
{
	import dl.events.CalcEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class InfoBar extends Sprite
	{
		public var bm:Bitmap = new Library.capsule();
		public var t:TextField = new TextField();
		public function InfoBar() 
		{
			bm.width = 990;
			//bm.scaleY = bm.scaleX;
				addChild(bm);
				t.defaultTextFormat = Library.terminatorFormat;
				t.embedFonts = true;
				t.defaultTextFormat.align = TextFormatAlign.JUSTIFY;
				t.height = 25;
				t.width = 880;
				//t.border = true;
				t.x = 50;
				t.y = (this.height -25) / 2;
				addChild(t);
				//x = 20;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(CalcEvent.CHANGE, update);
		}
		private function update(e:CalcEvent):void {
			trace("InfoBar -> update -> " + e);
			//trace("infoBar", e.relatedObject);
			//var c:Calculate = e.relatedObject as Calculate;
		//var te:Number = (e.sum1)/100 * (1-e.percent) *600
		//var se:Number =600/((e.sum2)/100 * (1-e.percent) *600)
		//t.text = "ombre: " + int(100 - e.sum1)+ "%       orientation: " + int(e.percent*100) + "%       energie: " + Math.round(te) + " KWh/m2/yr       design: " + se.toPrecision(3) ;
		t.text = "ombre: " + int(e.shadow) + "%       orientation: " + int(100 * e.orientation ) + "%       energie: " + Math.round(e.energy) + " KWh/m2/yr       design: " + e.design.toPrecision(3) ;
		}
		
	}

}