package  {
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Animate extends MovieClip{

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
		private var mySweet:Sweet;
		private var myGame:SweetSmash;
		private var explodeFrameCount:uint;
		private var explodeMaxFrameCount:uint;
		private var explodeBlock:Boolean;
		private var explodeParticleCount:uint;
		
		//Move Down
		private var isMovingDown:Boolean;
		private var moveDownSpeed:Number;
		private var depthGoal:int;
		
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
		public function explodeOn(mySweet:Sweet,myGame:SweetSmash):void{
			this.mySweet = mySweet;
			this.myGame = myGame;
			this.explodeFrameCount = 0;
			this.explodeMaxFrameCount = 60;
			this.explodeBlock = false;
			this.explodeParticleCount = 30;
			this.addEventListener(MouseEvent.MOUSE_DOWN,startExplode);
		}
		
		private function startExplode(event:MouseEvent):void{
			//Remove the icon which was clicked
			//this.mySweet.mouseEnabled = false;
			//this.mySweet.startBlink(3,20);
			this.myGame.removeChild(mySweet);
			
			//this.myGame.removeChild(mySweet);
			//Place 10 items on the center of the clicked icon
			if(!this.explodeBlock){
				this.explodeBlock = true;
				for(var i:uint=0; i<this.explodeParticleCount; i++){
					this.particleList.push(new Sweet(this.mySweet.x,this.mySweet.y,this.mySweet.defaultFrame));
					this.particleList[i].scaleX = 0.5;
					this.particleList[i].scaleY = this.particleList[i].scaleX;
					this.particleList[i].rotation = Math.floor(Math.random() * 360);
					this.particleList[i].vectorX = Math.floor(Math.random() * 20 - 10);
					this.particleList[i].vectorY = Math.floor(Math.random() * 20 - 10);
					this.particleList[i].startSpin(Math.floor(Math.random()*10),true);
					this.particleList[i].startPulse(0.3,0.5,0.1);
					this.particleList[i].startFade(60,true);
					this.particleList[i].mouseEnabled = false;
					this.myGame.addChild(this.particleList[i]);
				}
				this.addEventListener(Event.ENTER_FRAME,animateExplode);
			}else{
				trace("Ignored startExplode since it is already in progress from a prior click.");
			}
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
				for(i=0; i<this.particleList.length; i++){
					this.myGame.removeChild(this.particleList[i]);
				}
				this.particleList = new Array();
				this.removeEventListener(Event.ENTER_FRAME,animateExplode);
				this.explodeFrameCount = 0;
				this.explodeBlock = false;
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
		//#	Move Down X Units of N Pixels
		//#########################
		public function moveDown(units:uint, pixels:uint, speed:Number){
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
				}
			}
		}

		//#########################
		//#	Wiggle
		//#########################
		
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
