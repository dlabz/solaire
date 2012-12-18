package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.ui.*;
	import Shadow;
	import dl.events.DlEvt;
	
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	
	 //TODO: fix calc error on delete
	 //TODO: fix undo errors
	 //TODO: error on close shape: deactivate type button
	 //TODO: organize this mess

	public class ShadowShape extends Shadow
	{
		public static const snapTo:uint = 5;
		public var points:Vector.<HotSpot> = new <HotSpot>[];
		private var g:Graphics;
		private var afterIndex:int = -1;
		
		private var par:Canvas;///parent refference, to be able to remove listners once removed from stage

		
		public var theShadow:Shape = new Shape();
		private var lock:Boolean = false;
		private var keys:Object = { };
		
		private var cX:Number =0;
		private var cY:Number =0;
		public function ShadowShape() 
		{
			super();
			
			
			g = theShadow.graphics;
			//filterScreen is used to visualize a shadow type
			filterScreen.addChild(theShadow);
			addChild(filterScreen);
			
			
			addEventListener(DlEvt.SHAPE_AFTER_THIS, setAfterThis);///finds between which to points to add a new one
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			
			
		}
		/**
		 * Once it has been added to stage, create all needed listeners.
		 * 
		 * @param	e
		 */
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if(parent is Canvas) this.par = parent as Canvas;

			sx = 52 / bonds.width;
			sy = 28 / bonds.height;
			m = new Matrix(sx, 0, 0, sy, -bonds.x * sx, -bonds.y * sy);
			//dispatchEvent(new Event("pushUndo",true))
			
			
			parent.addEventListener(MouseEvent.MOUSE_DOWN, clickHotspot);///listens if user has clicked on canvas, so hotspot can be added
			//addEventListener(MouseEvent.MOUSE_UP, mUp);
			
			addEventListener(Event.ENTER_FRAME, mMov);///follow mouse with line
			
			addEventListener(Event.ENTER_FRAME, eF);

			stage.addEventListener(KeyboardEvent.KEY_UP, kUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, kDown);
			addEventListener(DlEvt.DRAW, draw);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		/**
		 * switches the points array with the one provided.
		 * @param	v New array of points that define the ShadowShape
		 */
		public function switchPoints(v:Vector.<HotSpot>):void {
			trace("switching " + v.length + " hotspots");
			for (var i:int = 0; i < points.length; i++) 
				{
					if(points[i].parent)removeChild(points[i]);
					
				}
			
				points = v.concat();
				
				for (var j:int = 0; j < points.length; j++) 
				{
					addChild(points[j]);
				}
				
				//if (points.length < 3) {
					//closed = false;
					//(parent as Canvas).startDrawing();
				//}
		}

		override public function select():void {
			trace(this + ": select");
			//dispatchEvent(new Event(Event.CLEAR, true, true));
			this.selected = true;
			//(this.parent as Canvas).selected = this;
			var se:DataEvent = new DataEvent("hotspotActive", true, true, "activate");
			if (se) {
				for (var i:int = 0; i < points.length; i++) 
				{
					points[i].dispatchEvent(se);
				}
			}
			
			if (stage && closed == false) parent.addEventListener(MouseEvent.CLICK, addHotspot);
			addEventListener(Event.ENTER_FRAME, eF);
			addEventListener(Event.ENTER_FRAME, mMov);///follow mouse with line

			
			//if (stage) stage.dispatchEvent(new DataEvent("typeChanged", true, false, this.shadowType));

			if (stage)stage.addEventListener(KeyboardEvent.KEY_UP, kUp);
			if (stage) stage.addEventListener(KeyboardEvent.KEY_DOWN, kDown);
			draw();
		}
		override protected function deleteShape(e:Event = null):void {
			 
			for (var i:int = 0; i < points.length; i++) 
			{
				var _p:HotSpot = points[i];
				_p.parent.removeChild(_p);
			}
		
			dispatchEvent(new MouseEvent(DlEvt.DELETE, true, false, mouseX, mouseY, this));
			
		}
		
		
		override public function deselect():void {
			trace("SadowShape -> deselect");
			trace(this + ": deselect");
			
			removeEventListener(Event.ENTER_FRAME, eF);
			
			par.removeEventListener(MouseEvent.CLICK, addHotspot);
			par.removeEventListener(MouseEvent.MOUSE_DOWN, clickHotspot);
			
			
			
			var de:DataEvent = new DataEvent("hotspotActive", true, true, "deactivate");
			if (de) {
				for (var i:int = 0; i < points.length; i++) 
				{
					points[i].dispatchEvent(de);
				}
			}
			
			//par.removeEventListener(MouseEvent.CLICK, addPoint);
			//par.removeEventListener(MouseEvent.CLICK, clickHotspot);
			if (stage)stage.removeEventListener(KeyboardEvent.KEY_UP, kUp);
			if (stage) stage.removeEventListener(KeyboardEvent.KEY_DOWN, kDown);
			//par.removeEventListener(Event.ENTER_FRAME, mMov);///follow mouse with line
			//if (stage) stage.dispatchEvent(new DataEvent("typeChanged", true, false, this.shadowType));
			//this.selected = false;
			
			mouseEnabled = true;
			if (!closed) {
				closeShape();
			}
			
			//if (parent) {
				//(this.parent as Canvas).selected = null;
				//((this.parent as Canvas).parent as Tool).db.b2.filters = [dBW.BW()];
			//}
			selected = false;
		}

		private function mUp(e:MouseEvent):void {
			e.stopPropagation();
			this.parent.setChildIndex(this, parent.numChildren-1);
		}
		private function mMov(e:Event):void {
			e.stopPropagation();
			if (!closed && stage)
				draw();
			if (closed)
				removeEventListener(Event.ENTER_FRAME, mMov);
		}
		
		/**
		 * This draws event to the calculation bitmap. 
		 * 
		 * @param	e Can be invoked by event, but event has no function.
		 */
		override public function draw(e:Event = null):void {
			//trace("draw: " , shadowType,tree,leaf);
			try{
			if(closed == true && points.length >2){
				
				
				//g.lineStyle(0);
				switch (shadowType) 
				{
					case "object":
						opacity = (settingBox.os.opacity);
					break;
					case "evergreen":
						opacity = (settingBox.es.opacity);
					break;
					case "decidious":
						opacity = (settingBox.ds.opacity);
					break;
					default:
					break;
				}
				g.clear();
				g.beginFill(0, 1);
				g.moveTo(points[0].x,points[0].y);
				
				for (var i:int = 1; i < points.length; i++) 
				{
					g.lineTo(points[i].x,points[i].y);
				}
				g.lineTo(points[0].x,points[0].y);
				g.endFill();
				
				bitmapData.fillRect(bitmapData.rect, 0xFFFFFF);
				
				bitmapData.draw(theShadow, m);
				this.alpha = 0.70 * opacity;
				for (var _y:int = 0; _y < bitmapData.height; _y++) {
					for (var _x:int = 0; _x < bitmapData.width; _x++) {
						var n:uint = bitmapData.getPixel(_x, _y);
						if (n != 0xFFFFFF) {
						if (decidious == true) {
							
								var map:uint = (parent as Canvas).calc.leaf.bitmapData.getPixel(_x, _y);
								var o:uint;
									
								if ( map == 0xFF0000) {
										o = 0xFFFFFF * (1 - settingBox.ds.opacity);
									} else if (map == 0x0000FF) {
										o = 0xFFFFFF * (1 - settingBox.ls.opacity);
									}else {
										o = 0xFFFFFF;
									}
									
								bitmapData.setPixel(_x, _y, o);
							
						}else {
							bitmapData.setPixel(_x, _y, 0xFFFFFF*(1-opacity));
						}
						}
					}
				}
				dispatchEvent(new Event(Event.CHANGE, true));
			}else if(points.length >0){
				g.clear();
				g.lineStyle(0);
				//g.beginFill(0, opacity);
				g.moveTo(points[0].x,points[0].y);
				if(points.length >1){
				for (var k:int = 1; k < points.length; k++) 
				{
					g.lineTo(points[k].x,points[k].y);
				};
				}
				if (!keys["16"]) {
					g.lineTo(stage.mouseX, stage.mouseY);
				}else {
					var _p:Point = snap();
					g.lineTo(_p.x, _p.y);
				}
				
				
			}
			}
			catch (er:Error) {
			
				trace("draw error: "+er);
			}
			
			//if(stage)stage.dispatchEvent(new Event(Event.CHANGE));
		}
		public function addHotspot(e:MouseEvent):void {
			e.stopPropagation();
			//if(bonds.containsPoint(new Point(e.stageX,e.stageY))){
				
				if (keys["16"]) {
					var _sp:Point = snap();
					pushHotspot(new HotSpot(_sp.x, _sp.y));
				}else {
					
					pushHotspot(new HotSpot(e.stageX, e.stageY));
				}
				if (points.length > 3) points[points.length - 2].removeEventListener(MouseEvent.MOUSE_DOWN, closeShape);
				
				if (points.length > 2) points[points.length - 1].addEventListener(MouseEvent.MOUSE_DOWN, closeShape,false,1);
				
				//newShape.draw();
				if (points.length > 2) points[0].addEventListener(MouseEvent.MOUSE_DOWN, closeShape,false,1);
			//}
		}
		private function clickHotspot(e:MouseEvent):void {
			trace("ShadowShape -> clickHotspot");
			e.stopPropagation();
			if (selected) {
				e.stopImmediatePropagation();
				
				if (!(e.target is HotSpot) && afterIndex != -1) {
					var A:HotSpot = points[afterIndex-1];
					var B:HotSpot = (afterIndex == points.length)?points[0]:points[afterIndex ];
					var M:Point = new Point(e.stageX, e.stageY);
					M = fixPoint(A, B, M);
					spliceHotspot(new HotSpot(M.x, M.y), afterIndex);
					
					//select();
				}
				
				resetAfterThis();
			}
			
			
			
		}
		private function kDown(e:KeyboardEvent):void {
			//trace("kDown",e.keyCode)
			keys[e.keyCode] = true;
		}
		private function kUp(e:KeyboardEvent):void {
			//trace("kUp",e.keyCode)
			delete keys[e.keyCode];
		}
		public function openShape() : void {
			par.addEventListener(MouseEvent.CLICK, addHotspot);
			
			points[0].removeEventListener(MouseEvent.MOUSE_DOWN, closeShape);
			points[points.length - 1].removeEventListener(MouseEvent.MOUSE_DOWN, closeShape);
			closed = false;
			
			addEventListener(Event.ENTER_FRAME, mMov);
			addEventListener(Event.ENTER_FRAME, eF);
		}
		public function closeShape(e:MouseEvent = null ):void {
			trace("ShadowShape -> closeShape");
			if (e) e.stopImmediatePropagation();
			par.removeEventListener(MouseEvent.CLICK, addHotspot);
			//par.removeEventListener(MouseEvent.CLICK, addPoint);
			
			for (var i:int = 0; i < points.length; i++) 
			{
				points[i].removeEventListener(MouseEvent.MOUSE_DOWN, closeShape);
			}
			
			if (points.length < 3) {
				dispatchEvent(new Event(DlEvt.REMOVE, true));
			}else {
				closed = true;
				draw();
				dispatchEvent(new DataEvent("changeTool", true, true, "arrow"));
			}
			
			
		}
		public function spliceHotspot(h:HotSpot, i:int = -1):void {
			dispatchEvent(new Event("pushUndo", true));
			if (i == -1) 
			i = points.length - 1;
				
			points.splice(i, 0, h);
			addChild(h);
			h.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER,false,true,10,10,h));
			h.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,false,true,10,10,h));

			draw();
		}
		
		public function pushHotspot(h:HotSpot):void {
			dispatchEvent(new Event("pushUndo", true));
			addChild(h);
			
			points.push(h);
			draw();
		}
		
		
		
		
		private function resetAfterThis():void {
			if (stage && afterIndex > -1) {
				//points[afterIndex-1].filters = [];
				afterIndex = -1;
				//stage.removeEventListener(MouseEvent.MOUSE_DOWN, clickHotspot)
				stage.dispatchEvent(new Event("noPeaceCursor"));
			}
			
		}
		public function setAfterThis(_h:HotSpot):void {
			resetAfterThis();
			afterIndex = points.indexOf(_h)+1;
			//_h.filters = [new DropShadowFilter()];
		}
		private function eF(e:Event):void {
			try {
				if(points.length >0){
					resetAfterThis();
					var m:Point = new Point(mouseX, mouseY);
					var A:HotSpot;
					var B:HotSpot;
					
					for (var i:int = 0; i < points.length-1; i++) 
					{
						A = points[i];
						B = points[i + 1];
						if (pointToLineDist(A.x, A.y, B.x, B.y, m.x, m.y) < snapTo) { 
							setAfterThis(A); 
							
							break; 
						}
					}
					A = points[points.length - 1]
					B = points[0];
					if (pointToLineDist(A.x, A.y, B.x, B.y, m.x, m.y) < snapTo) setAfterThis(A);
					if (stage && afterIndex != -1) {
						stage.dispatchEvent(new Event("peaceCursor"));
						par.addEventListener(MouseEvent.MOUSE_DOWN, clickHotspot,false,1);
					}else if(stage) {
						par.removeEventListener(MouseEvent.MOUSE_DOWN, clickHotspot);
					}else {
						par.removeEventListener(MouseEvent.MOUSE_DOWN, clickHotspot);
						
					}
			
				}
			}
			catch (err:Error) {
				trace(err);
				err = null;
			}
		}
		private function snap():Point {
			var ph:HotSpot = points[points.length - 1];
			var pp:Point = new Point(ph.x, ph.y);
			
			var mp:Point = new Point(parent.mouseX, parent.mouseY);
			
			var ar:Number = Math.PI / 2 - Math.atan2(pp.x - mp.x, pp.y - mp.y); 
			trace(ar);
			//var a:Number = ar * (180 / Math.PI)
			//trace (a);
			var s:Number = ar / (Math.PI/4);
			ar = Math.round(s) * Math.PI/4;
			
			
			var op:Point = Point.polar(Point.distance(mp, pp),  ar);
			pp.offset(-op.x, -op.y);
			return pp;
			
		}
		public function pointToLineDist(x1:Number, y1:Number, x2:Number, y2:Number,x3:Number, y3:Number):Number {
		    var dx:Number=x2-x1;
		    var dy:Number=y2-y1;
		    if (dx==0 && dy==0) {
		        x2+=1;
		        y2+=1;
		        dx=dy=1;
		    };
		    var u:Number = ((x3 - x1) * dx + (y3 - y1) * dy) / (dx * dx + dy * dy);
		 
		    var closestX:Number;
		    var closestY:Number;
		    if (u<0) {
		        closestX=x1;
		        closestY=y1;
		    } else if (u> 1) {
		        closestX=x2;
		        closestY=y2;
		    } else {
		        closestX=x1+u*dx;
		        closestY=y1+u*dy;
		    }
			
		    dx=closestX-x3;
		    dy = closestY - y3;
		
			var delta:Number = Math.sqrt(dx * dx +  dy * dy);
		    return delta;
		}
		
		public function fixPoint(A:HotSpot,B:HotSpot,M:Point):Point{//x1:Number, y1:Number, x2:Number, y2:Number,x3:Number, y3:Number):Number {
		    var x1:Number = A.x;
		    var y1:Number = A.y;
			var x2:Number = B.x;
			var y2:Number = B.y;
			var x3:Number = M.x;
			var y3:Number = M.y;
		
			var dx:Number=x2-x1;
		    var dy:Number=y2-y1;
		    if (dx==0 && dy==0) {
		        x2+=1;
		        y2+=1;
		        dx=dy=1;
		    };
		    var u:Number = ((x3 - x1) * dx + (y3 - y1) * dy) / (dx * dx + dy * dy);
		 
		    var closestX:Number;
		    var closestY:Number;
		    if (u<0) {
		        closestX=x1;
		        closestY=y1;
		    } else if (u> 1) {
		        closestX=x2;
		        closestY=y2;
		    } else {
		        closestX=x1+u*dx;
		        closestY=y1+u*dy;
		    }
			
		    dx=closestX-x3;
		    dy = closestY - y3;
		
			//var delta:Number = Math.sqrt(dx * dx +  dy * dy);
		    return new Point(closestX,closestY);
		}
		
		override protected function removedFromStage(e:Event):void {
			trace("ShadowRaster -> removedFromStage", this);
			//par.removeEventListener(MouseEvent.CLICK, addHotspot);
			//par.removeEventListener(MouseEvent.MOUSE_DOWN, clickHotspot);
			removeEventListener(Event.ENTER_FRAME, eF);
			removeEventListener(DlEvt.DRAW, draw);
			removeEventListener(DlEvt.SHAPE_AFTER_THIS, setAfterThis);
			
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
		}
		override protected function addedToStage(e:Event):void {
			trace("ShadowRaster -> addedToStage", this);
			//par.addEventListener(MouseEvent.CLICK, addHotspot);
			//par.addEventListener(MouseEvent.MOUSE_DOWN, clickHotspot);
			addEventListener(Event.ENTER_FRAME, eF);
			addEventListener(DlEvt.DRAW, draw);
			addEventListener(DlEvt.SHAPE_AFTER_THIS, setAfterThis);
			
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);

		}

	}

}