package  
{	import flash.geom.*;
	import dl.events.DlEvt;
	import flash.display.*
	import flash.events.*;
	import flash.ui.*;
	

	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class Shadow extends Sprite
	{
		public var bitmapData:BitmapData = new BitmapData(52, 28, false, 0xffffff);
		
		public var tree:Boolean = false;
		public var leaf:Boolean = false;
		public var settingBox:SettingBox;
		public var _shadowType:String = "object";
		public var summerIndex:Number = .2;
		public var winterIndex:Number = .8;
		public var opacity:Number = 1;
		
		public var bonds:Rectangle = new Rectangle(0, 0, 823, 608); ///Holds stuff
		public var selected:Boolean = true;
		
		protected var sx:Number;// = 52 / bonds.r.width;
		protected var sy:Number;// = 28/bonds.r.height
		protected var m:Matrix;// = new Matrix(sx, 0, 0, sy, -canvas.r.x * sx, -canvas.r.y * sy)
		public var closed:Boolean = false;
		protected var filterScreen:Sprite = new Sprite();
		
		public function Shadow() 
		{
			//addEventListener(Event.ADDED_TO_STAGE, addedToStage);

			//\\//\\//\\//\\;
			var menuDelete:ContextMenuItem = new ContextMenuItem("Delete Shape");
			menuDelete.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,deleteShape);
			
			var menuSendBack:ContextMenuItem = new ContextMenuItem("Send Back");
			menuSendBack.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,sendToBack);
			//var menuAfter:ContextMenuItem = new ContextMenuItem("Insert after this");
			//menuAfter.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,setNext);

			var customMenu:ContextMenu = new ContextMenu();
			customMenu.customItems = [menuDelete,menuSendBack];//,menuAfter
			
			customMenu.hideBuiltInItems();
			this.contextMenu = customMenu;
			filterScreen.mouseEnabled = false;
			addEventListener(MouseEvent.MOUSE_OVER, mOver);
			addEventListener(MouseEvent.MOUSE_OUT, mOut);
			
			
		}
		
		/**
		 * Draws shadow on the calculation bitmap
		 * 
		 * @param	e Function can be invoked by event. Has no role in function.
		 */
		public function draw(e:Event = null):void {
			
		}
		/**
		 * Focuses on shadow.
		 */
		public function select():void {
			//to override
		}
		
		/**
		 * Defocuses shadow
		 */
		public function deselect():void {
			//to override
		}
		public function set object(_b:Boolean):void {
			if (tree == true) tree = false;
		}
		public function get object():Boolean {
			if (!tree) return true; else return false;
		}
		public function set decidious(_b:Boolean):void {
			tree = true;
			leaf = true;
		}
		public function get decidious():Boolean {
			if (tree==true && leaf==true) return true; else return false;
		}
		public function set evergreen(_b:Boolean):void {
			tree = true;
			leaf = false;
			
		}
		public function get evergreen():Boolean {
			if (tree==true && leaf==false) return true; else return false;
		}
		public function get shadowType():String {
			return _shadowType
		}
		
		/**
		 * Sets the type of the shadow.
		 * Changes _shadowType veriable.
		 * Calls draw()
		 * Dispatches Event.CHANGE
		 * 
		 * @param _s can be object, evergreen, decidious
		 */
		public function set shadowType(_s:String):void {
			
			switch (_s) 
			{
				case "object":
					object = true;
					filterScreen.filters = [];
				break;
				case "evergreen":
					evergreen = true;
					filterScreen.filters = [dBW.EG()]
				break;
				case "decidious":
					decidious = true;
					filterScreen.filters = [dBW.DC()]
				break;
				
			}
			_shadowType = _s;
			trace("shadow: switch type: ",_s, _shadowType)
			draw();
			dispatchEvent(new Event(Event.CHANGE, true));
			
		}
		
		/**
		 * Deletes this shape.
		 * Dispatches pushUndo
		 * Dispatches "deleteShape"
		 * Dispatches "changeTool", "arrow"
		 * 
		 * @param	e Can be invoked by event.
		 */
		protected function deleteShape(e:Event = null ):void {
			
			
			
			dispatchEvent(new MouseEvent(DlEvt.DELETE, true, false, 0, 0, this));
			dispatchEvent(new DataEvent("changeTool", true, false, "arrow"));
			
		}
		
		/**
		 * removes the shape, without adding it to undo
		 * clears instances in undo
		 * 
		 * @param	e Can be invoked by event.
		 */
		protected function removeShape(e:Event = null ):void {
			
			
			dispatchEvent(new MouseEvent(DlEvt.REMOVE, true, false, mouseX, mouseY, this));
			dispatchEvent(new DataEvent("changeTool", true, false, "arrow"));
		}

		
		/**
		 * Moves object down the display list.
		 * 
		 * @param	e Operation is done on the caller
		 */
		protected function sendToBack(e:Event = null):void {
			this.parent.setChildIndex(this, 0);
		}
		
		/**
		 * This has to do with undo. If the object has been put back from the undo, reactivatedraw listeners
		 * @param	e
		 */
		protected function addedToStage(e:Event):void {
			trace("added shape", this);
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			addEventListener("drawEvent", draw);
		}
		
		/**
		 * This has to do with undo. If object has been removed from stage, deactivate listeners.
		 * @param	e
		 */
		protected function removedFromStage(e:Event):void {
			trace("removed shape", this);

			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			removeEventListener("drawEvent", draw);

		}
		
		private function mOver(e:MouseEvent):void {
			if (stage && selected) stage.dispatchEvent(new Event(DlEvt.CURSOR_HR));
		}
		private function mOut(e:MouseEvent):void {
			if (stage && selected) stage.dispatchEvent(new Event(DlEvt.CURSOR_RESET));
		}
	}

}