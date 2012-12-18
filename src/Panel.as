package
{
	import dl.events.OrientationEvent;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class Panel extends Sprite
	
	{
		public var percent:Number = 0;
		
		private var pannel:Sprite = new Sprite();
		private var pannelSide:Sprite = new Sprite();
		private var post:Shape = new Shape();
		
		private var offset:Number = 400;
		private var g:Graphics;
		private var bonds:Rectangle;
		
		public function Panel(_bonds:Rectangle)
		{
			bonds = _bonds;
			x = bonds.left + bonds.width / 2;
			offset = x;
			
			post.graphics.beginFill(0xcccccc);
			post.graphics.drawRect(-5, 0, 10, 150);
			scaleX = scaleY = .5;
			
			g = pannel.graphics;
			g.beginFill(0x999999);
			g.drawRect(-62, -32, 122, 103)
			
			
			g.beginFill(0, 1);
			
			for (var i:int = 0; i < 10; i++)
			{
				g.drawRect(-60, -30 + 10 * i, 38, 9);
				g.drawRect(-20, -30 + 10 * i, 38, 9);
				g.drawRect(20, -30 + 10 * i, 38, 9);
				
			}
			
			
			
			g = pannelSide.graphics;
			g.lineStyle(6, 0);
			g.moveTo( 16, -24);
			g.lineTo( -34, 60);
			
			addChild(pannelSide);
			
			
			var per:PerspectiveProjection = new PerspectiveProjection();
			per.projectionCenter = new Point(0, 0);
			this.transform.perspectiveProjection = per;
			
			pannel.rotationX = -30;
			addChild(post);
			addChild(pannel);
			//x = 100;
			y = bonds.bottom - this.height+14;
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function mDown(e:MouseEvent):void
		{
			dispatchEvent(new Event("pushUndo", true));
			e.stopPropagation();
			startDrag(false, new Rectangle(bonds.x, y, bonds.width, 0));
			stage.addEventListener(MouseEvent.MOUSE_UP, mUp);
			//addEventListener(MouseEvent.MOUSE_OUT, mUp);
			stage.addEventListener(Event.ENTER_FRAME, mMove);
		}
		
		private function mUp(e:MouseEvent):void
		{
			stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, mUp);
			//removeEventListener(MouseEvent.MOUSE_OUT, mUp);
			stage.removeEventListener(Event.ENTER_FRAME, mMove);
		}
		
		private function init(e:Event = null):void
		{
			buttonMode = true;
			useHandCursor = true;
			removeEventListener(Event.ADDED_TO_STAGE, init)
			addEventListener(MouseEvent.MOUSE_MOVE, mStop)
			addEventListener(MouseEvent.MOUSE_DOWN, mDown);
			addEventListener(MouseEvent.CLICK, mStop);
			addEventListener(MouseEvent.MOUSE_OVER, mOver);
			//stage.addEventListener(MouseEvent.MOUSE_MOVE, mOut);
		}
		
		private function mStop(e:MouseEvent):void
		{
			e.stopPropagation();
		}
		
		public function mMove(e:Event = null):void
		{
			var _r:Number = 260 * (x - offset) / bonds.width;
			//trace("poanel r",_r)
			pannel.rotationY = -_r;
			percent = f(_r) / 100;
			if (Math.abs(_r) > 90)
			{
				setChildIndex(pannel, 1);
			}
			else
			{
				setChildIndex(post, 1);
			}
			if (_r > 0) pannelSide.scaleX = -1;else pannelSide.scaleX = 1;
			
			//stage.dispatchEvent(new DataEvent("percentChange", true, true, percent.toString()));
			trace("Panel -> percent -> " + percent);
			stage.dispatchEvent(new OrientationEvent(OrientationEvent.CHANGE, percent));
			//trace(pannel.rotationY)
		
		}
		
		private function mOver(e:MouseEvent):void
		{
			
			stage.dispatchEvent(new Event("fixCursor"))
		}
		
		private function mOut(e:MouseEvent):void
		{
			stage.dispatchEvent(new Event("unfixCursor"))
		}
		
		private function f(_x:Number):Number
		{
			return _x * _x / 385;
		}
	}

}