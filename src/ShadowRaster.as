package
{
	import dl.events.DlEvt;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.events.ContextMenuEvent;
	import flash.ui.*;
	
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class ShadowRaster extends Shadow
	{
		public var b:BitmapData; // = new BitmapData(800, 600);
		private var minib:BitmapData;
		private var brush:Shape = new Shape();
		private var sp:Point;
		private var lm:Matrix = new Matrix();
		
		private var lockedToAxis:String;
		private var step:Number = .2;
		
		public var bm:Bitmap;
		private var hsA:Array = [];
		private var brushBlendMode:String = BlendMode.NORMAL;
		
		private var par:Canvas;///parent refference, to be able to remove listners once removed from stage

		
		public var lastBrushSize:Number = .6;
		public var action:String = "pencil";
		
		/**
		 * Costructor of the ShadowRaster element.
		 *  
		 */
		public function ShadowRaster():void
		{
			hsA.push(addChild(new HotSpot(bonds.left, bonds.top, true)) as HotSpot)
			hsA.push(addChild(new HotSpot(bonds.right, bonds.top, true)) as HotSpot)
			hsA.push(addChild(new HotSpot(bonds.left, bonds.bottom, true)) as HotSpot)
			hsA.push(addChild(new HotSpot(bonds.right, bonds.bottom, true)) as HotSpot)
			
			mkBrush(32 * lastBrushSize, "circle");
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		override public function select():void
		{
			if(parent)parent.setChildIndex(this, this.parent.numChildren - 1)
			
			moveHotspots();
			stage.addEventListener("setupBrush", setupBrush,false);
			var se:DataEvent = new DataEvent("hotspotActive", true, true, "activate");
			if (se)
			{
				for (var i:int = 0; i < 4; i++)
				{
					hsA[i].dispatchEvent(se);
				}
			}
			
		}
		
		
		/**
		 * Why does this even exist?
		 * Should be in the select.
		 */
		public function edit():void
		{
			//maximize();
			//action = "pencil"
			dispatchEvent(new DataEvent("setupBrush", true, true, "pencil"));
			filterScreen.addChild(brush);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mDwn);
			stage.addEventListener(MouseEvent.MOUSE_UP, mUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, bMove);
			stage.addEventListener("setupBrush", setupBrush);
			
		}
		
		override public function deselect():void
		{
			minimize();
			//if(action == "eraser") dispatchEvent(new DataEvent("setupBrush", true, true, "pencil"));
			try
			{
				filterScreen.removeChild(brush);
			}
			catch (er:Error)
			{
				er = null
			}
			par.stage.removeEventListener("changeTool", setupBrush);
			
			var de:DataEvent = new DataEvent("hotspotActive", true, true, "deactivate");
			if (de)
			{
				for (var i:int = 0; i < 4; i++)
				{
					hsA[i].dispatchEvent(de);
				}
			}

			par.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mDwn);
			par.stage.removeEventListener(MouseEvent.MOUSE_UP, mUp);
			par.stage.removeEventListener(MouseEvent.MOUSE_MOVE, bMove);
			par.stage.removeEventListener("setupBrush", setupBrush);
			selected = false;
			
			//mouseEnabled = false;
			
		
		}
		
		public function minimize():void
		{
			var re:Rectangle = b.getColorBoundsRect(0xFFFFFFFF, 0xFF000000, true);
			var temB:BitmapData = b.clone();
			b = new BitmapData(b.width, b.height, true);

			trace("minimize:", re.toString());
			var dx:Number = x - bonds.x;
			var dy:Number = y - bonds.y;
			b.draw(temB, new Matrix(1, 0, 0, 1, dx, dy));
			x = bonds.x;
			y = bonds.y;
			this.graphics.clear();
			this.graphics.lineStyle(0);
			this.graphics.lineTo( -dx, -dy);			
			
			
			
			if (re.width > 0 && re.height > 0)
			{
				try
				{
					filterScreen.removeChild(bm);
				}
				catch (e:Error)
				{
					trace(e);
					e = null;
				}
				trace("minimizing bitmap");
				
				minib = new BitmapData(re.width, re.height, true, 0x0);
				minib.draw(temB, new Matrix(1, 0, 0, 1, -re.x, -re.y));
				
							
				bm.bitmapData = minib;
				//re.x += dx;
				//re.y += dy;
				bm.x = re.x+dx ;
				bm.y = re.y+dy;
				
				filterScreen.addChild(bm);
				moveHotspots();
			}
			else
			{
				trace("removing bitmap");
				
				if (stage) stage.removeEventListener("changeTool", setupBrush);
				
				//deselect();
				//
				
				dispatchEvent(new Event(DlEvt.REMOVE, true));
				
			}
		
		}
		
		private function moveHotspots():void
		{
			var re:Rectangle = b.getColorBoundsRect(0xFFFFFFFF, 0xFF000000, true);
			
			hsA[2].x = hsA[0].x = re.left;
			hsA[1].y = hsA[0].y = re.top;
			
			hsA[3].x = hsA[1].x = re.right;
			hsA[2].y = hsA[3].y = re.bottom;
		
		}
		
		public function maximize():void
		{
			filterScreen.removeChild(bm);
			//var temB:BitmapData = b.clone();
			bm.bitmapData = b;
			//bm.bitmapData.draw(temB, new Matrix(1, 0, 0, 1, 0, 0));
			bm.x = 0;
			bm.y = 0;
			filterScreen.addChild(bm);
		}
		
		public function switchBitmapData(newB:BitmapData):void
		{
			par.removeEventListener(MouseEvent.MOUSE_MOVE, mMov);
			//select();
			b = newB;
			minimize();
			try
			{
				deselect();
				select();
			}
			catch (e:Error)
			{
				trace(e);
				e = null;
			}
		}
		
		private function init(e:Event = null):void
		{
			
			trace("init shadorRaster", parent, (parent is Canvas));
			if(parent is Canvas) this.par = parent as Canvas;
			b = new BitmapData(bonds.width, bonds.height, true, 0x0);
			bm = new Bitmap(b);
			
			filterScreen.addChild(bm);
			addChild(filterScreen);
			sx = 52 / bonds.width;
			sy = 28 / bonds.height
			//m = new Matrix(sx, 0, 0, sy, -bonds.x * sx, -bonds.y * sy)
			m = new Matrix(sx, 0, 0, sy, 0, 0)
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener("setupBrush", setupBrush,false);
			dispatchEvent(new DataEvent("setupBrush", true, true, "pencil"));
			// entry point
			//activatePainting();
			//dispatchEvent(new Event("pushUndo",true));
		
		}
		
		override public function draw(e:Event = null):void
		{
			bitmapData.fillRect(bitmapData.rect, 0xFFFFFF);
			switch (shadowType)
			{
				case "object": 
					opacity = (settingBox.os.opacity)
					break;
				case "evergreen": 
					opacity = (settingBox.es.opacity)
					break;
				case "decidious": 
					opacity = (settingBox.ds.opacity)
					break;
				default: 
			}
			bm.alpha = 0.70 * opacity;
			//bitmapData.draw(b, m,new ColorTransform(1,1,1,opacity));
			bitmapData.draw(b, m);
			
			for (var _y:int = 0; _y < bitmapData.height; _y++)
			{
				for (var _x:int = 0; _x < bitmapData.width; _x++)
				{
					var n:uint = bitmapData.getPixel(_x, _y);
					if (n != 0xFFFFFF)
					{
						if (decidious == true)
						{
							
							var map:uint = (parent as Canvas).calc.leaf.bitmapData.getPixel(_x, _y);
							var o:uint;
							
							if (map == 0xFF0000)
							{
								o = 0xFFFFFF * (1 - settingBox.ds.opacity)
							}
							else if (map == 0x0000FF)
							{
								o = 0xFFFFFF * (1 - settingBox.ls.opacity)
							}
							else
							{
								o = 0xFFFFFF
							}
							
							bitmapData.setPixel(_x, _y, o);
							
						}
						else
						{
							bitmapData.setPixel(_x, _y, 0xFFFFFF * (1 - opacity));
						}
					}
				}
			}
			
			var br:Rectangle = b.getColorBoundsRect(0xffffffff, 0xFF000000, true);
			graphics.clear();
			graphics.beginFill(0xffff00, .0);
			graphics.drawRect(br.x, br.y, br.width, br.height);
			dispatchEvent(new Event(Event.RENDER));
			dispatchEvent(new Event(Event.CHANGE, true));
			//if(stage)stage.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function mDwn(e:MouseEvent):void
		{
			e.stopPropagation();
			dispatchEvent(new Event("pushUndo", true));
			maximize();
			trace('mdwn');
			sp = new Point(mouseX, mouseY);
			lm = new Matrix();
			lm.tx = mouseX;
			lm.ty = mouseY;
			b.draw(brush, lm, null, brushBlendMode);
			if (parent)
				parent.addEventListener(MouseEvent.MOUSE_MOVE, mMov);
				parent.addEventListener(MouseEvent.MOUSE_UP, mUp);
			//stage.addEventListener(Event.EXIT_FRAME, mMov);
		
		}
		
		private function setupBrush(e:DataEvent):void
		{
			
			if(stage)stage.removeEventListener("changeTool", setupBrush);
			trace("setupBrush", e.data, e.target, name);
			if (e.target.hasOwnProperty("value")) {
				lastBrushSize = e.target.value;
			}
			switch (e.data)
			{
				case "pencil": 
					e.stopImmediatePropagation();
					action = e.data;
					mkBrush(lastBrushSize*32, "circle");
					brush.blendMode = BlendMode.NORMAL;
					brushBlendMode = BlendMode.NORMAL;
					if (stage) {
						stage.dispatchEvent(new Event("penCursor"))
						stage.removeEventListener("changeTool", setupBrush);
						
					}
					
					break;
				case "eraser": 
					e.stopImmediatePropagation();
					action = e.data;
					mkBrush(lastBrushSize*32, "rect");
					brush.blendMode = BlendMode.NORMAL;
					brushBlendMode = BlendMode.ERASE;
					if (stage) {
						stage.addEventListener("changeTool", setupBrush, false, 3);
						stage.dispatchEvent(new Event("removeCursor"))
					}

					break;
				default: 
					action = null;
					dispatchEvent(new Event("resetCursor", true));
					if (stage) stage.dispatchEvent(new DataEvent("toolChanged", false, false, e.data));
					break;
			}
			if(stage)stage.dispatchEvent(new DataEvent("toolChanged", false, false, e.data));
			//dispatchEvent(new MouseEvent("selectedShadow", true, true, 0, 0, this));
		}
		
		private function mkBrush(r:Number, s:String):void
		{
			brush.graphics.clear();
			//brush.graphics.lineStyle(0, 0);
			
			switch (s)
			{
				case "circle": 
					brush.graphics.beginFill(0x0, 1);
					brush.graphics.drawCircle(0, 0, 10 + r / 2);
					
					break;
				case "rect": 
					brush.graphics.beginFill(0xFFFFFF, 1);
					brush.graphics.lineStyle(0, 0);
					brush.graphics.drawRect(-10 - r / 2, -10 - r / 2, r + 20, r + 20);
					
				break;
			}

			if (brush.parent)
				brush.parent.setChildIndex(brush, brush.parent.numChildren - 1);
		
		}
		
		private function bMove(e:MouseEvent):void
		{
			
			if (!e.shiftKey == true && !lockedToAxis)
			{
				brush.x = mouseX;
				brush.y = mouseY;
			}
			else
			{
				if (!lockedToAxis)
				{
					if (Math.abs(brush.x - mouseX) > Math.abs(brush.y - mouseY))
					{
						lockedToAxis = "x"; //brush.x = stage.mouseX;
					}
					else
					{
						lockedToAxis = "y"; //brush.y = stage.mouseY;
					}
					stage.addEventListener(KeyboardEvent.KEY_UP, function(ke:KeyboardEvent):void
						{
							if (ke.keyCode == Keyboard.SHIFT)
								lockedToAxis = null;
						});
				}
				else
				{
					switch (lockedToAxis)
					{
						case "x": 
							brush.x = mouseX;
							break;
						case "y": 
							brush.y = mouseY;
							break;
					}
				}
			}
		
		}
		
		private function mUp(e:MouseEvent):void
		{
			trace("ShadowRaster -> mUp");
			if (parent)
				parent.removeEventListener(MouseEvent.MOUSE_MOVE, mMov);
			//stage.removeEventListener(Event.EXIT_FRAME, mMov);
			minimize();
			draw();
			
			if (closed == false) {
				closed = true;
				//dispatchEvent(new MouseEvent("selectedShadow", true, true, 0, 0, this));
				
			}
		
		}
		
		private function mMov(e:MouseEvent):void
		{
			//trace('mmv',this.name);
			var tsp:Point = sp.clone();
			var tlp:Point = new Point(brush.x, brush.y);
			sp = new Point(brush.x, brush.y);
			var dx:Number = tlp.x - tsp.x;
			var dy:Number = tlp.y - tsp.y;
			
			var sx:int = (dx > 0) ? 1 : -1;
			var sy:int = (dy > 0) ? 1 : -1;
			
			lm.tx = tlp.x;
			lm.ty = tlp.y;
			b.draw(brush, lm, null, brushBlendMode, null, true);
			var i:int;
			if (Math.abs(dx) < step && Math.abs(dy) < step)
			{
				
			}
			else
			{
				if (Math.abs(dx) > Math.abs(dy))
				{
					var qy:Number = Math.abs(dy / dx);
					for (i = 0; i < Math.abs(dx) * (1 / step); i++)
					{
						//m = new Matrix();
						lm.tx = tsp.x + sx * i * step;
						lm.ty = tsp.y + sy * i * qy * step;
						b.draw(brush, lm, null, brushBlendMode, null, true);
					}
				}
				else
				{
					var qx:Number = Math.abs(dx / dy);
					for (i = 0; i < Math.abs(dy) * (1 / step); i++)
					{
						//m = new Matrix();
						lm.tx = tsp.x + sx * i * qx * step;
						lm.ty = tsp.y + sy * i * step;
						b.draw(brush, lm, null, brushBlendMode, null, true);
					}
				}
			}
			//trace('stroke: ',dx, dy)
		
		}
	
		override protected function removedFromStage(e:Event):void {
			trace("removed ShadowRaster", this);
			par.removeEventListener(MouseEvent.MOUSE_MOVE, mMov);
			par.stage.removeEventListener("changeTool", setupBrush);
			par.stage.addEventListener("setupBrush", setupBrush);
			//addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			//removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			//removeEventListener("drawEvent", draw);

		}

	}

}