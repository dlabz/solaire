package dl.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class CalcEvent extends Event 
	{
		public static const CHANGE:String = "calcChangeEvent";
		
		public var shadow:Number;
		public var orientation:Number;
		public var energy:Number;
		public var maxEnergy:Number;
		public var design:Number;
		
		public function CalcEvent(type:String, shadow:Number, orientation:Number, energy:Number, maxEnergy:Number, design:Number, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.shadow = shadow;
			this.orientation = orientation;
			this.energy = energy;
			this.maxEnergy = maxEnergy;
			this.design = design;
		} 
		
		public override function clone():Event 
		{ 
			return new CalcEvent(type, shadow,orientation, energy, maxEnergy,design, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CalcEvent", "type", "shadow", "orientation", "energy", "maxEnergy", "design", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}