package
{
	import adobe.utils.CustomActions;
	import dl.events.OrientationEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.ui.Keyboard;
	import dl.events.DlEvt;
	
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
		
		public var r:Rectangle = new Rectangle(48, 8, 823, 608); ///Holds stuff
		
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
			calc.addListeners();
			//debug
			var b:Bitmap = new Bitmap(calc.m);
			addChild(b);
			b.x = r.x;
			b.y = r.y;
			b.width = r.width;
			b.height = r.height;
			b.alpha = .3;
			//end debug
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(DlEvt.SELECT, selectShape);
			
			addEventListener(DlEvt.DELETE, deleteShape);
			addEventListener(DlEvt.REMOVE, eRemoveShape); //TODO: fix references
			
			stage.addEventListener(Event.RENDER, refresh);
			stage.addEventListener(DlEvt.PERCENT, percentChange);
			stage.addEventListener(DlEvt.UNDO_PUSH, undo.pushUndo);
			stage.addEventListener(DlEvt.UNDO_POP, undo.popUndo);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, kDown);
			
			
		}
		
		/**
		 * wrapper, to match the setter.
		 */
		public function get selected():Shadow
		{
			return _selected
		}
		
		/**
		 * wrapper, so that I could fire event on set.
		 */
		public function set selected(s:Shadow):void
		{
			if (selected) //&& !s
				selected.deselect();
			
			if(!(selected && s && selected == s)) _selected = s;
			
			if (s && !s.selected)
				s.select();
			
			if(selected)stage.dispatchEvent(new DataEvent("typeChanged", true, false, selected.shadowType));
			//	stage.dispatchEvent(new DataEvent("typeChanged", true, false, s.shadowType));
			stage.dispatchEvent(new MouseEvent(DlEvt.SELECTED, true, true, 0, 0, _selected)); ///updates the type toolbox(SelectedBox)
		}
		
		private function selectShape(e:Event):void
		{
			trace("Canvas -> selectShape", e.target);
			
			e.stopPropagation();
			if (e.target is Shadow)
			{
				
				if ((e.target as Shadow) != selected) {
					selected = (e.target as Shadow);
				}else {
					trace("Canvas -> startDrag", e.target);
					stage.dispatchEvent(new Event(DlEvt.CURSOR_HG));
					var s:Shadow = e.target as Shadow;
					(e.target as Sprite).addEventListener(
						MouseEvent.MOUSE_UP, 
						function (e:Event):void { 
							e.target.stopDrag(); 
							if (e.target is ShadowShape) {
								var ss:ShadowShape = (e.target as ShadowShape);
							
								for (var i:int = 0; i < ss.points.length; i++) {
									var p:HotSpot = ss.points[i]
									//trace ("moving: " + i + "at:" + p.x + "/" + p.y);
									p.x += ss.x;
									p.y += ss.y;
									p.alpha = 1;
									//trace ("done: " + i + "at:" + p.x + "/" + p.y);
								}
								//trace ("moving: " + ss + "at:" + ss.x + "/" + ss.y);
								ss.x = ss.y = 0;
								trace ("done: " + ss + "at:" + ss.x + "/" + ss.y);
								ss.draw();
							}
							s.draw();
						}
				 
					);
					
					s.dispatchEvent(new Event(DlEvt.UNDO_PUSH, true));
					s.startDrag();
				}
				
			}
			else // if (e.target is Canvas)
			{
				selected = null;
				
			}
		
		}
		
		private function deleteShape(e:Event):void
		{
			trace("Canvas -> deleteShape", e.target);
			var _d:Shadow = e.target as Shadow;
			_d.dispatchEvent(new Event(DlEvt.UNDO_PUSH, true))
			removeShape(_d);
		}
		
		private function eRemoveShape(e:Event):void
		{
			trace("Canvas -> eRemoveShape", e.target);
			var _d:Shadow = e.target as Shadow;			
			removeShape(_d);
			undo.removeInstancesOf(_d);
			stage.dispatchEvent(new Event(DlEvt.CURSOR_RESET));
		}
		
		public function removeShape(_d:Shadow):void
		{
			trace("Canvas -> removeShape");
			if (_d.parent)
			{
				//if (selected == _d)
				//	selected = null;
				
				if (_d.parent)
					removeChild(_d);
				
				shapes.splice(shapes.indexOf(_d), 1);
				_d.removeEventListener(DlEvt.DRAW, _d.draw);
				dispatchEvent(new Event(Event.CHANGE, true));
					//dispatchEvent(new DataEvent(DlEvt.TOOL, true, false, "arrow"));
					
					//if (selected == _d)
				//	selected = null;
			}
			
		}
		
		/**
		 * Strats painting on the event. Might be redundant.
		 *
		 */
		public function startPainting():void
		{
			trace("Canvas -> startPainting");
			if (currentAction == "drawing" && selected && selected.closed == false)
			{
				selected.dispatchEvent(new Event(DlEvt.REMOVE, true));
			}
			
			if (!(selected is ShadowRaster)|| selected.stage == null)
			{
				selected = null;
				
			}
			if (!selected)
			{
				var _s:ShadowRaster = new ShadowRaster();
				_s.bonds = r;
				_s.settingBox = settingBox;
				_s.x = r.x;
				_s.y = r.y;
				shapes.push(_s);
				addChild(_s);
				selected = _s;
				
			}
			
			(selected as ShadowRaster).edit();
			if (currentAction == "painting")
				trace("BUG!!!");
			currentAction = "painting";
		}
		
		/**
		 * stops painting. Might be redundant.
		 *
		 */
		public function endPainting():void
		{
			trace("Canvas -> endPainting");
			if (selected)
				selected.deselect();
			selected = null;
			currentAction = null;
		}
		
		public function startDrawing():void
		{
			trace("Canvas -> startDrawing");
			if (currentAction == "drawing" && selected && selected.closed == false)
			{
				selected.dispatchEvent(new Event(DlEvt.REMOVE, true));
			}
			if (!(selected is ShadowShape) || selected.stage == null )
			{
				selected = null;
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
			
			if (currentAction == "drawing")
				trace("BUG!!!");
			currentAction = "drawing";
		
		}
		
		public function endDrawing():void
		{
			trace("Canvas -> endDrawing");
			if (selected)
			{
				
				selected = null;
			}
			currentAction = null;
		}
		
		public function startSelecting():void
		{
			trace("Canvas -> startSelecting");
			if (currentAction == "drawing" && selected.closed == false)
			{
				selected.dispatchEvent(new Event(DlEvt.REMOVE, true));
			}
			if (selected)
			{
				
				selected = null;
			}
			addEventListener(MouseEvent.MOUSE_DOWN, selectShape);
			
			if (currentAction == "selecting")
				trace("BUG!!!")
			currentAction = "selecting";
		}
		
		public function endSelecting():void
		{
			trace("Canvas -> endSelecting");
			removeEventListener(MouseEvent.MOUSE_DOWN, selectShape);
			currentAction = null;
		}
		
		private function percentChange(e:OrientationEvent):void
		{
			//trace("percentChange", parseFloat(e.data));
			calc.orientation = e.orientation;
			stage.dispatchEvent(new Event(Event.RENDER));
		}
		
		/**
		 * Refreshes all shapes by calling draw() on each
		 * @param	e Can be invoked by event.
		 */
		public function refresh(e:Event = null):void
		{
			trace("refresh:", shapes.length);
			for (var i:int = 0; i < shapes.length; i++)
			{
				shapes[i].draw();
			}
			dispatchEvent(new Event(Event.CHANGE, true));
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
				selected.dispatchEvent(new Event(DlEvt.UNDO_PUSH, true))
				selected.dispatchEvent(new MouseEvent(DlEvt.DELETE, true, false, 0, 0, selected));
				dispatchEvent(new DataEvent(DlEvt.TOOL, true, false, "arrow"));
				
			}
			
			if (e.keyCode == Keyboard.ESCAPE)
			{
				//TODO: fix escape
				
				if (selected && selected.closed == false)
				{
					removeShape(selected);
				}
				else if (selected)
				{
					
					selected = null;
						//newShape = null;
				}
				
				//if(selected)selected.dispatchEvent(new MouseEvent("deleteShape", true, false, 0, 0, this));
				
				dispatchEvent(new DataEvent(DlEvt.TOOL, true, false, "arrow"));
				
					//dispatchEvent(new DataEvent("stealthSwitch", true, false, "arrow"));
			}
		}
	
	}

}