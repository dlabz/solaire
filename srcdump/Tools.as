package  
{
	/**
	 * ...
	 * @author ...
	 */
	public class Tools 
	{
		
		public static function pointToLineDist(x1:Number, y1:Number, x2:Number, y2:Number,x3:Number, y3:Number):Number {
		    var dx:Number=x2-x1;
		    var dy:Number=y2-y1;
		    if (dx==0&&dy==0) {
		        x2+=1;
		        y2+=1;
		        dx=dy=1;
		    }
		    var u:Number = ((x3 - x1) * dx + (y3 - y1) * dy) / (dx * dx + dy * dy);
		 
		    var closestX:Number;
		    var closestY:Number;
		    if (u<0) {
		        closestX=x1;
		        closestY=y1;
		    } else if (u> 1) {
		        closestX=x2;
		        closestY=y2;
		    } else {
		        closestX=x1+u*dx;
		        closestY=y1+u*dy;
		    }
		    dx=closestX-x3;
		    dy=closestY-y3;
		    return Math.sqrt(dx * dx +  dy * dy);
		}
		
	}

}