package  
{
	import dl.events.OrientationEvent;
	import dl.ifc.DlButton;
	import dl.ifc.DlToolBox;
	import dl.ifc.SelectedBox;
	import dl.ifc.UndoButton;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.sampler.NewObjectSample;
	import flash.text.*;
	/**
	 * 
	 * This is the root of the application.
	 * It holds canvas and all graphical elements.
	 * I'm working on cleaning it, as it should not have any part in application logic.
	 * I think that my bugs can be traced to the fact that some of the functions of the canvs happen here.
	 * ...
	 * @author Petrovic Veljko
	 */
	public class Main extends Sprite
	{
		
		
		private var sky:Bitmap = new Library.Sky();
		private var sky2:Bitmap = new Library.Sky2();
		private var graph:Bitmap = new Library.Sky();
		private var canvas:Canvas = new Canvas();
		
		
		private var out:TextField = new TextField();
		private var out2:TextField = new TextField();
		
		private var sx:Number = 52 / canvas.r.width;
		private var sy:Number = 28/canvas.r.height
		private var m:Matrix = new Matrix(sx, 0, 0, sy, -canvas.r.x * sx, -canvas.r.y * sy)
		
		//public var db:DlToolBox = new DlToolBox();
		public var toolBox:DlToolBox = new DlToolBox();
		public var selectBox:SelectedBox = new SelectedBox();
		private var sb:SettingBox = new SettingBox();
		public var ub:UndoButton = new UndoButton();
		public var panel:Panel;
		
		public var infoBar:InfoBar = new InfoBar();
		public var powerBar:PowerBar = new PowerBar();
		
		public var cC:CustomCursor = new CustomCursor();
		import dl.events.DlEvt;
		
		public function Main() 
		{
			trace("Tool");
			graph.width = 880;
			graph.height = 670;
			addChild(graph);
			addChild(canvas);
			canvas.calc.shapes = canvas.shapes;
			
			powerBar.x = 890;
			powerBar.y = 8;
			addChild(powerBar);
			
			addChild(toolBox);
			
			sb.addEventListener(DlEvt.BACKGROUND, switchBackground);
			
			//toolBox.addEventListener(MouseEvent.MOUSE_UP, mUp);
			toolBox.y = canvas.r.top+2;
			toolBox.x = canvas.r.right - 192;
			selectBox.y = canvas.r.top +2;
			selectBox.x = canvas.r.right -32;
			addChild(selectBox);
			ub.x = canvas.r.left + 3 + 32;
			ub.y = canvas.r.top + 2;
			ub.filters = [dBW.BW()];
			ub.mouseEnabled = false;
			ub.addEventListener(DlEvt.UNDO_BUTTON,undoButton)
			canvas.undo.button = ub;
			addChild(ub);
			
			sb.x = canvas.r.left+3;
			sb.y = canvas.r.top+2;
			addChild(sb);
			canvas.settingBox = sb;
			//sb.y = 32;
			panel = new Panel(canvas.r);
			addChild(panel);
			addEventListener(Event.CHANGE, calculationChange);
			
			infoBar.y = 670;
			addChild(infoBar);

			addChild(cC);
			calculationChange();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//addEventListener(OrientationEvent.CHANGE, orientationChange)
			
			//TODO: move to canvas
			stage.addEventListener(DlEvt.TOOL, switchTool);
			stage.addEventListener(DlEvt.TYPE, switchType);
		}
		
		
		private function undoButton(e:Event):void {
			//TODO: 
			e.stopPropagation();
			canvas.undo.popUndo();
		}
		
		private function switchBackground(e:DataEvent):void {
			
			switch (e.data) 
			{
				case "true":
					graph.bitmapData = sky2.bitmapData.clone();
				break;
				case "false":
					graph.bitmapData = sky.bitmapData.clone();
				break;
			}
		}
		
		private function switchType(e:DataEvent):void {
		trace("switch type of" + canvas.selected +"selected: " + e.data);
			if(canvas.selected)canvas.selected.shadowType = e.data;
			
		}
		
		private function switchTool(e:DataEvent):void {
			trace(e.target.name + " |switchTool: " + e.data );
			
					if (canvas.currentAction == "selecting") {
						canvas.endSelecting();
					} 
					if (canvas.currentAction == "painting") {
						stage.dispatchEvent(new DataEvent(DlEvt.BRUSH,false,false,"arrow"))
						canvas.endPainting();
					}
					if (canvas.currentAction == "drawing") {
						stage.dispatchEvent(new DataEvent(DlEvt.BRUSH,false,false,"arrow"))
						canvas.endDrawing();
					}

			switch (e.data) 
			{

				case "arrow":
					dispatchEvent(new Event(DlEvt.CURSOR_RESET, true));
					canvas.startSelecting();
				break;
				case "eraser":
				case "pencil":
					dispatchEvent(new Event(DlEvt.CURSOR_PEN, true))
					canvas.startPainting();
				break;
				case "pen":
					canvas.startDrawing();
					dispatchEvent(new Event(DlEvt.CURSOR_BENZEE, true));
				break;
				default:
			}
			stage.dispatchEvent(new DataEvent(DlEvt.TOOL_CHANGED, false, false, e.data));
		}
		

		private function calculationChange(e:Event = null):void {
		if(e)trace("calc change: "+e.target+" CHANGE", canvas.shapes.length);
			canvas.calc.m.fillRect(canvas.calc.m.rect, 0xFFFFFF);
			for each(var sh:Shadow in canvas.shapes) {
				canvas.calc.m.draw(sh.bitmapData, null, null, BlendMode.DARKEN, null, true);
			}
			canvas.calc.compute();
		}
		
	}

}