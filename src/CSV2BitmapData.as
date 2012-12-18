package  
{
	import com.adobe.images.PNGEncoder;
	import com.shortybmc.data.parser.CSV
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.*;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class CSV2BitmapData extends Sprite
	{
		public var l:URLLoader;
		public var b:BitmapData = new BitmapData(52, 28, false, 0);
		public var loadFile:FileReference = new FileReference();

		public var saveFile:FileReference = new FileReference();
		public var enc:PNGEncoder = new PNGEncoder();
		public var save:FileReference = new FileReference();
		public var button:Sprite = new Sprite();
		public function CSV2BitmapData() 
		{
			button.addEventListener(MouseEvent.CLICK, onBrowse);
			
			var g:Graphics = button.graphics;
			g.beginFill(0xFF0066, 1);
			g.drawRect( -50, -20, 100, 40);
			button.x = 100;
			button.y = 40;
			var label:TextField = new TextField();
			label.text = "load";
			label.selectable = false;
			button.addChild(label);
			addChild(button);
			//enc.BIT_DEPTH = 24;
			//l = new URLLoader(new URLRequest("leaf.csv"));
			//l.addEventListener(Event.COMPLETE, completeHandler)
			trace("Ready");
		}
		private function onBrowse(e:MouseEvent):void {
			
			loadFile.addEventListener(Event.SELECT, onSelect);
			loadFile.addEventListener(Event.COMPLETE, onLoad);
			var csvTypeFilter:FileFilter = new FileFilter("*.csv Comma Separated Values", "*.csv; *.txt");
			loadFile.browse([csvTypeFilter]);
		}
		private function onSelect(e:Event):void {
			loadFile.addEventListener(Event.COMPLETE, onLoad);
			loadFile.load();
			trace(loadFile.name);
		}
		private function onLoad(e:Event):void {
			var text:String = loadFile.data.toString()
			trace(text);
			var reg:RegExp = /\n| /;
			var arr:Array = text.split(reg);
			trace (arr.length);
			trace(arr[0]);
			var d:Array = [];
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:String = arr[i];
				d.push(item.split(","));
				
			}
			mkBd(d);
		}
		private function mkBd(arr:Array):void {
			var sum:Number = 0;
			for (var i:int = 0; i < arr.length; i++) 
			{
				for (var j:int = 0; j < arr[i].length; j++) 
				{
					sum += Number(arr[i][j]) * 0xFFFF;
					b.setPixel(j,i,Number(arr[i][j])*0xFFFF);
					//if(Number(arr[i][j]) == 1 )b.setPixel(j,i,0x0000FF)else if(Number(arr[i][j]) == 2 )b.setPixel(j,i,0xFF0000);
				} 
				
			}
			var bitmap:Bitmap = addChild(new Bitmap(b)) as Bitmap;
			bitmap.scaleX = bitmap.scaleY = 10;
			bitmap.x = 100;
			bitmap.y = 50;
			sum /= 0xFFFF;
			trace(sum);
			var name:String = loadFile.name.split(".")[0];
			
			save.save(PNGEncoder.encode(b), name+".png");
		}
	}

}