package  
{
	import flash.display.Sprite;
	import flash.events.*;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class DrawBox extends Sprite
	{
		private var b:ButtonDrop = new ButtonDrop(["arrow","pen", "pencil"]);
		public var b2:ButtonDrop = new ButtonDrop(["object","evergreen", "decidious"]);
		
		private var ps:SliderDraw = new SliderDraw(100, 32, "pencil");
		private var es:SliderDraw = new SliderDraw(100, 32, "eraser");
		private var eb:Button = new Button("eraser");
		private var seb:Button = new Button("eraser");
		public function DrawBox() 
		{
			addChild(b2);
			b.x = 32;
			b.addEventListener("buttonDrop", switchTool);
			b2.addEventListener("buttonDrop", switchType);
			b2.filters = [dBW.BW()];
			b2.mouseEnabled = false;
			eb.addEventListener("button", switchTool);
			
			addChild(b);
			this.graphics.beginFill(0x999999, 1);
			this.graphics.drawRect(0, 0, 64, 32);
			
			seb.x = 64;
			addChild(seb);
			seb.mouseEnabled = false;
			seb.filters = [dBW.BW()];
			addEventListener(MouseEvent.MOUSE_UP, mUp);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event = null):void 
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener("stealthSwitch", stealthSwitch);
			stage.addEventListener("stealthSwitchType", stealthSwitchType);
			addEventListener(MouseEvent.MOUSE_OVER, mOver);
			addEventListener(MouseEvent.MOUSE_MOVE, mStop);
			addEventListener(MouseEvent.CLICK, mStop);
			addEventListener(MouseEvent.MOUSE_DOWN, mStop);


			
		}
		private function stealthSwitch(e:DataEvent):void {
			e.stopPropagation();
			if (es.parent) removeChild(es);
			if (ps.parent) removeChild(ps);
			b.dispatchEvent(e);
		}
		private function stealthSwitchType(e:DataEvent):void {
			e.stopPropagation();
			
			b2.dispatchEvent(new DataEvent("stealthSwitch",true,true,e.data));
		}
		private function switchEraser(e:DataEvent):void {
			trace("wwwohooo!");
			removeChild(eb);
			addChild(eb);
		}
		private function switchType(e:DataEvent):void {
			
			trace("toolbox type switching | " + e.type + ":" + e.data);
			while (numChildren > 0) removeChildAt(0);
			addChild(b);
			addChild(b2);
			addChildAt(seb,0);
			switch (e.data) 
			{
			
				case "evergreen":
				case "object":
				case "decidious":
					trace ("dispatchEvent: " + e.type);
					dispatchEvent(new DataEvent("switchType", true, true, e.data));
				break;
			}
			
			
			
			
			
		}
		private function switchTool(e:DataEvent):void {
			
			trace("toolbox switching | " + e.type + ":" + e.data);
			while (numChildren > 0) removeChildAt(0);
			
			switch (e.data) 
			{
				
				case "pencil":
					ps.y = 32;
					ps.x = 32;
					addChild(ps);
					eb = new Button("eraser");
					eb.x = 64;
					addChild(eb);
					eb.addEventListener("button", switchTool);
					ps.dispatchEvent(new DataEvent("setupBrush",true,false,e.data))
				break;
				case "eraser":
					es.x = 64;
					es.y = 32;
					addChild(es);
					eb = new Button("eraser");
					eb.x = 64;
					addChild(eb);
					b.addEventListener("button", switchTool);
					es.dispatchEvent(new DataEvent("setupBrush",true,false,e.data))
				break;
				case "evergreen":
				case "object":
				case "decidious":
					trace ("dispatchEvent: " + e.type);
					dispatchEvent(e);
				break;
			}
			addChild(b);
			addChild(b2);
			addChildAt(seb, 0);
			if (b.value == "pencil") addChild(ps);
			//this.x = 800 - this.width;
		}
		private function mUp(e:MouseEvent):void {
			e.stopPropagation();
		}
		private function mStop(e:MouseEvent):void
		{
			e.stopPropagation();
		}

		private function mOver(e:MouseEvent):void {
			
			dispatchEvent(new Event("fixCursor",true))
		}

	}

}