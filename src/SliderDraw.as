package  
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Petrovic Veljko DLabz@intubo.com
	 */
	public class SliderDraw extends Sprite
	{
		private var _opacity:Number = .6;
		
		private var opacityBar:Sprite = new Sprite();
		private var vBar:Sprite = new Sprite();
		private var len:Number;
		private var thi:Number;
		
		
		private var b:Bitmap;
		private var s:Shape;
		private const vbw:int = 18;
		public function SliderDraw(_len:Number = 100,_thi:Number = 32, _ref:String = "evergreen", _op:Number = .6) 
		{
			
			this.len = _len;
			this.thi = _thi;
			this.name = _ref;
			
			//b = new Library[_ref]();
				//addChild(b);
			
				
			
			
			trace("ok");
			
			opacityBar.graphics.lineStyle(1, 0x000000, .5, true);
			opacityBar.graphics.beginFill(Library.c2);
			
			useHandCursor = false;
			opacityBar.useHandCursor = false;
			opacityBar.graphics.drawRect(0,-vbw/2,thi,len+vbw);
			opacityBar.addEventListener(MouseEvent.MOUSE_WHEEL, wheelRot);
			opacityBar.addEventListener(MouseEvent.MOUSE_DOWN, jumpTo);
			opacityBar.y =  vbw / 2;
			this.addChild(opacityBar);
			
			vBar.graphics.lineStyle(1, 0x000000, .5, true);
			vBar.graphics.beginFill(Library.c1);
			vBar.graphics.drawRect( 0,-vbw/2, thi,  vbw);
			vBar.y = vbw + (1-value) * len;
			
			vBar.useHandCursor = true;
			vBar.buttonMode = true;
			vBar.addEventListener(MouseEvent.MOUSE_DOWN, mDown);
			
			graphics.lineStyle(1, 0x0, .5, true);
			graphics.beginFill(Library.c4);
			graphics.drawRect(0, height, 32, 34);
			s = new Shape();
			s.graphics.beginFill(0, 1);
			s.graphics.drawCircle(0, 0, 16 * value);
				
			s.x = 16;
			s.y = height-18;
			addChild(s);
			opacityBar.addChild(vBar);
			value = _op;
			
			addEventListener(MouseEvent.MOUSE_OVER, mOver);

		}
		

		private function mDown(e:MouseEvent):void {
			trace("vBar mdown");
			e.stopPropagation();
			vBar.addEventListener(MouseEvent.MOUSE_OUT, mUp);
			//vBar
			stage.addEventListener(MouseEvent.MOUSE_UP, mUp);
			vBar.addEventListener(MouseEvent.MOUSE_UP, mUp);
			//if (e.target == vBar) {
				//trace("fdrag");
				vBar.startDrag(false, new Rectangle(0, 0, 0, len));
			//}
			addEventListener(Event.ENTER_FRAME, eF);
		}
		private function jumpTo(e:MouseEvent):void {
			e.stopPropagation();
			trace("jump")
			value = 1-e.localY / len;
			//vBar.y = opacity * len;
			trace(value);
			dispatchEvent(new DataEvent("setupBrush",true,false,this.name))
		}
		private function mUp(e:MouseEvent):void {
			e.stopImmediatePropagation();
			removeEventListener(Event.ENTER_FRAME, eF);
			if (stage) stage.removeEventListener(MouseEvent.MOUSE_UP, mUp);
			vBar.removeEventListener(MouseEvent.MOUSE_UP, mUp);
			vBar.removeEventListener(MouseEvent.MOUSE_OUT, mUp);
			if(stage)stage.addEventListener(MouseEvent.MOUSE_UP, mUp);
			vBar.addEventListener(MouseEvent.MOUSE_UP, mUp);
			trace("mUp",e.currentTarget.y, e.currentTarget)
						
			vBar.stopDrag();
			dispatchEvent(new DataEvent("setupBrush",true,false,this.name))
			//var val:Number = (((e.currentTarget.y) / len ));
			//
			//opacity = val;
			//trace(opacity);
		}
		private function mOver(e:MouseEvent):void {
			if(stage)stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));

			dispatchEvent(new Event("fixCursor",true))
		}

		private function wheelRot(e:MouseEvent):void {
			
			var val:Number = e.delta ;
			if (val < 0) val = -.01;
			if (val > 0) val = .01;
			value += val;
		}
		
		private function eF(e:Event):void {
			trace("vbar Ef");
			var val:Number = 1-(((vBar.y) / len ));
			
			value = val;
		}
		public function get value():Number {
			return _opacity;
		}
		
		public function set value(_o:Number):void {
			
			if (_o < 0) _o = 0;
			if (_o > 1) _o = 1;
			_opacity = _o;
			var r:uint = _o * 18;
				
				s.graphics.clear();
			switch (name)
			{
				case "pencil": 
					s.graphics.beginFill(0x0, 1);
					s.graphics.drawCircle(0, 0, 4 + ((r) / 2));
					
					break;
				case "eraser": 
					s.graphics.beginFill(0xFFFFFF, 1);
					s.graphics.lineStyle(0, 0);
					s.graphics.drawRect(-4 - r / 2, -4 - r / 2, r + 8, r + 8);
					
					break;
			}
				//s.graphics.beginFill(0, 1);
				//s.graphics.drawCircle(0, 0, 1+15 * _opacity);
				
			
				vBar.y = (1-value) * len;
			
			//opacityBar.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false, _o * len, 0, opacityBar));
			
		}
	}

}