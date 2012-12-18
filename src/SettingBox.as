package  
{
	import dl.events.OptionEvent;
	import dl.ifc.DlButton;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.AntiAliasType;
	import flash.events.Event;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class SettingBox extends Sprite
	{
		private var b:Button = new Button("settings");
		private var dropped:Sprite = new Sprite();
		
		public var os:Slider = new Slider(100, 32, "object",1);
		public var es:Slider = new Slider(100, 32, "evergreen",.8);
		
		public var ds:Slider = new Slider(100, 32, "decidious",.9);
		public var ls:Slider = new Slider(100, 32, "leaffree", .25);
		
		private var tf1:TextField = new TextField();
		private var tf1a:TextField = new TextField();
		private var tf2:TextField = new TextField();
		private var sw:Switch = new Switch(["rOff", "rOn"]);
		private var wb:DlButton = new DlButton(["water"]);
		private var hb:DlButton = new DlButton(["heat"]);
		private var pb:DlButton = new DlButton(["pool"]);
		public function SettingBox() 
		{
			addChild(b);
			//tf1.x = 32;
			tf1.width = 150;
			tf1.height = 20;
			//tf1.y = -tf1.height;
			//Library.textFormat.align = "right";
			tf1.defaultTextFormat = Library.textFormatL;
			tf1.antiAliasType = AntiAliasType.ADVANCED;
			//tf1.embedFonts = true;
			//tf1.defaultTextFormat.align = "left";
			tf1.text = "Opacité Obstacle";
			tf1.backgroundColor = Library.c1;
			tf1.background = true;
			tf1.border = true;
			
			tf1a.x = 150;
			tf1a.width = 30;
			tf1a.height = 20;
			//tf1a.y = -tf1.height;
			//Library.textFormat.align = "right";
			tf1a.defaultTextFormat = Library.textFormat;
			tf1a.antiAliasType = AntiAliasType.ADVANCED;
			//tf1.embedFonts = true;
			tf1a.text = "%";
			tf1a.backgroundColor = Library.c1;
			tf1a.background = true;
			tf1a.border = true;
			
			tf2.x = 32;
			tf2.width = 148;
			tf2.height = 20;
			tf2.backgroundColor = Library.c1;
			tf2.background = true;
			tf2.border = true;
			//tf2.embedFonts = true;
			tf2.defaultTextFormat = Library.textFormatL;
			tf2.defaultTextFormat.align = "left";
			tf2.text = "Voir mois sans feuilles";
			tf2.y = 128+tf1.height;
			
			sw.y = 128+tf1.height;
			dropped.addChild(tf1);
			dropped.addChild(tf1a);
			dropped.addChild(os);
			dropped.addChild(es);
			dropped.addChild(ds);
			dropped.addChild(ls);
			dropped.addChild(sw);
			dropped.addChild(tf2);
			dropped.addChild(wb);
			dropped.addChild(pb);
			dropped.addChild(hb);
			os.y = tf1.height
			es.y = 32+tf1.height;
			ds.y = 64+tf1.height;
			ls.y = 96 + tf1.height;
			
			wb.width = wb.height = 28;
			hb.width = hb.height = 28;
			pb.width = pb.height = 28;
			
			wb.addEventListener("waterClicked", bClick);
			hb.addEventListener("heatClicked", bClick);
			pb.addEventListener("poolClicked", bClick);
			
			
			wb.y = pb.y = hb.y = 128 + tf1.height+ tf2.height+2;
			wb.x = 32 +2;
			hb.x = 64 + 16 +2;
			pb.x = 96 + 32 + 2;
			dropped.y = 32;
			
			var d:Graphics = dropped.graphics;
			
			d.beginFill(Library.c1, 1);
			d.lineStyle(0);
			d.drawRect(0, wb.y-2, dropped.width, wb.height+4);
			
			b.addEventListener(MouseEvent.MOUSE_DOWN, drop);
			b.addEventListener(MouseEvent.MOUSE_OVER, drop);
			
			addEventListener(MouseEvent.MOUSE_MOVE, mStop);
			addEventListener(MouseEvent.CLICK, mStop);
			//addEventListener(MouseEvent.MOUSE_MOVE, mMove);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event = null):void 
		{
			//dropped.mouseEnabled = false;
			addEventListener(MouseEvent.MOUSE_OVER, mFix);
			stage.addEventListener(OptionEvent.CHANGE, optionChange);
			stage.dispatchEvent(new OptionEvent(OptionEvent.REQUEST));
		}
		private function mStop(e:MouseEvent):void {
			e.stopPropagation();
		}
		private function drop(e:MouseEvent):void {
			//e.stopPropagation();
			//dispatchEvent(new Event("fixCursor",true))

			b.addEventListener(MouseEvent.MOUSE_DOWN, rm);
			b.removeEventListener(MouseEvent.MOUSE_DOWN, drop);
			b.removeEventListener(MouseEvent.MOUSE_OVER, drop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, rm);
			
			
			addChild(dropped);
		}
		private function rm(e:MouseEvent):void {
			//e.stopPropagation();
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, rm);
			//dropped.removeEventListener(MouseEvent.MOUSE_OUT, rm);
			b.removeEventListener(MouseEvent.MOUSE_DOWN, rm);
			b.addEventListener(MouseEvent.MOUSE_DOWN, drop);
			b.addEventListener(MouseEvent.MOUSE_OVER, drop);
			removeChild(dropped);
		}
		public function optionChange(e:OptionEvent):void {
			trace("SettingBox -> optionChange -> " + e);
			wb.act = e.water;
			pb.act = e.pool;
			hb.act = e.heating;
			
		}
		public function bClick(e:Event):void {
				trace("bClicked: "+e.type);
				switch (e.type) 
				{
				case "waterClicked":
					//trace(wb.act);
					stage.dispatchEvent(new OptionEvent(OptionEvent.WATER));
					//wb.act = (wb.act)?false:true;
					//trace(wb.act);
					break;
				case "poolClicked":
					stage.dispatchEvent(new OptionEvent(OptionEvent.POOL));
					//pb.act = (pb.act)?false:true;
					break;
				case "heatClicked":
					stage.dispatchEvent(new OptionEvent(OptionEvent.HEATING));
					//hb.act = (hb.act)?false:true;
					break;
					default:
				}
			}
			
		private function mMove(e:MouseEvent):void {
			e.stopPropagation();
		}
		private function mFix(e:MouseEvent):void {
			
			dispatchEvent(new Event("fixCursor",true))
		}
		//private function mOut(e:MouseEvent):void {
			//e.stopPropagation();
			//stage.dispatchEvent(new Event("unfixCursor"))
		//}
	}

}