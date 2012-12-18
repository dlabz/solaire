package  
{
	import adobe.utils.CustomActions;
	import dl.events.DlEvt;
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class HotSpot extends Sprite
	{
		private var g:Graphics;
		private var par:ShadowShape;
		
		private var inDrag:Boolean = false;
		private var noEvents:Boolean;
		public function HotSpot(_x:Number = 0,_y:Number = 0,noEvents:Boolean = false) 
		{
			this.noEvents = noEvents
			this.x = _x;
			this.y = _y;
			this.alpha = 0.5
			//this.blendMode = BlendMode.INVERT
			g = this.graphics;
			g.beginFill(0xFF0000,1);
			g.drawCircle(0, 0, 5);
			g.endFill();
			buttonMode = true;
			useHandCursor = true;
			
			var menuDelete:ContextMenuItem = new ContextMenuItem("Delete hotspot");
			menuDelete.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,deleteHotspot);
			
			//var menuAfter:ContextMenuItem = new ContextMenuItem("Insert after this");
			//menuAfter.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,setNext);

			var customMenu:ContextMenu = new ContextMenu();
			customMenu.customItems = [menuDelete];//,menuAfter
			
			customMenu.hideBuiltInItems();
			this.contextMenu = customMenu;
			addEventListener("hotspotActive",toggleActive);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			if(noEvents == false){
			if(parent is ShadowShape)this.par = parent as ShadowShape;
			
			addEventListener(MouseEvent.MOUSE_OVER, mOvr);
			addEventListener(MouseEvent.MOUSE_OUT, mOut);
			}
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
		}
		private function pull(e:MouseEvent):void 
		{
			
			e.stopPropagation();
			
			if (stage) {
				trace(this, "pull");
				dispatchEvent(new Event("pushUndo",true))
				inDrag = true;
				stage.addEventListener(MouseEvent.MOUSE_UP, drop);
				
				startDrag(false, (parent as ShadowShape).bonds);
				
				e.currentTarget.parent.parent.setChildIndex(e.currentTarget.parent, e.currentTarget.parent.parent.numChildren - 1)
				//e.currentTarget.addEventListener(MouseEvent.MOUSE_OUT,drop);
				e.currentTarget.addEventListener(Event.ENTER_FRAME, mMove);
				//e.target.startDrag(true, stage.getRect(stage));
				e.currentTarget.alpha = 0.3;
				//e.target.stage.addEventListener(MouseEvent.MOUSE_MOVE, move)
				//stage.addEventListener(Event.ENTER_FRAME, cubicBezier)
				//stage.addEventListener(KeyboardEvent.KEY_DOWN, kDwn);//snap
			
			}
		}
		//private function kDwn(e:KeyboardEvent):void {
			//if(stage)stage.addEventListener(KeyboardEvent.KEY_UP, kUp);
			//if(stage)stage.removeEventListener(KeyboardEvent.KEY_DOWN, kDwn);
			//if (e.keyCode == Keyboard.SHIFT) {
				//trace('snap');
				//if (parent && parent is ShadowShape) {
					//var arr:Vector.<HotSpot> = (parent as ShadowShape).points
					//var ind:int = arr.indexOf(this);
					//var prev:HotSpot;
					//var next:HotSpot;
					//switch (ind) 
					//{
						//case 0:
							//trace('first')
							//prev = arr[arr.length -1];
							//next = arr[1];
						//break;
						//case (arr.length - 1):
							//trace('last')
							//prev = arr[arr.length - 2];
							//next = arr[0];
						//break;
						//case -1:
						//trace('wrong index')
						//break;
					//default:
						//trace('normal')
						//prev = arr[ind - 1];
						//next = arr[ind + 1];
						//
					//}
					//
					//if (Math.abs(prev.x - this.x) < 20) {
						//this.x = prev.x;
					//}
					//if (Math.abs(next.x - this.x) < 20) {
						//this.x = next.x;
					//}
					//if (Math.abs(prev.y - this.y) < 20) {
						//this.y = prev.y;
					//}
					//if (Math.abs(next.y - this.y) < 20) {
						//this.y = next.y;
					//}
				//}
				//
				//
			//}
			//
		//}
		//private function kUp(e:KeyboardEvent):void {
			//if(stage)stage.removeEventListener(KeyboardEvent.KEY_UP, kUp);
			//if(stage && inDrag)stage.addEventListener(KeyboardEvent.KEY_DOWN, kDwn);
			//
		//}
		private function drop(e:Event = null ):void {
			//tangents(e);
			inDrag = false;
			if(e)e.stopPropagation();
			stopDrag();
			if(stage)stage.removeEventListener(MouseEvent.MOUSE_UP, drop);
			alpha = 0.5;
			//dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE))
			removeEventListener(Event.ENTER_FRAME, mMove);
			//dispatchEvent(new Event(Event.CHANGE, true));
			//if(stage)stage.removeEventListener(KeyboardEvent.KEY_DOWN, kDwn);
		}
		private function mOvr(e:Event):void {
			e.currentTarget.parent.setChildIndex(e.currentTarget,e.currentTarget.parent.numChildren-1)
			e.currentTarget.alpha = 0.8;
			e.currentTarget.scaleX = 2 * (1 / parent.scaleX);
			e.currentTarget.scaleY = 2* (1 / parent.scaleY);
			//stage.dispatchEvent(new Event("fixCursor"))
			addEventListener(MouseEvent.MOUSE_DOWN, pull);
		}
		private function mOut(e:Event):void {
			
			removeEventListener(MouseEvent.MOUSE_DOWN, pull);
			inDrag = false;
			//dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE))
			e.currentTarget.alpha = 0.5;
			e.currentTarget.scaleX = e.currentTarget.scaleY = 1;
			//if(stage)stage.removeEventListener(KeyboardEvent.KEY_DOWN, kDwn);
		}
		private function mMove(e:Event):void {
			dispatchEvent(new Event(DlEvt.DRAW,true));
		}
		public function deleteHotspot(e:ContextMenuEvent=null):void {
			if (parent is ShadowShape) {
				(this.parent as ShadowShape).dispatchEvent(new Event("pushUndo", true));
				(this.parent as ShadowShape).points.splice((this.parent as ShadowShape).points.indexOf(this), 1)
			}
			drop();
			dispatchEvent(new Event("drawEvent",true));
			this.parent.removeChild(this);
		}
		public function toggleActive(e:DataEvent):void {
			trace("HotSpot -> toggleActive:", e.data);
			e.stopPropagation();
			drop()
			switch (e.data) 
			{
				case "activate":
					//trace("hs:act");
					//this.alpha = 1;
					this.visible = true;
				break;
				
				case "deactivate":
				//trace("hs:dact");
					//this.alpha = .1;
					this.visible = false;
					if (par) removeEventListener(MouseEvent.MOUSE_DOWN, par.closeShape);
					removeEventListener(Event.ENTER_FRAME, mMove);
				break;
				default:
			}
		}
		
		/**
		 * This has to do with undo. If object has been removed from stage, deactivate listeners.
		 * @param	e
		 */
		protected function removedFromStage(e:Event):void {
			trace("removed HotSpot", this);
			removeEventListener(Event.ENTER_FRAME, mMove);
			if(par)removeEventListener(MouseEvent.MOUSE_DOWN, par.closeShape);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
		}
		protected function addedToStage(e:Event):void {
			//addEventListener(Event.ENTER_FRAME, mMove);
			//if(par)removeEventListener(MouseEvent.MOUSE_DOWN, par.closeShape);
			
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);

		}

		
	}

}