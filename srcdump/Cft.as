package  
{
	import flash.display.*;
	import flash.filters.ColorMatrixFilter;
	/**
	 * ...
	 * @author Petrovic Veljko
	 */
	public class Cft extends Sprite
	
	{
		private var g:Graphics;
		public function Cft() 
		{
			g = this.graphics;
			g.beginFill(0, 1);
			g.drawRect(10, 10, 300, 300);
			
			this.filters = [egf()]
		}
		public function egf():ColorMatrixFilter
		{
			
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, +30]); // red
			matrix = matrix.concat([0, 1, 0, 0, +90]); // green
			matrix = matrix.concat([0, 0, 1, 0, +30]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			 
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			return filter;
			// Note, bdItem has already been created with an image.
			//bdItem.applyFilter(bdItem, new Rectangle(0, 0, bdItem.width, bdItem.height), new Point(0, 0), filter);
		}
		
	}

}