package  
{
	import flash.filters.ColorMatrixFilter;
	/**
	 * ...
	 * @author Petrovic Veljko DLabz@intubo.com
	 */
	public class dBW
	{
		//public var filter:ColorMatrixFilter;
		public static function BW():ColorMatrixFilter
		{
			
			var matrix:Array = new Array();
			matrix = matrix.concat([0.33, 0.33, 0.33, 0, 0]); // red
			matrix = matrix.concat([0.33, 0.33, 0.33, 0, 0]); // green
			matrix = matrix.concat([0.33, 0.33, 0.33, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			 
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			return filter;
			// Note, bdItem has already been created with an image.
			//bdItem.applyFilter(bdItem, new Rectangle(0, 0, bdItem.width, bdItem.height), new Point(0, 0), filter);
		}
		public static function EG():ColorMatrixFilter
		{
			
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, +34]); // red
			matrix = matrix.concat([0, 1, 0, 0, +177]); // green
			matrix = matrix.concat([0, 0, 1, 0, +76]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			 
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			return filter;
			// Note, bdItem has already been created with an image.
			//bdItem.applyFilter(bdItem, new Rectangle(0, 0, bdItem.width, bdItem.height), new Point(0, 0), filter);
		}
		public static function DC():ColorMatrixFilter
		{
			
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, +181]); // red
			matrix = matrix.concat([0, 1, 0, 0, +230]); // green
			matrix = matrix.concat([0, 0, 1, 0, +29]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			 
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			return filter;
			// Note, bdItem has already been created with an image.
			//bdItem.applyFilter(bdItem, new Rectangle(0, 0, bdItem.width, bdItem.height), new Point(0, 0), filter);
		}
		
		//scale
		
	}

}