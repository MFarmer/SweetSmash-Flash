package  {
	import flash.events.MouseEvent;
	public class MenuButton extends Animate {

		public function MenuButton(defaultFrame:uint) {
			// constructor code
			trace("1");
			this.x = 960/2;
			this.y = 320;
			this.gotoAndStop(defaultFrame);
			trace("2");
			this.addEventListener(MouseEvent.MOUSE_OVER,this.mouseIsHoveringOverMe);
			this.addEventListener(MouseEvent.MOUSE_OUT,this.mouseStoppedHoveringOverMe);
			trace("3");
		}
		
		private function mouseIsHoveringOverMe(event:MouseEvent):void{
			this.startPulse(0.95,1.05,0.01);
		}
		
		private function mouseStoppedHoveringOverMe(event:MouseEvent):void{
			this.stopPulse();
		}

	}
	
}
