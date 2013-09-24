package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Sweet extends Animate{

		private var originX:uint;
		private var originY:uint;
		private var defaultFrame:uint;
		
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
		
		public function getDefaultFrame():uint{
			return this.defaultFrame;
		}
		
		public function setOrigin(x:uint,y:uint):void{
			this.originX = x;
			this.originY = y;
		}
		
		public function getKey():String{
			var colNumber = (this.x - 32);
			if(colNumber != 0){
				colNumber /= 64;
			}
			var rowNumber = (this.y - 96);
			if(rowNumber != 0){
				rowNumber /= 64;
			}
			return "row"+rowNumber+"col"+colNumber;
		}
	}
	
}
