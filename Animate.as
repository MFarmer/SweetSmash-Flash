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
		
		//Explode
		private var particleList:Array = new Array();
		private var vectorX:Number;
		private var vectorY:Number;
		private var explodeFrameCount:uint;
		private var explodeMaxFrameCount:uint;
		private var explodeBlock:Boolean;
		private var explodeParticleCount:uint;
		
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
		//#	Jiggle
		//#########################
		public function startJiggle(deltaLeft:uint,deltaRight:uint):void{
			this.isJiggling = true;
			this.leftJiggle = this.x - deltaLeft;
			this.rightJiggle = this.x + deltaRight;
			this.movingLeft = false;
			this.addEventListener(Event.ENTER_FRAME,performJiggle);
		}
		
		public function stopJiggle():void{
			if(this.isJiggling){
				this.removeEventListener(Event.ENTER_FRAME,performJiggle);
			}else{
				trace("Error: Sweet is not jiggling, therefore the 'stopJiggling' call was ignored.");
			}
		}

		private function performJiggle(event:Event):void{
			if(this.movingLeft){
				if(this.x > this.leftJiggle){
					this.x--;
				}else{
					this.movingLeft = false;
				}
			}else{
				if(this.x < this.rightJiggle){
					this.x++;
				}else{
					this.movingLeft = true;
				}
			}
		}
		
		//#########################
		//#	Blink
		//#########################
		public function startBlink(blinkPhaseFrameCount:uint,blinkIterationCount:uint):void{
			this.blinkTotalFrameCount = 0;
			this.blinkPhaseFrameCount = blinkPhaseFrameCount;
			this.blinkIterationCount = blinkIterationCount;
			this.blinkOn = false;
			
			this.addEventListener(Event.ENTER_FRAME,performBlink);
		}
		
		private function performBlink(event:Event):void{
			if(this.blinkOn){
				//this.alpha = 1.0;
				this.visible = true;
			}else{
				//this.alpha = 0.0;
				this.visible = false;
			}
			
			if(this.blinkTotalFrameCount % this.blinkPhaseFrameCount == 0){
				//A phase has ended, so flip the blinkOn variable.
				this.blinkOn = !this.blinkOn;
			}
			
			if(this.blinkTotalFrameCount >= (this.blinkPhaseFrameCount * this.blinkIterationCount)){
				this.visible = true;
				this.removeEventListener(Event.ENTER_FRAME,performBlink);
			}
			
			this.blinkTotalFrameCount++;
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
		
		//#########################
		//#	Explode on Mouse Event
		//#########################
		public function explodeOnClick():void{
			this.explodeFrameCount = 0;
			this.explodeMaxFrameCount = 60;
			this.explodeBlock = false;
			this.explodeParticleCount = 10;
			this.addEventListener(MouseEvent.MOUSE_DOWN,explode);
		}
		
		public function startExplode(maxNumberOfSweetsToExplode:uint):void{
			Animate.maxNumberOfSweetsToExplode = maxNumberOfSweetsToExplode;
			Animate.explosionCount = 0;
			this.explodeFrameCount = 0;
			//this.explodeMaxFrameCount = 60;
			this.explodeMaxFrameCount = 30;
			this.explodeBlock = false;
			this.explodeParticleCount = 10;
			this.performExplode();
		}
		
		private function performExplode():void{
			var localX = this.animateSweet.x;
			var localY = this.animateSweet.y;
			var defaultFrame = this.animateSweet.getDefaultFrame();
			
			this.animateSweet.alpha = 0.0;
			
			//Place 10 items on the center of the clicked icon
			if(!this.explodeBlock){
				this.explodeBlock = true;
				for(var i:uint=0; i<this.explodeParticleCount; i++){
					this.particleList.push(new Sweet(localX,localY,this.animateGame));
					this.particleList[i].setDefaultFrame(defaultFrame);
					this.particleList[i].setPosition(localX,localY);
					this.particleList[i].scaleX = 0.5;
					this.particleList[i].scaleY = this.particleList[i].scaleX;
					this.particleList[i].rotation = Math.floor(Math.random() * 360);
					this.particleList[i].vectorX = Math.floor(Math.random() * 20 - 10);
					this.particleList[i].vectorY = Math.floor(Math.random() * 20 - 10);
					this.particleList[i].startSpin(Math.floor(Math.random()*10),true);
					this.particleList[i].startPulse(0.3,0.5,0.1);
					this.particleList[i].startFade(this.explodeMaxFrameCount,true);
					this.particleList[i].mouseEnabled = false;
					this.parent.addChild(this.particleList[i]);
				}
				this.addEventListener(Event.ENTER_FRAME,animateExplode);
			}else{
				trace("Ignored startExplode since it is already in progress from a prior click.");
			}
		}
		private function explode(event:MouseEvent):void{
			this.performExplode();
		}
		
		private function animateExplode(event:Event):void{
			for(var i:uint=0; i<this.particleList.length; i++){
				//Should gravity now affect course?
				if(this.explodeFrameCount % 10 == 0){
					this.particleList[i].vectorY-=3;
				}
				//Move the particles
				this.particleList[i].x -= this.particleList[i].vectorX;
				this.particleList[i].y -= this.particleList[i].vectorY;
			}
			
			if(this.explodeFrameCount >= this.explodeMaxFrameCount){
				//Explosion has ended
				this.removeEventListener(Event.ENTER_FRAME,animateExplode);
				
				//Remove particles from the screen AND THEIR EVENT LISTENERS (crucial in order to not crash the program)
				for(i=0; i<this.particleList.length; i++){
					this.particleList[i].removeEventListener(Event.ENTER_FRAME,performFade);
					this.particleList[i].removeEventListener(Event.ENTER_FRAME,performPulse);
					this.particleList[i].removeEventListener(Event.ENTER_FRAME,performSpin);
					
					//Safely remove the explosion particles from the parent (should be the main stage)
					if (this.particleList[i].parent) {
						try {
							this.particleList[i].parent.removeChild(this.particleList[i]);
						}catch(err:Error){
							// fail silently; child already removed
							trace("particle list not removing");
						}
					}
				}
				
				//Re-initialize explosion variables
				this.particleList = new Array();
				this.explodeFrameCount = 0;
				this.explodeBlock = false;
				
				//Safely remove the sweet from the board.
				if(this.parent){
					try{
						this.parent.removeChild(this);
					}catch(err:Error){
						trace("particle list not removing");
					}
				}
				
				Animate.explosionCount++;
				
				if(Animate.explosionCount >= Animate.maxNumberOfSweetsToExplode){
					//Explosions are done.
					trace("Explosions are done!");
					
					//Settle the sweets
					this.animateGame.sweetGrid.settleSweets();
				}else{
					trace("Explosions are not done! "+Animate.explosionCount+" < "+Animate.maxNumberOfSweetsToExplode);
				}
				
			}
			
			this.explodeFrameCount++;
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
			
			this.myTimer = new Timer(delay,0);
			this.myTimer.addEventListener(TimerEvent.TIMER,moveTo);
			this.myTimer.start();
		}
		
		private function moveTo(event:TimerEvent):void{
			this.myTimer.removeEventListener(TimerEvent.TIMER,moveTo);
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
	}
	
}
