package  
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	/**
	 * ...
	 * @author ...
	 */
	public class ToolBox extends Sprite
	{
		public var treeBtn:Sprite
		
		public var status:Object = { };
		
		public var target:ShadowShape;
		
		public function ToolBox() 
		{
			
			//mkButton();
			var tree:Sprite = mkButton("tree");
			
			addChild(tree);
			var leaf:Sprite = mkButton("leaf");
			leaf.x = tree.getRect(this).right;
			addChild(leaf);
			
			this.graphics.beginFill(0x999999, 1);
			//this.graphics.lineStyle(0);
			this.graphics.drawRoundRect( -10, -1, width+11, height+2,5,5);
		}
		private function mkButton(n:String):Sprite {
			var tmp:Sprite = new Sprite();
			tmp.name = n;
			var g:Graphics = tmp.graphics;
			g.beginFill(0x666666, 1);
			g.drawRoundRect(0, 0, 20, 20, 5, 5);
			tmp.filters = [new BevelFilter()]
			tmp.addEventListener(MouseEvent.MOUSE_DOWN, mDown);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mD);
			this.addEventListener(MouseEvent.MOUSE_UP, mUp);
			status[tmp.name] = false;
			return tmp;
		}
		
		private function mDown(e:MouseEvent):void {
			e.stopPropagation();
			toggle(e.target as Sprite);
		}
		private function mUp(e:MouseEvent):void {
			e.stopPropagation();
			
		}
		private function toggle(param:Sprite, gui:Boolean = false):void {
			
			if (target[param.name] == false) {
				param.filters =  [new BevelFilter(2, 2)];
				target[param.name] = true;
			} else {
				param.filters = [new BevelFilter()];
				target[param.name] = false;
			}
			trace(param.name, target[param.name]);
			target.draw();
			parent.dispatchEvent(new Event(Event.CHANGE, true));
		}
		private function mD(m:MouseEvent):void {
			this.startDrag();
		}
		private function mU(m:MouseEvent):void {
			this.stopDrag();
		}
		public function connectShape(_s:ShadowShape):void {
			if (target) disconnectShape(target);
			target = _s;
			this.visible = true;
			this.x = _s.getRect(_s.parent).right + 10;
			this.y = _s.getRect(_s.parent).top;
			if (_s.tree == true) {
				getChildByName("tree").filters =  [new BevelFilter(2, 2)];
			}else {
				getChildByName("tree").filters =  [new BevelFilter()];
			}
			if (_s.leaf == true) {
				getChildByName("leaf").filters =  [new BevelFilter(2, 2)];
			}else {				
				getChildByName("leaf").filters =  [new BevelFilter()];
			}
		}
		public function disconnectShape(_s:ShadowShape):void {
			if (target) {
				this.visible = false;
				target.deselect();
				target = null;
			}
		}
	}

}