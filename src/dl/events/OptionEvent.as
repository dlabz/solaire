package dl.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class OptionEvent extends Event 
	{
		public static const HEATING:String = "toggleHeatingEvent";
		public static const WATER:String = "togleWaterEvent";
		public static const POOL:String = "toglePoolEvent";
		public static const CHANGE:String  = "optionChangeEvent";
		public static const REQUEST:String = "requestOptionEvent";
		
		public var heating:Boolean;
		public var water:Boolean;
		public var pool:Boolean;
		public function OptionEvent(type:String, heating:Boolean=false, water:Boolean=false, pool:Boolean=false, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.heating = heating;
			this.water = water;
			this.pool = pool;
		} 
		
		public override function clone():Event 
		{ 
			return new OptionEvent(type, heating, water, pool, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("OptionEvent", "type", "heating", "water", "pool", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}