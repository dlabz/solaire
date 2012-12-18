package dl.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class OrientationEvent extends Event 
	{
		public static const CHANGE:String = "orientationChange";
		public var orientation:Number;
		
		public function OrientationEvent(type:String, orientation:Number, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.orientation = orientation;
			
		} 
		
		public override function clone():Event 
		{ 
			return new OrientationEvent(type, orientation, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("OrientationEvent", "type", "orientation", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}