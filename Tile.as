package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Tile extends MovieClip{

		public function Tile(originX:uint,originY:uint) {
			// constructor code
			gotoAndStop(1);
			this.x = originX;
			this.y = originY;
		}

	}
	
}
