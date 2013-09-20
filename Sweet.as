package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Sweet extends Animate{

		private var originX:uint;
		private var originY:uint;
		public var defaultFrame:uint;
		
		public function Sweet(originX:uint,originY:uint,myGame:SweetSmash) {
			// constructor code
			this.animateSweet = this;
			this.animateGame = myGame;
			
			this.originX = originX;
			this.originY = originY;
			this.defaultFrame = Math.floor(Math.random() * 5+1);
			
			this.x = 707;
			this.y = 261;
			gotoAndStop(this.defaultFrame);
		}
		
		public function getOriginX():uint{
			return this.originX;
		}
		
		public function getOriginY():uint{
			return this.originY;
		}
	}
	
}
