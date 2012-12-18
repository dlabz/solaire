package dl.events 
{
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class DlEvt 
	{
		public static const REMOVE:String = "removeShape";///Deletes, but skips UNDO
		public static const SELECT:String = "selectShape";///Selects
		public static const DELETE:String = "deleteShape";///Delete
		public static const UNDO_PUSH:String = "pushUndo";
		public static const UNDO_POP:String = "popUndo";
		public static const UNDO_BUTTON:String = "undoEvent";///MAIN->Main
		public static const PERCENT:String = "percentChange";///Updates percent graphics
		public static const CALC:String = "change"; ///MAIN->Main
		public static const SELECTED:String = "selectedShadow";///Updates SelectedBox, shadowType
		public static const DRAW:String = "drawEvent";
		public static const TOOL:String = "changeTool";///MAIN->init
		public static const TOOL_CHANGED:String = "toolChanged";///DlToolBox
		public static const TYPE:String = "changeType";///MAIN->init
		public static const BACKGROUND:String = "switchBackground";///MAIN->Main
		public static const BRUSH:String = "setupBrush";
		public static const CURSOR_RESET:String = "resetCursor";
		public static const CURSOR_PEN:String = "penCursor";
		public static const CURSOR_BENZEE:String = "benzeeCursor";
		public static const CURSOR_HR:String = "hReadyCursor";
		public static const CURSOR_HG:String = "hGrabCursor";
		public static const SHAPE_AFTER_THIS:String = "setAfterThis";///ShadowShape->
		public function DlEvt() 
		{
			
		}
		
	}

}