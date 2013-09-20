package  {
	import flash.display.MovieClip;
	public class Tile extends MovieClip{

		public function Tile(originX:uint,originY:uint) {
			// constructor code
			gotoAndStop(1);
			this.x = originX;
			this.y = originY;
		}

	}
	
}
