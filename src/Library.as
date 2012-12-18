package  
{
	import flash.display.*;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class Library extends Sprite
	{
		
		[Embed(source = '../lib/Sky.png')]
		public static const Sky:Class;
		
		[Embed(source = '../lib/Sky2.png')]
		public static const Sky2:Class;
		
		[Embed(source = '../lib/icons/Water.png')]
		public static const water:Class;
		
		[Embed(source = '../lib/icons/Pool.png')]
		public static const pool:Class;
		
		[Embed(source = '../lib/icons/Heat.png')]
		public static const heat:Class;
		
		[Embed(source = '../lib/icons/Decidious.png')]
		public static const decidious:Class;
		
		[Embed(source = '../lib/icons/Evergreen2.png')]
		public static const evergreen:Class;
		
		[Embed(source = '../lib/icons/Leafree1.png')]
		public static const leaffree:Class;
		
		[Embed(source = '../lib/icons/Object2.png')]
		public static const object:Class;
		
		[Embed(source = '../lib/icons/eraser2.png')]
		public static const eraser:Class;
		
		[Embed(source = '../lib/icons/Pen_icon1.png')]
		public static const pencil:Class;
		
		[Embed(source='../lib/icons/122.png')]
		public static const pencilerazer:Class;
		
		[Embed(source = '../lib/icons/222.png')]
		public static const pen:Class;
		
		[Embed(source = '../lib/icons/benzee.png')]
		public static const benzee:Class;
		
		[Embed(source = '../lib/icons/Pen.png')]
		public static const mpen:Class;
		
		[Embed(source = '../lib/icons/arr.png')]
		public static const arrow:Class;
		
		[Embed(source = '../lib/icons/hr.png')]
		public static const hReady:Class;
		
		[Embed(source = '../lib/icons/hg.png')]
		public static const hGrab:Class;
		
		[Embed(source = '../lib/icons/rOn.png')]
		public static const rOn:Class;
		
		[Embed(source = '../lib/icons/rOff.png')]
		public static const rOff:Class;
		
		[Embed(source = '../lib/Capsule.png')]
		public static const capsule:Class;
		
		[Embed(source = '../lib/PowerBar.png')]
		public static const powerBar:Class;
		
		[Embed(source = '../lib/icons/Setting2.png')]
		public static const settings:Class;
		
		[Embed(source = '../lib/icons/Undo.png')]
		public static const undo:Class;
		
		public static const paintFilter:Array = [];
		
		public static const terminator:Terminator = new Terminator()
		
		public static const terminatorFormat:TextFormat = new TextFormat("Terminator", 14, 0xFFFFFF,null,null,null,null,null,"center");
		public static const textFormat:TextFormat = new TextFormat("Helvetica", 14, 0xFFFFFF, null, null, null, null, null, "right");
		public static const textFormatL:TextFormat = new TextFormat("Helvetica", 14, 0xFFFFFF,null,null,null,null,null,"left");


		public static const c1:uint = 0x7D7D7D;//125
		public static const c2:uint = 0xAAAAAA;//170
		public static const c4:uint = 0x969696;//150
		
	}

}