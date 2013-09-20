package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Sweet extends Animate{

		private var originX:uint;
		private var originY:uint;
		public var defaultFrame:uint;
		
		public function Sweet(originX:uint,originY:uint,defaultFrame:uint) {
			// constructor code
			this.originX = originX;
			this.originY = originY;
			this.defaultFrame = defaultFrame;
			
			this.x = this.originX;
			this.y = this.originY;
			gotoAndStop(this.defaultFrame);
		}
	}
	
}
