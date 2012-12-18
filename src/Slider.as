package  
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Petrovic Veljko DLabz@intubo.com
	 */
	public class Slider extends Sprite
	{
		private var _opacity:Number = .6;
		
		private var opacityBar:Sprite = new Sprite();
		private var vBar:Sprite = new Sprite();
		private var len:Number;
		private var thi:Number;
		private var t:TextField = new TextField();
		
		private var b:Bitmap;
		private var s:Shape;
		private const vbw:int = 18;
		public function Slider(_len:Number = 100,_thi:Number = 32, _ref:String = "evergreen", _op:Number = .6) 
		{
			
			this.len = _len;
			this.thi = _thi;
			this.name = _ref;
			
			if(name == "spot"){
				s = new Shape();
				s.graphics.beginFill(0, 1);
				s.graphics.drawCircle(0, 0, 16 * opacity);
				
				s.x = 16;
				s.y = 16;
				addChild(s);
			}else {
				b = new Library[_ref]();
				//b.width = b.height = 28;
				//b.x = b.y = 2;
				addChild(b);
			}
			
			trace("ok");
			graphics.lineStyle(1, 0x0, .5, true);
			graphics.beginFill(Library.c1);
			graphics.drawRect(0, 0, 32, 32);
			graphics.drawRect(148, 0, 32, 32);
			graphics.beginFill(Library.c2);
			graphics.drawRect(32, 0, 116, 32);
			opacityBar.graphics.lineStyle(1, 0x000000, .5, true);
			opacityBar.graphics.beginFill(Library.c2);
			
			opacityBar.graphics.drawRect(-vbw/2, 0, len+vbw, thi);
			opacityBar.addEventListener(MouseEvent.MOUSE_WHEEL, wheelRot);
			opacityBar.addEventListener(MouseEvent.MOUSE_DOWN, jumpTo);
			opacityBar.x =32+ vbw / 2;
			this.addChild(opacityBar);
			
			vBar.graphics.lineStyle(1, 0x000000, .5, true);
			vBar.graphics.beginFill(Library.c1);
			vBar.graphics.drawRect( -vbw/2, 0, vbw, thi);
			vBar.x = vbw + opacity * len;
			
			vBar.useHandCursor = true;
			vBar.buttonMode = true;

			vBar.addEventListener(MouseEvent.MOUSE_DOWN, mDown);
			//addEventListener(MouseEvent.MOUSE_MOVE, mMove);
			t.width = 32;
			t.height = 20;
			t.y = 6;
			t.defaultTextFormat = Library.textFormat
			//t.embedFonts = true;
			addChild(t);
			t.x = 148;
			opacityBar.addChild(vBar);
			opacity = _op;
		}
		private function mMove(e:MouseEvent):void {
			e.stopPropagation();
		}

		private function mDown(e:MouseEvent):void {
			e.stopPropagation();
			//vBar.addEventListener(MouseEvent.MOUSE_OUT, mUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, mUp);
			
			if (e.target == vBar) {
				vBar.startDrag(true, new Rectangle(0, 0, len, 0));
			}
			addEventListener(Event.ENTER_FRAME, eF);
		}
		private function jumpTo(e:MouseEvent):void {
			e.stopPropagation();
			trace("jump")
			
			var val:Number = e.localX / len;
			if (val < 0) val = 0;
			if (val > 1) val = 1;
			opacity = val;
		}
		private function eF(e:Event):void {
			var val:Number = (((vBar.x) / len ));
			
			opacity = val;
		}
		private function mUp(e:MouseEvent):void {
			e.stopPropagation();
			removeEventListener(Event.ENTER_FRAME, eF);
			vBar.removeEventListener(MouseEvent.MOUSE_OUT, mUp);
			
			trace("mUp",e.currentTarget.x)
						
			vBar.stopDrag();
			dispatchEvent(new Event(Event.RENDER,true));
		}
		private function wheelRot(e:MouseEvent):void {
			
			var val:Number = e.delta ;
			if (val < 0) val = -.01;
			if (val > 1) val = .01;
			opacity += val;
		}
		
		public function get opacity():Number {
			return _opacity;
		}
		
		public function set opacity(_o:Number):void {
			
			if (_o < 0) _o = 0;
			if (_o > 1) _o = 1;
			_opacity = _o;
			
			vBar.x = _opacity * len;
			
			//opacityBar.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false, _o * len, 0, opacityBar));
			if (stage) stage.dispatchEvent(new Event(Event.RENDER, true, false));
			t.text = int(_opacity * 100).toString();
		}
	}

}