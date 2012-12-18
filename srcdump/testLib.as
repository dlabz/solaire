package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import Library
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class testLib extends Sprite
	{
		private var b:ButtonDrop = new ButtonDrop(["object","evergreen","decidious"]);
		public function testLib() 
		{
			
			addChild(b);
		}
		
	}

}