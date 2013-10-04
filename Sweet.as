package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	public class Sweet extends Animate{

		private var originX:uint;
		private var originY:uint;
		private var defaultFrame:uint;
		
		//Helps during the settle sequence
		public var isMatched:Boolean;
		public var spacesToMoveDown:uint;
		public var isSuperSpecial:Boolean;
		
		public function Sweet(originX:uint,originY:uint,myGame:SweetSmash) {
			this.isMatched = false;
			this.isSuperSpecial = false;
			this.spacesToMoveDown = 0;
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
		
		public function setPosition(x:int,y:int):void{
			this.x = x;
			this.y = y;
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
		
		public function setDefaultFrame(frameIndex:uint):void{
			this.defaultFrame = frameIndex;
			gotoAndStop(this.defaultFrame);
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
		
		public function getRow():uint{
			var rowNumber = (this.y - 96);
			if(rowNumber != 0){
				rowNumber /= 64;
			}
			return rowNumber;
		}
		
		public function getCol():uint{
			var colNumber = (this.x - 32);
			if(colNumber != 0){
				colNumber /= 64;
			}
			return colNumber;
		}
	}
	
}
