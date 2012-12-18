/*
Copyright (c) 2008 Joel Connett

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.adobe.images
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;	
	import flash.geom.Rectangle;
	
	public class BMPEncoder
	{		
		public const BIT_DEPTH:uint = 24;
		
		/**
		 * Encodes bitmap data into the bmp format
		 */
		public function encode(image:BitmapData):ByteArray
		{
			var bmp:ByteArray = new ByteArray();
			bmp.endian = "littleEndian";
			
			writeHeader(bmp);
			writeInfoHeader(bmp, image);			
			writeData(bmp, image);			
			setFileSize(bmp);
			
			return bmp;
		}
		
		private function writeData(bmp:ByteArray, image:BitmapData):void
		{
			// Calculate row padding. Rows end on 4 byte (dword) boundaries.
			var padLength:int = image.width % 4;
			var padding:ByteArray = new ByteArray();
			
			for(var i:int = 0; i < padLength; i++)
			{
				padding.writeByte(0);
			}
			
			var rgb:uint = 0;
			
			for(var y:int = image.height - 1; y >= 0; y--)
			{
				for(var x:int = 0; x < image.width; x++)
				{
					rgb = image.getPixel(x, y);
					bmp.writeByte(0x0000ff & rgb);
					bmp.writeByte((0x00ff00 & rgb) >> 8);
					bmp.writeByte((0xff0000 & rgb) >> 16);
				}
				
				// Align the rows.
				bmp.writeBytes(padding, 0, padLength);
			}
		}
		
		private function writePixel(bmp:ByteArray, rgb:uint):void
		{					
			bmp.writeByte(0x0000ff & rgb);
			bmp.writeByte((0x00ff00 & rgb) >> 8);
			bmp.writeByte((0xff0000 & rgb) >> 16);
		}
		
		/**
		 * Create the BMP Header
		 */
		private function writeHeader(bmp:ByteArray):void
		{
			// Bitmap header			
			bmp.writeShort(0x4d42); // BMPs start with 'BM'
			bmp.writeUnsignedInt(0); // filesize in bytes, set after the data is populated.
			bmp.writeShort(0); // reserved.
			bmp.writeShort(0); // reserved.
			bmp.writeUnsignedInt(54); //data offset.						
		}
		
		/**
		 * Creates the BMP Info Header. This header can be different depending
		 * of the version of the bitmap. This header is the V3.
		 */
		private function writeInfoHeader(bmp:ByteArray, image:BitmapData):void
		{
			// Bitmap Info header
			bmp.writeUnsignedInt(40); // Size of info header. V3
			bmp.writeInt(image.width); // signed int width of image.
			bmp.writeInt(image.height); // signed int height of image.
			bmp.writeShort(1); // # of color planes.
			bmp.writeShort(BIT_DEPTH); // # bits per pixel.
			bmp.writeUnsignedInt(0); // No compresion.
			bmp.writeUnsignedInt(0); // Size of the raw image data.	0 is valid for no compression.	
			bmp.writeInt(0); // x resolution 
			bmp.writeInt(0); // y resolution
			bmp.writeUnsignedInt(0); // # of colors in color pallete. 0 indicates default 2^n.
			bmp.writeUnsignedInt(0); // # of important colors. what?			
		}
		
				
		/**
		 * Sets the file size in the header. 
		 */
		private function setFileSize(bmp:ByteArray):void
		{
			var prevPosition:uint = bmp.position;
			bmp.position = 2;
			bmp.writeUnsignedInt(bmp.length);
			bmp.position = prevPosition;
		}
	}
}