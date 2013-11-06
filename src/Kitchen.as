package  {
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Kitchen extends Animate{

		private var myTimer:Timer;
		
		public function Kitchen() {
			gotoAndStop(1);
			this.x = 576;
			this.y = 64;
		}
		
		public function openDoor(timerLength:uint):void{
			//Open door
			this.gotoAndStop(2);
			
			//Set a timer to close it in timerLength milliseconds
			this.myTimer = new Timer(timerLength);
			this.myTimer.addEventListener(TimerEvent.TIMER,this.shutDoor);
			this.myTimer.start();
		}
		
		public function shutDoor(event:TimerEvent):void{
			this.gotoAndStop(1);
		}
	}
	
}
