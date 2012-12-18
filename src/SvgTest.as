package  
{
	import com.lorentz.SVG.display.base.SVGElement;
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.events.SVGEvent;
	import flash.display.Sprite;
	import com.lorentz.processing.ProcessExecutor;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class SvgTest extends Sprite
	{
		public var svg:SVGDocument = new SVGDocument();
		public function SvgTest() 
		{
			ProcessExecutor.instance.initialize(stage);
			
			svg.addEventListener(SVGEvent.PARSE_COMPLETE, parseComplete);
			svg.load("cleanSummer.svg");
			
		}
		private function parseComplete(e:SVGEvent):void {
			//trace(svg.numChildren);
			//trace(svg.numElements);
			stage.addEventListener(MouseEvent.CLICK, clicked);
			svg.y = -stage.stageHeight/2;
			svg.x = stage.stageWidth/2;
			addChild(svg);
		}
		private function clicked(e:MouseEvent):void {
			trace(e.target.name);		}
		
	}

}