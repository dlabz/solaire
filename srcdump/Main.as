package 
{
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.*;
	import Library;
	
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class Main extends Sprite 
	{
		public var r:Rectangle = new Rectangle(40, 8, 675, 495);
		//public var sh:ShadowShape = new ShadowShape([new HotSpot(250,50),new HotSpot(500,50),new HotSpot(500,200),new HotSpot(250,200)]);
		//public var sh2:ShadowShape = new ShadowShape([new HotSpot(50,50),new HotSpot(200,50),new HotSpot(200,200),new HotSpot(50,200)]);
		public var shapes:Array = [];
		public var calc:Calculate = new Calculate();
		
		public var cC:CustomCursor = new CustomCursor();
		
		public var newShape:ShadowShape = null;
		public var newDrawing:ShadowRaster = null;
		public var selected:Shadow = null;
		//public var toolbar:ToolBox = new ToolBox();
		public var currentAction:String = "select";
		public function Main():void 
		{
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			//addChild(toolbar);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addChild(cC);
			this.graphics.lineStyle(0, 0xff0000);
			this.graphics.drawRect(r.left, r.top, r.width, r.height);
			
			//addChild(sh);
			//sh2.opacity = .5;
			//sh2.draw();
			//addChild(sh2);
			addEventListener(Event.CLEAR, deselectShape);
			addEventListener("deleteShape", deleteShape);
			
			//testing
			//var sr:ShadowRaster = new ShadowRaster();
			//sr.bonds = r;
			//sr.x = r.x;
			//sr.y = r.y;
			//shapes.push(sr);
			//addChild(sr);
			//startPainting();
			
		}
		private function deleteShape(e:Event):void {
			var _d:Shadow = e.target as Shadow;
			shapes.splice(shapes.indexOf(_d), 1);
			_d.removeEventListener("drawEvent", _d.draw);
			removeChild(_d);
			if (selected == _d) {
				selected = null;
			}
			_d = null;
		}
		public function startDrawing():void {
			currentAction = "drawing";
			trace("new shape started")
			newShape = new ShadowShape();
					
			newShape.bonds = r;
			newShape.mouseEnabled = false;
			addChild(newShape);
					
					
			selectShape(newShape);
			stage.addEventListener(MouseEvent.CLICK, addPoint);
		}
		public function endDrawing():void {
			newShape.deselect();
			newShape = null;
			//currentAction = "selecting";
			//newShape.mouseEnabled = true;;
			//dispatchEvent(new DataEvent("listenSwitch", true, true, "arrow"));
		}
		public function startPainting():void {
			currentAction = "painting";
			if(!newDrawing){
				newDrawing = new ShadowRaster();
				newDrawing.bonds = r;
				newDrawing.x = r.x;
				newDrawing.y = r.y;
				shapes.push(newDrawing);
				addChild(newDrawing);
			}
			newDrawing.select();
		}
		public function endPainting():void {
			trace("Tool: end painting");
			newDrawing.deselect();
			newDrawing.mouseEnabled = false;
		}
		private function addPoint(e:MouseEvent):void {
			e.stopPropagation();
			if (newShape) {
				
				
				newShape.pushHotspot(new HotSpot(mouseX, mouseY));
				if(newShape.points.length > 3) newShape.points[newShape.points.length - 2].removeEventListener(MouseEvent.CLICK, closeShape);
				
				if(newShape.points.length > 2)newShape.points[newShape.points.length - 1].addEventListener(MouseEvent.CLICK, closeShape);
				
				newShape.draw();
				if (newShape.points.length > 2) newShape.points[0].addEventListener(MouseEvent.MOUSE_DOWN, closeShape);
			}
		}
		private function closeShape(e:MouseEvent):void {
			var axe:Object = {}
			if (Math.round(newShape.points[0].x) == 0) { axe.start = 0; newShape.points[0].x = 0; }
			if (Math.round(newShape.points[newShape.points.length - 1].x) == 0){ axe.end = 0;newShape.points[newShape.points.length - 1].x = 0}
			
			newShape.points[0].removeEventListener(MouseEvent.MOUSE_DOWN, closeShape);
			newShape.points[newShape.points.length - 1].removeEventListener(MouseEvent.CLICK, closeShape);
			newShape.closed = true;
			
			shapes.push(newShape);
			//toolbar.connectShape(newShape);
			newShape.addEventListener(MouseEvent.MOUSE_DOWN, eSelectShape);
			newShape.dispatchEvent(new Event("addShapeToCalc"));
			
			//selectShape(newShape);
			newShape = null;
			dispatchEvent(new Event(Event.CHANGE, true));
			dispatchEvent(new DataEvent("switchTool", true, false, "arrow"));
			stage.dispatchEvent(new DataEvent("stealthSwitch", true, false, "arrow"));
		
		}
		private function eSelectShape(e:MouseEvent):void {
			selectShape(e.target as Shadow);
		}
		private function selectShape(_s:Shadow):void {
			
			//var _s:Shadow = e.target as Shadow;
			if (selected && _s != selected) deselectShape();
			trace("Main:select");
			_s.select();
			selected = _s;
			//toolbar.connectShape(_s);
				
			_s.filters = [new DropShadowFilter()];
			
			//_s.dispatchEvent(new MouseEvent("connectToolbar", true, false, null, null, _s));
			
		}
		private function deselectShape(e:Event = null):void {
			trace("Main:deselect");
			for (var i:int = 0; i < shapes.length; i++) 
				{
					shapes[i].deselect();
				}
			if (selected) {
				if (!selected.closed == true) {
					
					selected.dispatchEvent(new Event("deleteShape", true));
					selected = null
				}else{
				
				
				selected.deselect();
				selected.filters = [];
				selected = null;
				removeEventListener(MouseEvent.MOUSE_DOWN,deselectShape)
				}
			}
		}
		private function connectToolbar(e:MouseEvent):void {
			
		}
	}
	
}