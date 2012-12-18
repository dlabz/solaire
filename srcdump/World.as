package  
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	import flash.net.*;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import org.papervision3d.core.utils.Mouse3D;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	//import org.papervision3d.core.geom.renderables.Pixel3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.GeometryObject3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.shadematerials.PhongMaterial;
	import org.papervision3d.materials.shaders.FlatShader;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.special.Graphics3D;
	import org.papervision3d.objects.special.VectorShape3D;
	import org.papervision3d.materials.special.VectorShapeMaterial;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import flash.display.Bitmap;
	import flash.net.FileReference;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.display.BitmapDataChannel;
	import Base64;
	import vMatrix;
	/**
	 * ...
	 * @author Petrovic Veljko DLabz@intubo.com
	 */
	public class World extends PaperBase
	{
		//public var mylight:PointLight3D = new PointLight3D(true, false);
		
		public var matV:VectorShapeMaterial = new VectorShapeMaterial();
		//public var cube:Cube = new Cube(new MaterialsList( { all: matV } ), 10, 10, 10, 1, 1, 1);
		//private var cbb:Cube = new Cube(new MaterialsList( { all: matV } ), 1, 1, 1, 1, 1, 1, 0, 0);
		//public var dOb:DisplayObject3D = new DisplayObject3D();
		//private var b64:Base64 = new Base64();
		private var mL:MaterialsList = new MaterialsList( { all: matV } );
		//private var arr3D:Array = new Array();
		//private var isOpen:Boolean = false;
		//private var isX:Boolean = false;
		//private var isY:Boolean = false;
		//private var isZ:Boolean = false;
		
		
		
		public var hS:Number = 0; 
		public var vS:Number = 10;
		public var vAlph:Number = 1;
		
		public var xTxt:TextField = new TextField();
		
		public var m:vMatrix = new vMatrix(16);
		//public var n:vMatrix = new vMatrix(16);
		
		//private var shapeArr:Array = new Array(m.size);
		//private var pla:VectorShape3D = new VectorShape3D(matV);
		public var map:Bitmap = new Bitmap(m.myBitmapData);
		public var pre:Bitmap = new Bitmap(m.myBitmapPrerender);
		public var saveFile:FileReference = new FileReference();
		public var enc:BMPEncoder = new BMPEncoder();
		public var pivot:Point ;
		public var peru:LinkParser;
		
		public var keyz:Array = new Array(false, false, false, false, false, false);
		public var render:preRender;
		
		//add mySQL connection
		private var myURLVariables:URLVariables = new URLVariables();
		private var sendRequest:URLRequest = new URLRequest("http://localhost/voxoc.php");
		private var getResponse:URLLoader = new URLLoader;
		private var numStoredCubes:int;
		///that's it
		public function World() 
		{
			
			
			//matV.doubleSided = true;
			init(800, 450);
			addShapes();
			//viewport.interactive = true;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keysDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keysUp);
			stage.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, rotScene);
			
			//trace(m.XYZ[0][0][0]);
			//makeCube(new Pixel3D(m.XYZ[1][1][1], 2, 3, 2));
			//n.makeShapes();
			//n.dOb.x = 176;
			m.matV.interactive = true;
			//wn.matV.interactive = true;
			m.makeShapes();
			//default_scene.addChild(n.dOb);
			default_scene.addChild(m.dOb);
			SetupConnection();
			
		}
		
		
		private function addShapes():void {
			
			
			//cbb.x += m.size * vS / 2;
			//cbb.y += m.size * vS / 2;
			//cbb.z += m.size * vS / 2;
			
		}
		override protected function init3d():void {
			//default_scene.addChild(cbb);
			//viewport.addEventListener(MouseEvent.MOUSE_DOWN,rotScene);
			
			default_camera.x = m.size * vS * 3;
			default_camera.y = - m.size * vS * 3;
			default_camera.z = m.size * vS * 3;
			default_camera.lookAt(m.dOb,new Number3D(0,0,1));
			default_camera.zoom = 50;
			
		}
		
		override protected function processFrame():void {
			if (xTxt) {
				var hh:String = (default_camera.y  / (vS )).toString();
			xTxt.text = hh;
			}
			// Process any movement or animation here.
			if (keyz[0]) {
				default_camera.moveForward(.2 * m.size);
			}
			if (keyz[1]) {
			default_camera.moveBackward(.2 * m.size);
			}
			if (keyz[2]) {	
				default_camera.moveLeft(.2 * m.size);
			}
			if (keyz[3]) {
				default_camera.moveRight(.2 * m.size);
			}
			if (keyz[4]) {
				default_camera.moveUp(.2 * m.size);
			}
			if (keyz[5]) {
				default_camera.moveDown(.2 * m.size);
				}
			
			
			//default_camera.orbit((mouseY / 800) * 360, mouseX, true, cbb);
			if (viewport.width / 3 > mouseX || viewport.width * 2 / 3 < mouseX) {
				default_camera.rotationZ += (mouseX - viewport.width / 2)/3 * 0.005;
				if (default_camera.rotationZ >= 360) { default_camera.rotationZ = 0; }
				
			}
			
			if (viewport.height / 3 > mouseY || viewport.height * 2 / 3 < mouseY) {
				//trace(default_camera.rotationX);
				default_camera.rotationX += (mouseY - viewport.height / 2)/3 * 0.005;
				if (default_camera.rotationX > 175) { default_camera.rotationX = 175; }
				if (default_camera.rotationX < 5) { default_camera.rotationX = 5; }
				
			}
			
			
			
		}
		private function rotScene(e:MouseEvent):void {
			trace("rotScene", e.shiftKey);
			if (e.shiftKey == true) {
				
				stage.addEventListener(MouseEvent.MOUSE_UP, rotStop);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, rotScene);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, rotThis);
				pivot = new Point(mouseX, mouseY);
			}
			
			
		}
		private function rotStop(e:MouseEvent):void {
			//trace("rotStop");
			stage.addEventListener(MouseEvent.MOUSE_DOWN, rotScene);
			stage.removeEventListener(MouseEvent.MOUSE_UP, rotStop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, rotThis);
			
		}
		
		private function rotThis(e:MouseEvent):void {
			trace("rotThis",e.shiftKey);
			if (e.shiftKey);
			
			default_camera.yaw(mouseX-pivot.x);
			//dOb.rotationX += mouseY-pivot.y ;
			//dOb.rotationZ -= mouseX-pivot.x ;
			//popVoxO(e);
			//pullVoxO(e);
		}
		
		
	
		override protected function init2d():void {
			
			xTxt.text = default_camera.x.toString();
			addChild(xTxt);
			
			map.bitmapData = m.myBitmapData;
			pre.bitmapData = m.myBitmapPrerender;
			//pre.bitmapData.colorTransform(new Rectangle(0, 0, pre.width, pre.height), new ColorTransform(1,1,1000, 1));
			//trace(map.bitmapData.transparent);
			map.scaleX = 1;
			map.scaleY = 1;
			
			pre.scaleX = 4;
			pre.scaleY = 4;
			//map.x = 0;
			//map.y = 100;
			pre.y = map.height;
			addChild(map);
			
			//addChild(pre);
			
			
		}
		
		private function upLoad(e:Event):void {
			saveFile.load();
			saveFile.addEventListener(Event.COMPLETE,reLoad);
		}
		private function reLoad(e:Event):void {
			trace("loading...");
				
				m.myBitmapData = enc.decode(saveFile.data);
				//peru.parseLink(m.myBitmapData as ByteArray);
				default_scene.removeChild(m.dOb);
				map.bitmapData = m.myBitmapData;
		}
		private function keysUp(e:KeyboardEvent):void {
			trace(e.keyCode);
			switch (e.keyCode) {
				
				
				case 87 ://w
				keyz[0] = false;
				break;
				
				case 38 ://up
				keyz[0] = false;
				break;
				
				case 83 ://s
				keyz[1] = false;
				break;
				
				case 40 ://down
				keyz[1] = false;
				break;
				
				case 65 ://a
				keyz[2] = false;
				break;
				
				case 37 ://left
				keyz[2] = false;
				break;
				
				case 68 ://d
				keyz[3] = false;
				break;
				
				case 39 ://right
				keyz[3] = false;
				break;
					
				case 81 ://q
				keyz[4] = false;
				break;
				
				case 69 ://e
				keyz[5] = false;
				break;
				
				case 109 :
				//eMode = true;
				break;
				
				case 107 :
				//eMode = false;
				break;
			}
		}
		private function keysDown(e:KeyboardEvent):void {
			trace(e.keyCode);
			switch (e.keyCode) {
				
				
				case 87 ://w
				keyz[0] = true;
				break;
				
				case 38 ://up
				keyz[0] = true;
				break;
				
				case 83 ://s
				keyz[1] = true;
				break;
				
				case 40 ://down
				keyz[1] = true;
				break;
				
				case 65 ://a
				keyz[2] = true;
				break;
				
				case 37 ://left
				keyz[2] = true;
				break;
				
				case 68 ://d
				keyz[3] = true;
				break;
				
				case 39 ://right
				keyz[3] = true;
				break;
					
				case 81 ://q
				keyz[4] = true;
				break;
				
				case 69 ://e
				keyz[5] = true;
				break;
				
				case 109 ://+
				m.eMode = true;
				break;
				
				case 46 ://+
				m.eMode = true;
				break;
				
				case 107 ://-
				m.eMode = false;
				break;
				
				case 45 ://-
				m.eMode = false;
				break;
				
				case 116 ://F5
				//saveFile.browse();
				
				//saveFile.save(enc.encode(m.myBitmapData), "matrix.bmp");
				StoreCube(1, m);
				break;
				
				
				case 117 ://F6
				trace("browse...");
				//saveFile.browse();
				//saveFile.addEventListener(Event.SELECT, upLoad);
				CountCubes();
				//GetCube(3);
				break;
				
				case 76 :
				
				break;
				
				case 13 :
				
				break;
				
			}
		}
		public function SetupConnection() :void
		{
			sendRequest.method = URLRequestMethod.POST;
			sendRequest.data = myURLVariables;
			getResponse.dataFormat = URLLoaderDataFormat.VARIABLES;
			
			
			
			//logIn();
			//isOn();
			//getInfo();
			//stage.addEventListener(MouseEvent.CLICK, voteNow);
		}
		public function StoreCube(hash:int, voxMap:vMatrix):void {
			
			getResponse.addEventListener(Event.COMPLETE, StoreCubeDone);
			myURLVariables.sendRequest = "store_this";
			//myURLVariables.hash = hash;
			 
			var b:ByteArray = enc.encode(m.myBitmapData);
			//b.compress();
			b.position = 0x00;
			var blob:String = Base64.encodeByteArray(b);
			
			
			/*
			
			
			
			//trace(b.readUTFBytes(b.bytesAvailable));
			//trace (blob,b.position);
			for (var i:int = 0; i < b.length; i++) {
				
				b.position = i;
				//trace(b.position, blob);
				
				var char:String = b.readMultiByte(b.bytesAvailable,"base64");
				//trace(b.position,char);
				blob += char;
			}*/
			
			myURLVariables.blob_data = blob;
			// Send the data to the php file
			trace("storing..", hash,blob);
			getResponse.load(sendRequest);
		}
		private function StoreCubeDone(event:Event):void {
			getResponse.removeEventListener(Event.COMPLETE, StoreCubeDone);
			//trace(event.target.data.prt);
			trace(event.target.data.sql_said);
		}
		public function GetCube(hash:int):void {
			trace("getting:", hash);
			getResponse.addEventListener(Event.COMPLETE, GetCubeDone);
			myURLVariables.sendRequest = "get_this";
			myURLVariables.hash = hash;
			getResponse.load(sendRequest);
		}
		public function CountCubes():void {
			trace("CountCubes...");
			getResponse.addEventListener(Event.COMPLETE, CountCubesDone);
			myURLVariables.sendRequest = "count_cubes";
			
			getResponse.load(sendRequest);
		}
		private function CountCubesDone(event:Event):void {
			getResponse.removeEventListener(Event.COMPLETE, CountCubesDone);
			//trace(event.target.data.prt);
			trace("CountCubes:",event.target.data.num_stored_cubes);
			numStoredCubes = event.target.data.num_stored_cubes;
			//var getWhat:int = Math.round(randRange(1, numStoredCubes));
			var getWhat:int = numStoredCubes;
			GetCube(getWhat);
		}
		private function GetCubeDone(event:Event):void {
			getResponse.removeEventListener(Event.COMPLETE, GetCubeDone);
			//trace("sql_said",event.target.data.sql_said);
			//trace(event.target.data.got_blob);
			trace(event.target.data.got_time);
			trace(event.target.data.sql_said);
			var b:ByteArray = new ByteArray();
			//b.endian = "bigEndian";
			b.position = 0x00;
			trace("bArr Length",b.length);
			b = Base64.decodeToByteArray(event.target.data.got_blob);
			trace("bArr Length", b.length);
			//b.uncompress();
			m.myBitmapData = enc.decode(b);
			default_scene.removeChild(m.dOb);
			map.bitmapData = m.myBitmapData;
			m.makeShapes();
			default_scene.addChild(m.dOb);
			//saveFile.save(b, "rematrix.bmp");
				
		}
		private function randRange(start:Number, end:Number) : Number
		{
			return Math.floor(start +(Math.random() * (end - start)));
		}
	}

}
