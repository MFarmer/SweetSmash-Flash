package  {
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Animate extends MovieClip{
		public var animateSweet:Sweet;
		public var animateGame:SweetSmash;
		
		private var myTimer:Timer;
		
		//Static
		private static var swapCount:uint;
		private static var explosionCount:uint;
		private static var maxNumberOfSweetsToExplode:uint;
		private static var initializeGridCount:uint;
		private static var moveDownCount:uint;
		private static var expectedMoveDownCount:uint;
		private static var totalToMove:uint;
		private static var fillEmptySpotsCount:uint;
		
		//Jiggle
		private var leftJiggle:int;
		private var rightJiggle:uint;
		private var movingLeft:Boolean;
		private var isJiggling:Boolean
		
		//Spin
		private var rotationPerFrame:uint;
		private var isSpinning:Boolean;
		private var clockwiseSpin:Boolean;
		
		//Pulse
		private var maxScale:Number;
		private var minScale:Number;
		private var scaleChangePerFrame:Number;
		private var isPulsing:Boolean;
		private var isGrowing:Boolean;
		
		//Blink
		private var blinkTotalFrameCount:uint;
		private var blinkPhaseFrameCount:uint;
		private var blinkIterationCount:uint;
		private var blinkOn:Boolean;
		
		//Fade
		private var fadeMaxFrameCount:uint;
		private var fadeSpeed:Number;
		private var fadeOut:Boolean;
		
		//Move To Position
		private var moveToDestinationX:int;
		private var moveToDestinationY:int;
		private var moveToStepX:Number;
		private var moveToStepY:Number;
		private var moveToFrameCount:uint;
		private var moveToMaxFrameCount:uint;
		private var moveToNextAction:String;
		
		//Move Down
		private var isMovingDown:Boolean;
		private var moveDownSpeed:Number;
		private var depthGoal:int;
		private var moveDownCheck:String;
		
		//Wiggle
		private var wiggleRotateLeft:Boolean;
		private var wiggleScaleUp:Boolean;
		private var wiggleRotateStep:Number;
		private var isWiggling:Boolean;
		
		//#########################
		//#	Constructor
		//#########################
		public function Animate() {
			// constructor code
			this.isJiggling = false;
		}
		
		//#########################
		//#	Fade
		//#########################
		public function startFade(fadeMaxFrameCount:uint,fadeOut:Boolean):void{
			this.fadeMaxFrameCount = fadeMaxFrameCount;
			this.fadeSpeed = 1.0 / this.fadeMaxFrameCount;
			this.fadeOut = fadeOut;
			
			this.addEventListener(Event.ENTER_FRAME,performFade);
		}
		
		private function performFade(event:Event):void{
			if(this.fadeOut){
				this.alpha -= this.fadeSpeed;
				if(this.alpha <= 0){
					this.alpha = 0;
					this.removeEventListener(Event.ENTER_FRAME,performFade);
				}
			}else{
				this.alpha += this.fadeSpeed;
				if(this.alpha >= 1.0){
					this.alpha = 1.0;
					this.removeEventListener(Event.ENTER_FRAME,performFade);
				}
			}
		}
		
		private function stopFade():void{
			this.removeEventListener(Event.ENTER_FRAME,performFade);
			trace("Stopped fade...");
		}
		
		//#########################
		//#	Spin
		//#########################
		public function startSpin(delta:Number,clockwiseSpin:Boolean):void{
			this.isSpinning = true;
			this.clockwiseSpin = clockwiseSpin;
			this.rotationPerFrame = delta;
			this.addEventListener(Event.ENTER_FRAME,performSpin);
		}
		
		private function performSpin(event:Event):void{
			if(this.clockwiseSpin){
				this.rotation += this.rotationPerFrame;
			}else{
				this.rotation -= this.rotationPerFrame;
			}
			
			if(this.rotation >= 360){
				this.rotation -= 360;
			}
		}
		
		private function stopSpin():void{
			this.addEventListener(Event.ENTER_FRAME,performSpin);
			trace("Stopped spin...");
		}
		
		//#########################
		//#	Move To Position
		//#########################
		public function moveToPosition(destinationX:int, destinationY:int, speed:Number,delay:uint,nextAction:String,totalToMove:uint):void{
			Animate.swapCount = 0;
			Animate.initializeGridCount = 0;
			Animate.fillEmptySpotsCount = 0;
			Animate.totalToMove = totalToMove;
			this.moveToNextAction = nextAction;
			this.moveToDestinationX = destinationX;
			this.moveToDestinationY = destinationY;
			this.moveToFrameCount = 0;
			this.moveToMaxFrameCount = speed;
			this.moveToStepX = (this.moveToDestinationX - this.x)/this.moveToMaxFrameCount;
			this.moveToStepY = (this.moveToDestinationY - this.y)/this.moveToMaxFrameCount;
			
			this.moveTo();
		}
		
		private function moveTo():void{
			//this.myTimer.removeEventListener(TimerEvent.TIMER,moveTo);
			//this.myTimer = null;
			this.addEventListener(Event.ENTER_FRAME,performMoveToPosition);
		}
		
		private function performMoveToPosition(event:Event):void{
			this.x += this.moveToStepX;
			this.y += this.moveToStepY;
			
			if(++this.moveToFrameCount == this.moveToMaxFrameCount){
				//Movement has concluded
				this.x = this.moveToDestinationX;
				this.y = this.moveToDestinationY;
				this.removeEventListener(Event.ENTER_FRAME,performMoveToPosition);
				
				
				if(moveToNextAction == "showAllMatches"){
					Animate.swapCount++;
					if(Animate.swapCount == Animate.totalToMove){
						Animate.swapCount = 0;
						this.animateGame.sweetGrid.showAllMatchedSweets();
					}
				}else if(moveToNextAction == "processMatches"){
					Animate.initializeGridCount++;
					trace("Sweet is ready! "+Animate.initializeGridCount+"/"+Animate.totalToMove);
					if(Animate.initializeGridCount == Animate.totalToMove){
						Animate.initializeGridCount = 0;
						this.animateGame.sweetGrid.processMatches();
					}
				}
			}
		}
		
		//#########################
		//#	Move Down X Units of N Pixels
		//#########################
		public function moveDown(units:uint, pixels:uint, speed:Number,check:String,numberOfSweetsMovingDown:uint){
			Animate.moveDownCount = 0;
			this.moveDownCheck = check;
			Animate.expectedMoveDownCount = numberOfSweetsMovingDown;
			this.isMovingDown = true;
			this.depthGoal = this.y + units * pixels;
			this.moveDownSpeed = speed;
			this.addEventListener(Event.ENTER_FRAME,performMoveDown);
		}
		
		private function performMoveDown(event:Event):void{
			if(this.isMovingDown){
				this.y += this.moveDownSpeed;
				
				if(this.y >= this.depthGoal){
					this.y = this.depthGoal;
					this.isMovingDown = false;
					this.removeEventListener(Event.ENTER_FRAME,performMoveDown);
					
					if(this.moveDownCheck == "settling"){
						Animate.moveDownCount++;
						
						
						if(Animate.moveDownCount == Animate.expectedMoveDownCount){
							//All Sweets have moved down, and thus the new sweets are ready to be placed onto the grid
							trace("Ready to place new sweets!");
							this.animateGame.sweetGrid.placeNewSweets();
						}else{
							trace("Move Down not complete! "+Animate.moveDownCount+"/"+Animate.expectedMoveDownCount);
						}
					}
				}
			}
		}

		//#########################
		//#	Wiggle
		//#########################
		public function wiggle(event:MouseEvent):void{
			if(this.animateGame.gridInputLight.isEnabled()){
				this.startWiggle();
				
				//Record which sweet is currently chosen
				this.animateGame.sweet1 = this.animateSweet;
			}else{
				trace("Note: Grid input is disabled, so the icon click was ignored.");
			}
		}
		
		public function startWiggle():void{
			this.isWiggling = true;
			this.wiggleRotateLeft = true;
			this.wiggleScaleUp = true;
			this.wiggleRotateStep = 2;
			this.addEventListener(Event.ENTER_FRAME,performWiggle);
			this.startPulse(1.0,1.1,0.01);
		}
		
		public function stopWiggle():void{
			if(this.isWiggling){
				this.removeEventListener(Event.ENTER_FRAME,performWiggle);
				this.removeEventListener(Event.ENTER_FRAME,performPulse);
				this.rotation = 0;
				this.scaleX = 1.0;
				this.scaleY = 1.0;
				this.isWiggling = false;
			}else{
				trace("Error: Tried to stopWiggle on an icon that wasn't wiggling.");
			}
		}
		
		private function performWiggle(event:Event):void{
			//Handle the sway
			if(this.wiggleRotateLeft){
				this.rotation -= this.wiggleRotateStep;
				if(this.rotation <= -20){
					this.wiggleRotateLeft = false;
				}
			}else{
				this.rotation += this.wiggleRotateStep;
				if(this.rotation >= 20){
					this.wiggleRotateLeft = true;
				}
			}
			
		}
		
		//#########################
		//#	Pulse
		//#########################
		public function startPulse(minScale:Number,maxScale:Number,delta:Number):void{
			this.isPulsing = true;
			this.isGrowing = true;
			this.minScale = minScale;
			this.maxScale = maxScale;
			this.scaleChangePerFrame = delta;
			this.addEventListener(Event.ENTER_FRAME,performPulse);
		}
		
		public function performPulse(event:Event):void{
			if(this.isGrowing){
				if(this.scaleX < this.maxScale){
					this.scaleX += this.scaleChangePerFrame;
				}else{
					this.isGrowing = false;
				}
			}else{
				if(this.scaleX > this.minScale){
					this.scaleX -= this.scaleChangePerFrame;
				}else{
					this.isGrowing = true;
				}
			}
			this.scaleY = this.scaleX;
		}
		
		public function stopPulse():void{
			this.removeEventListener(Event.ENTER_FRAME,performPulse);
			this.scaleX = 1;
			this.scaleY = 1;
			trace("Stopping pulse...");
		}
	}
	
}
