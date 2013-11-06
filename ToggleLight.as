package  {
	import flash.display.MovieClip;
	
	public class ToggleLight extends MovieClip{

		private var result:Boolean;
		
		public function ToggleLight(xPos:int,yPos:int) {
			//Set a default position
			this.x = xPos;
			this.y = yPos;
			
			//Enable by default
			this.setEnabled(false);
		}
		
		public function isEnabled():Boolean{
			return this.result;
		}
		
		public function setEnabled(x:Boolean):void{
			this.result = x;
			if(this.result){
				gotoAndStop(2);
			}else{
				gotoAndStop(1);
			}
		}
	}
	
}
