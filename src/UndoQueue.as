package
{
	import dl.ifc.DlButton;
	import dl.ifc.UndoButton;
	import dl.events.DlEvt;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.*;
	
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class UndoQueue
	{
		//{target:Shadow;data:*}
		
		public var queue:Array = [];
		private var shapes:Array;
		private var canvas:Canvas;
		public var button:UndoButton;
		
		public function UndoQueue(s:Array, c:Canvas)
		{
			shapes = s;
			canvas = c;
		}
		
		public function pushUndo(e:Event):void
		{
			trace("pushUndo", e.target, e.cancelable);
			var o:Object = {};
			o.target = e.target;
			o.parent = e.target.parent;
			if (o.target is ShadowShape)
			{
				o.data = (e.target as ShadowShape).points.concat();
				
			}
			else if (o.target is ShadowRaster)
			{
				
				o.data = ((e.target as ShadowRaster).b as BitmapData).clone()
				if ((e.target as ShadowRaster).closed == false)
					o.remove = true;
				
			}
			else if (o.target is HotSpot)
			{
				o.data = {"x": o.target.x, "y": o.target.y}
				
			}
			else if (o.target is Panel)
			{
				o.data = {"x": o.target.x}
				
			}
			queue.push(o);
			if (button && queue.length > 0)
			{
				button.mouseEnabled = true;
				button.filters = []
			}
		}
		
		public function popUndo(e:Event = null):void
		{
			
			if (queue.length > 0)
			{
				//canvas.startSelecting();
				var o:Object = queue.pop();
				trace("popUno!!", o.target);
				if (!o.target.parent && o.target is Shadow)
				{
					shapes.push(o.target);
					o.parent.addChild(o.target);
						//if(o.target is Shadow){ (o.target as Shadow).addEventListener("drawEvent", (o.target as Shadow).draw);}
				}
				if (o.target is ShadowShape)
				{
					var t:ShadowShape = o.target as ShadowShape
					if (o.data.length > 0)
					{
						//canvas.selected = t;
						if (canvas.selected != t) {
							
							canvas.selected = t;
							canvas.dispatchEvent(new DataEvent(DlEvt.TOOL, true, false, "pen"));
							
						}
							
							
						
						t.switchPoints(o.data);
						
						if (t.points.length <= 3)
						{
							t.openShape();
							t.points[0].addEventListener(MouseEvent.MOUSE_DOWN, t.closeShape, false, 1);
							t.points[t.points.length-1].addEventListener(MouseEvent.MOUSE_DOWN, t.closeShape,false,1);
							//canvas.addEventListener(MouseEvent.CLICK, t.addHotspot);
						}
						
						t.draw();
						
							//canvas.dispatchEvent(new DataEvent(DlEvt.TOOL, true, false, "pen"));
					}
					else
					{
						trace("undo removes" + t);
						t.dispatchEvent(new MouseEvent(DlEvt.REMOVE, true, false, 0, 0, t));
						
						canvas.selected = null;
						canvas.dispatchEvent(new DataEvent(DlEvt.TOOL, true, false, "arrow"));
						
					}
					
				}
				else if (o.target is ShadowRaster)
				{
					trace("closed:", o.target.closed);
					var _r:ShadowRaster = o.target as ShadowRaster
					if (!o.remove)
					{
						_r.switchBitmapData(o.data);
						//(o.target as ShadowRaster).draw();
						canvas.selected = _r;
						
						canvas.dispatchEvent(new DataEvent("switchTool", true, false, "pencil"));
						_r.draw();
					}
					else
					{
						trace("undo removes" + _r);
						canvas.selected = null;
						_r.dispatchEvent(new MouseEvent(DlEvt.REMOVE, true, false, 0, 0, _r));
						canvas.dispatchEvent(new DataEvent("switchTool", true, false, "arrow"));
						
					}
					
				}
				else if (o.target is HotSpot)
				{
					o.target.x = o.data.x;
					o.target.y = o.data.y;
					if (o.target.parent)
						o.target.parent.draw();
				}
				else if (o.target is Panel)
				{
					o.target.x = o.data.x;
					(o.target as Panel).mMove();
				}
				o.target.dispatchEvent(new Event(Event.CHANGE, true));
				//o.target.dispatchEvent(new Event(Event.RENDER));
				o = null;
				
				if (button && queue.length < 1)
				{
					trace("undo: deactivate button");
					button.mouseEnabled = false;
					button.filters = [dBW.BW()]
				}
				
			}
		}
		public function removeInstancesOf(_s:Shadow):void {
			for (var i:int = queue.length - 1; i > -1; i--) 
			{
				if (queue[i].target == _s) {
					queue.splice(i, 1);
				}
			}
			if (button && queue.length < 1)
				{
					trace("undo: deactivate button");
					button.mouseEnabled = false;
					button.filters = [dBW.BW()]
				}
		}
	}

}