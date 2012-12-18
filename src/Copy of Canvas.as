package
{
	import adobe.utils.CustomActions;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.ui.Keyboard;
	
	/**
	 * This class is the canvas. All drawn shapes reside on it.
	 * 
	 * ...
	 * @author Petrovic Veljko
	 * 
	 *
	 */
	public class Canvas extends Sprite
	{
		
		public var r:Rectangle = new Rectangle(48, 8, 823, 608);///Holds stuff
		
		
		public var shapes:Array = [];
		public var calc:Calculate = new Calculate();
		public var undo:UndoQueue;
		
		public var _selected:Shadow = null;
		public var currentAction:String = "select";
		public var settingBox:SettingBox;
		
		private var listeningShape:Sprite = new Sprite();
		public function Canvas()
		{
			var _r:Graphics = listeningShape.graphics;
			_r.beginFill(1, 0);
			_r.drawRect(r.x, r.y, r.width, r.height);
			
			addChild(listeningShape);
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event = null):void
		{
			undo = new UndoQueue(shapes, this);
			calc.par = stage;
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//this.graphics.lineStyle(0, 0xff0000);
			//this.graphics.drawRect(r.left, r.top, r.width, r.height);
			
			//addEventListener(MouseEvent.MOUSE_DOWN, deselectShape);
			
			addEventListener("deleteShape", deleteShape);
			stage.addEventListener(Event.RENDER, refresh);
			//testing
			//startDrawing();
			stage.addEventListener("percentChange", percentChange);
			stage.addEventListener("pushUndo", undo.pushUndo);
			stage.addEventListener("popUndo", undo.popUndo);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, kDown);
			
			//addEventListener(MouseEvent.MOUSE_DOWN, mDown);
			//addEventListener(MouseEvent.MOUSE_UP, mDown);
			//addEventListener(MouseEvent.CLICK, mDown);
			
		}
		public function get selected():Shadow {
			return _selected
		}
		public function set selected(s:Shadow):void {
			
			_selected = s;
			dispatchEvent(new MouseEvent("selectedShadow", true, true, 0, 0, _selected));
		}
		private function kDown(e:KeyboardEvent):void
		{
			trace("kUndo", e.keyCode)
			if (e.ctrlKey && e.keyCode == 90)
			{
				trace("!undo!");
				undo.popUndo(e);
			}
			
			if (selected && e.keyCode == Keyboard.DELETE)
			{
				selected.dispatchEvent(new Event("pushUndo", true))
				selected.dispatchEvent(new MouseEvent("deleteShape", true, false, 0, 0, selected));
				dispatchEvent(new DataEvent("changeTool", true, false, "arrow"));

			}
			
			if (e.keyCode == Keyboard.ESCAPE) {
				//TODO: fix escape
				
				if (selected && selected.closed == false) {
					removeShape(selected); 
				}else if (selected) {
					selected.deselect();
					selected = null;
					//newShape = null;
				}
				
				//if(selected)selected.dispatchEvent(new MouseEvent("deleteShape", true, false, 0, 0, this));
				
				dispatchEvent(new DataEvent("changeTool", true, false, "arrow"));

				//dispatchEvent(new DataEvent("stealthSwitch", true, false, "arrow"));
			}
		}
		
		private function percentChange(e:DataEvent):void
		{
			//trace("percentChange", parseFloat(e.data));
			calc.percent = parseFloat(e.data);
			stage.dispatchEvent(new Event(Event.RENDER));
		}
		
		private function eSelectShape(e:MouseEvent):void
		{
			
			trace("select: ", e.target);
			e.stopPropagation();
			if (e.target is Shadow) {
				
				selectShape(e.target as Shadow);
				//selected.dispatchEvent(new DataEvent("selectedShadow", true, true));
			}else if(e.target is Canvas){
				deselectShape();
				//dispatchEvent(new DataEvent("selectedShadow", true, true));
			}
			
		}
		
		private function selectShape(_s:Shadow):void
		{
			
			if (_s)
			{
				trace("select: ", _s, _s.shadowType);
				//var _s:Shadow = e.target as Shadow;
				if (selected && _s != selected)	deselectShape();
				trace("Main:select");
				_s.select();
				
				selected = _s;
				//selected.dispatchEvent(new MouseEvent("selectedShadow", true, true));
					//(parent as Tool).db.type.active = true;
			}
		}
		/**
		 * Deselects the currently selected shape.
		 * Can be invoked by an event.
		 * 
		 * @param	e Event, triggering the function. Has no function. Propagation is being stopped.
		 */
		public function deselectShape(e:Event = null):void
		{
			
			if (e)
				e.stopPropagation();
			trace("Main:deselect. Num Shapes:", shapes.length);
			//TODO: Y U NO DESELECT!
			//for (var i:int = 0; i < shapes.length; i++)
			//{
				//shapes[i].deselect();
			//}
			if (selected)
			{
				trace(selected, "is selected");
				if (!(selected.closed == true))
				{
					trace("dbg:delete")
					selected.dispatchEvent(new Event("deleteShape", true));
					selected = null
				}
				else
				{
					trace("dbg:deselect")
					selected.deselect();
					//selected.filters = [];
					selected = null;
					removeEventListener(MouseEvent.MOUSE_DOWN, deselectShape)
				}
				
				dispatchEvent(new DataEvent("changeTool", true, false, "arrow"));
			}
			
			//(parent as Tool).db.type.active = false;	
			stage.dispatchEvent(new Event("resetCursor"))

		}
		
		private function deleteShape(e:Event):void
		{
			var _d:Shadow = e.target as Shadow;
			_d.dispatchEvent(new Event("pushUndo", true))
			removeShape(_d);
		}
		
		public function removeShape(_d:Shadow):void
		{
			_d.deselect();
			shapes.splice(shapes.indexOf(_d), 1);
			dispatchEvent(new Event(Event.CHANGE, true));

			_d.removeEventListener("drawEvent", _d.draw);
			removeChild(_d);
			if (selected == _d)
			{
				selected = null;
			}
			//refresh();
			//dispatchEvent(new Event(Event.CHANGE, true));
			dispatchEvent(new DataEvent("changeTool", true, false, "arrow"));
		}
		
		/**
		 * Strats painting on the event. Might be redundant.
		 * 
		 */
		public function startPainting():void
		{
			if (currentAction == "drawing" && selected && selected.closed == false)
			{
				selected.dispatchEvent(new Event("deleteShape", true));
				
			}
			currentAction = "painting";
			if (!(selected is ShadowRaster)) {
				deselectShape();
			}
			if (!selected)
			{
				selected = new ShadowRaster();
				selected.bonds = r;
				selected.settingBox = settingBox;
				selected.x = r.x;
				selected.y = r.y;
				shapes.push(selected);
				//selected.dispatchEvent(new DataEvent("selectedShadow", true, true));
				addChild(selected);
					//newDrawing.select();
			}
			else
			{
				//newDrawing = selected as ShadowRaster;
				
			}
			//selectShape(newDrawing);
			(selected as ShadowRaster).edit();
			//stage.dispatchEvent(new Event("penCursor"))
			//if (stage)
				//stage.dispatchEvent(new DataEvent("stealthSwitchType", true, false, newDrawing.shadowType));
		}
		
		
		/**
		 * stops painting. Might be redundant.
		 * 
		 */
		public function endPainting():void
		{
			trace("Tool: end painting");
			//stage.dispatchEvent(new Event("resetCursor"))
			//if(newDrawing){
			if (selected)
				selected.deselect();
			//newDrawing.mouseEnabled = false;
			//newDrawing.
			selected = null;
			//dispatchEvent(new DataEvent("selectedShadow", true, true));

			//}
		}
		
		public function startDrawing():void
		{
			if (currentAction == "drawing" && selected && selected.closed == false)
			{
				selected.dispatchEvent(new Event("deleteShape", true));
				
			}
			currentAction = "drawing";
			trace("new shape started")
			if (!(selected is ShadowShape)) {
				deselectShape();
			}
			if (!selected)
			{
			selected = new ShadowShape();
			
			selected.bonds = r;
			selected.settingBox = settingBox;
			//if (stage)
				//stage.dispatchEvent(new DataEvent("stealthSwitchType", true, false, newShape.shadowType));
			selected.mouseEnabled = false;
			
			shapes.push(selected);

			addChild(selected);
			selected.select();
			}
			//selectShape(newShape);
			//stage.dispatchEvent(new Event("penCursor"))
			//stage.addEventListener(MouseEvent.CLICK, addPoint);
		}
		
		public function endDrawing():void
		{
			//stage.dispatchEvent(new Event("resetCursor"))
			if (selected) {
				//selected.mouseEnabled = true;
				//selected.deselect();
				selected = null;
			}
			//currentAction = "selecting";
			
			;
			//dispatchEvent(new DataEvent("listenSwitch", true, true, "arrow"));
		}
		
		public function startSelecting():void
		{
			if (currentAction == "drawing" && selected.closed == false)
			{
				selected.dispatchEvent(new Event("deleteShape", true));
				
			}
			currentAction = "selecting"
			addEventListener(MouseEvent.MOUSE_DOWN, eSelectShape);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, deselectShape);
		}
		
		public function endSelecting():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, eSelectShape);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, deselectShape);
			//addEventListener(MouseEvent.MOUSE_DOWN, deselectShape);
		}
		
		public function refresh(e:Event = null):void
		{
			trace("refresh:", shapes.length);
			for (var i:int = 0; i < shapes.length; i++)
			{
				shapes[i].draw();
			}
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		
		
	}

}