package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BevelFilter;
	import Array;
	import Library;
	
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class ButtonDrop extends Sprite
	{
		public var value:String = "evergreen";
		
		//
		private var _n:String;
		private var b:Bitmap;
		private var a:Array;
		public function ButtonDrop(_a:Array) 
		{
			a = _a;		
			_n = a[0];
			var g:Graphics = graphics;
			g.beginFill(0x666666, 1);
			g.drawRoundRect(0, 0, 32, 32, 8, 8);
			
			
			b = new Library[_a[0]]();
			//b.width = b.height = 28;
				//b.x = b.y = 2;
			//filters = [new BevelFilter(2,2)]
			addChild(b);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			//if (parent && (parent is ToolBox)) {
				//var p:ToolBox = parent as ToolBox;
				//this.status = p.target[_n];
				//if (status == true) {
					//setOn();
				//}else {
					//setOff();
				//}
			//}
			useHandCursor = true;
			buttonMode = true;
			if(_n == "pencil")addEventListener(MouseEvent.MOUSE_DOWN, clickButton);
			addEventListener(MouseEvent.MOUSE_OVER, mDown);
			addEventListener(MouseEvent.MOUSE_UP, mUp);
			addEventListener(MouseEvent.CLICK, mUp);
			//stage.addEventListener("listenSwitch", listenSwitch);
			addEventListener("stealthSwitch", stealthSwitch);
			//stage.addEventListener("switchToArrow", stealthSwitch);
		}
		private function mUp(e:MouseEvent):void {
			e.stopPropagation();
		}
		private function mDown(e:MouseEvent):void {
			
			//trace("mdwn");
			//e.stopPropagation();
			//removeEventListener(MouseEvent.MOUSE_DOWN, mDown);
			removeEventListener(MouseEvent.MOUSE_OVER, mDown);
			//addEventListener(MouseEvent.MOUSE_DOWN, cancel);
			var box:Sprite = new Sprite();
			box.name = "box";
			box.y = this.height;
			for (var i:int = 0; i < a.length; i++) 
			{
				if (!(_n == a[i])) {
					var bt:Sprite = mkOption(a[i]);
					bt.useHandCursor = true;
					bt.buttonMode = true;
					bt.y = box.height;
					box.addChild(bt);
				}
				
			}
			addChild(box);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, sMDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mOut);
		}
		private function mOut(e:MouseEvent):void {
			//trace(e.target.name)
			addEventListener(MouseEvent.MOUSE_OVER, mDown);
			var box:Sprite = getChildByName("box") as Sprite;
			if (box && !hitTestPoint(stage.mouseX,stage.mouseY)) {
				removeChild(box);
				removeEventListener(MouseEvent.MOUSE_DOWN, cancel);
				//addEventListener(MouseEvent.MOUSE_DOWN, mDown);
				//addEventListener(MouseEvent.MOUSE_OVER, mDown);
				box = null;
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, sMDown);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mOut);
			}
			
		}
		private function clickButton(e:MouseEvent):void {
			trace("cliclkButton",e.target.name)
			dispatchEvent(new DataEvent("button", true, false, _n));
		}
		private function sMDown(e:MouseEvent):void {
			e.stopPropagation();
			var box:Sprite = getChildByName("box") as Sprite;
			if (box) {
				removeChild(box);
				removeEventListener(MouseEvent.MOUSE_DOWN, cancel);
				//addEventListener(MouseEvent.MOUSE_DOWN, mDown);
				box = null;
			}
			
		}
		private function mkOption(_s:String):Sprite {
			var tmp:Sprite = new Sprite();
			tmp.name = _s;
			var g:Graphics = tmp.graphics;
			g.beginFill(0x999999, 1);
			g.drawRoundRect(0, 0, 32, 32, 8, 8);
			//tmp.filters = [new BevelFilter(2,2)]
			
			var b:Bitmap = new Library[_s]();
			//b.width = b.height = 28;
				//b.x = b.y = 2;
			tmp.addChild(b);
			tmp.addEventListener(MouseEvent.MOUSE_DOWN, selectOption);
			tmp.addEventListener(MouseEvent.MOUSE_UP, mUp);
			return tmp;
		}
		private function selectOption(e:MouseEvent):void {
			e.stopPropagation();
			var box:Sprite = getChildByName("box") as Sprite;
			if(box)removeChild(box);
			box = null;
			//trace(e.target.name);
			removeChild(b);
			b = new Library[e.target.name];
			b.addEventListener(MouseEvent.MOUSE_UP, mUp);
			_n = e.target.name;
			addChild(b);
			//removeEventListener(MouseEvent.MOUSE_DOWN, cancel);
			//addEventListener(MouseEvent.MOUSE_DOWN, mDown);
			addEventListener(MouseEvent.MOUSE_OVER, mDown);
			
			dispatchEvent(new DataEvent("buttonDrop", true, false, e.target.name));
			dispatchEvent(new DataEvent("switchTool", true, false, e.target.name));
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, sMDown);
		}
		private function cancel(e:MouseEvent):void {
			e.stopPropagation();
			var box:Sprite = getChildByName("box") as Sprite;
			if(box)removeChild(box);
			box = null;
			//removeEventListener(MouseEvent.MOUSE_DOWN, cancel);
			//addEventListener(MouseEvent.MOUSE_DOWN, mDown);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, sMDown);
		}
		private function listenSwitch(e:DataEvent):void {
			b = new Library[e.target.name];
			_n = e.target.name;
			//b.width = b.height = 28;
				//b.x = b.y = 2;
		}
		private function stealthSwitch(e:DataEvent):void {
			trace("buttonDrop stealthSwitch" + e.data);
			e.stopPropagation();
			var box:Sprite = getChildByName("box") as Sprite;
			if(box)removeChild(box);
			box = null;
			
			//removeChild(b);
			
			b = new Library[e.data];
			_n = e.data;
			//b.width = b.height = 28;
			//b.x = b.y = 2;
			dispatchEvent(new DataEvent("switchTool", true, false, e.data));
			//addChild(b);
			
		}
		
	}

}