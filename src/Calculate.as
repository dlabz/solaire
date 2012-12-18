package  
{
	import dl.events.CalcEvent;
	import dl.events.OptionEvent;
	import dl.events.OrientationEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class Calculate extends Sprite
	{
		
		[Embed(source='../lib/DataI.png')]
		private var Data1:Class
		
		[Embed(source='../lib/DataII.png')]
		private var Data2:Class
		
		[Embed(source='../lib/DataIII.png')]
		private var Data3:Class
		
		[Embed(source='../lib/leaf.png')]
		private var Leaf:Class
		
		
		public var bData:Bitmap = new Data1();
		public var bData2:Bitmap = new Data2();
		public var bData3:Bitmap = new Data3();
		public var leaf:Bitmap = new Leaf();
		
		//public var shapes:Vector.<ShadowShape> = new <ShadowShape>[];
		public var shapes:Array = [];
		private var b:BitmapData = bData.bitmapData;
		private var b2:BitmapData = bData2.bitmapData;
		private var b3:BitmapData = bData3.bitmapData;
		private var l:BitmapData = leaf.bitmapData;
		public var m:BitmapData = new BitmapData(52, 28, false, 0xFFFFFF);
	//	public var m2:BitmapData = new BitmapData(52, 28, false, 0xFFFFFF);
	
		
		public var par:DisplayObject;
		
		public var shadow:Number = 0;
		public var orientation:Number = 0;
		public var energy:Number = 600;
		public var design:Number = 1;
		
		public var yearSum:Number = 0;
		public var summerSum:Number = 0;
		public var poolSum:Number = 0;
		public var shadowSum:Number = 0;///loss on shadows
		
		public var heating:Boolean = true;
		public var water:Boolean = false;
		public var pool:Boolean = false;
		
		public function Calculate() 
		{
			
			bData.scaleX = 10;
			bData.scaleY = 10;
			addChild(bData);
			
			bData2.scaleX = 10;
			bData2.scaleY = 10;
			bData2.y = bData.height;
			addChild(bData2);
			
			bData3.scaleX = 10;
			bData3.scaleY = 10;
			bData3.y = bData2.height *2 ;
			addChild(bData3);
			
			trace(bData.bitmapData);
			compute();
		
		}
		public function addListeners():void {
			par.addEventListener(OrientationEvent.CHANGE, orientationChange);
			par.addEventListener(OptionEvent.HEATING, toggleOption);
			par.addEventListener(OptionEvent.WATER, toggleOption);
			par.addEventListener(OptionEvent.POOL, toggleOption);
			par.addEventListener(OptionEvent.REQUEST, toggleOption);
			
			par.dispatchEvent(new OptionEvent(OptionEvent.CHANGE, heating, water, pool));
		}
		private function toggleOption(e:OptionEvent):void {
			trace("Calculate -> toggleOption -> " + e);
			switch (e.type) 
			{
				case OptionEvent.HEATING:
				heating = (heating)?false:true;	
				break;
				case OptionEvent.WATER:
				water = (water)?false:true;	
				break;
				case OptionEvent.POOL:
				pool=(pool)?false:true;	
				break;
			}
			par.dispatchEvent(new OptionEvent(OptionEvent.CHANGE, this.heating, this.water, this.pool));
			compute();
		}
		private function orientationChange(e:OrientationEvent):void {
			this.orientation = e.orientation;
			compute();
		}
		/*
		 * This function is where all the magic happens
		 */
		public function compute():void {

			yearSum = 0;
			summerSum = 0;
			poolSum = 0;
			shadowSum = 0;
			
			
			/*
			 * I'm laying out a united shadow from all objects in an immaginary table / EXEL document... 
			 * if there is no object walue is 100%, and if there is an object trowing a shadow, value goes down, 
			 * zaro being a place where a building shades it....
			 */
			  
			//for each row
			for (var _y:int = 0; _y < b2.height; _y++) 
			{
				//for each column in that row...
				for (var _x:int = 0; _x < b2.width; _x++) 
				{
					//read the density of a projected hsadow for that particular cell
					var valueShadow:Number = m.getPixel(_x, _y) / 0xFFFFFF;	
					
					///read the matching cells from Data1, data2, data3
					var valueData1:Number = b.getPixel(_x, _y) / 0xFFFF;
					var valueData2:Number = b2.getPixel(_x, _y) / 0xFFFF;
					var valueData3:Number = b3.getPixel(_x, _y) / 0xFFFF;
					
					//addChild a value of this cell to a number representing an average coverage of the collector by shadows 
					shadowSum += valueShadow;
					
					//multiply the value of this cell with values from matching cells in each of our tables....
					yearSum 	+= valueData1 * valueShadow;//data1
					summerSum 	+= valueData2 * valueShadow;//data2
					poolSum		+= valueData3 * valueShadow;//data3
				}
				
			}
			
			//
			
			//this function takes an average coverage, and gives an reciprocic value, that we use to represent "Shadow" value in out app
			function shadowCalc(s:Number):Number
			{	return 100 - s; };
			
			//to calculate the energy, we take the relevant shadow and Orieentation, and get energy
			function energyCalc(s:Number, o:Number):Number 
			{	return s / 100  * (1 - o) * 600 };
							
			//to get the design, we follow this formula
			function designCalc(s:Number, o:Number):Number
			{	return 600 / (  s / 100 * ( 1 - o ) * 600); };

			
			//if heating has been selected, calculate the values using these parameters..
			//if heating has been selected, pool and watterr don't matter, we use following averages to calculate our values:
			if (heating) { //combine
				trace('calculating heating');
				shadow  	= shadowCalc(summerSum);//Data 2
				energy 		= energyCalc(summerSum, orientation);//data2
				design		= designCalc(yearSum, orientation);//data1
			}else {
			//And if the heating isn't being used, we have two choices: 
				if (water) {
					//if hot water 
					if (pool) { //combine
						//and the pool heating are needed
						trace('calculating combine');
						shadow  	= shadowCalc(shadowSum);//we'll use shadow to calculate the shadow,
						energy 		= energyCalc(summerSum, orientation);// data2 to calculate energy
						design		= designCalc(summerSum, orientation);//and again Data2 to calculate design
					}else { //hot watter
						//But if hot water is being used, yet no pool...
						trace('calculating water');
						shadow  	= shadowCalc(summerSum); // shadow is calculated using data2
						energy 		= energyCalc(summerSum, orientation);//energy using data2
						design		= designCalc(summerSum, orientation);//and design using data2
					}
				}else {
					//and, if no hot water system is required...
					if (pool) { //pool
						//But only the pool...
						trace('calculating pool');
						shadow  	= shadowCalc(poolSum);//we'll use data3 for shadow,
						energy 		= 250;				  //a fixed value for the energy
						design		= designCalc(poolSum, orientation);// and data 3 for the design
					}
				}
			}
			if (par) par.dispatchEvent(new CalcEvent(CalcEvent.CHANGE, shadow, orientation, energy, design));
		
		}
		
	}

}