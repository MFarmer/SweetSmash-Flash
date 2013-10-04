package  {
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	
	public class Recap extends Animate{
		
		private var scoreField:HUDInfoText = new HUDInfoText(0,"",24,520,350);
		private var timerField:HUDInfoText = new HUDInfoText(0,"",24,520,350);
		private var comboField:HUDInfoText = new HUDInfoText(0,"",24,520,350);
		private var finalScoreField:HUDInfoText = new HUDInfoText(0,"",24,520,400);
		private var scoreLabel:TextField = new TextField();
		private var timerLabel:TextField = new TextField();
		private var comboLabel:TextField = new TextField();
		private var finalScoreLabel:TextField = new TextField();
		
		private var timer:Timer;
		
		//Remember values
		private var finalScore:uint;
		private var finalTime:uint;
		private var longestCombo:uint;
		
		public function Recap(myGame:SweetSmash) {
			this.animateGame = myGame;
			this.x = 960/2 - this.width/2;
			this.y = 320 - this.height/2;
			
			//Setup the static labels
			this.scoreLabel.autoSize = "left";
			this.scoreLabel.defaultTextFormat = new TextFormat('Hobo Std',24,0x6bd8ae);
			this.timerLabel.autoSize = "left";
			this.timerLabel.defaultTextFormat = new TextFormat('Hobo Std',24,0x6bd8ae);
			this.comboLabel.autoSize = "left";
			this.comboLabel.defaultTextFormat = new TextFormat('Hobo Std',24,0x6bd8ae);
			this.finalScoreLabel.autoSize = "left";
			this.finalScoreLabel.defaultTextFormat = new TextFormat('Hobo Std',24,0x6bd8ae);
			
			var shadowEffect:DropShadowFilter = new DropShadowFilter();
			shadowEffect.angle = 45;
			shadowEffect.distance = 3;
			
			this.scoreLabel.filters = [shadowEffect];
			this.timerLabel.filters = [shadowEffect];
			this.comboLabel.filters = [shadowEffect];
			this.finalScoreLabel.filters = [shadowEffect];
			
			this.scoreLabel.text = "Score";
			this.timerLabel.text = "Time Bonus";
			this.comboLabel.text = "Longest Combo";
			this.finalScoreLabel.text = "FINAL SCORE";
			
			this.scoreLabel.x = 340;
			this.scoreLabel.y = 350;
			this.timerLabel.x = 340;
			this.timerLabel.y = 350;
			this.comboLabel.x = 340;
			this.comboLabel.y = 350;
			this.finalScoreLabel.x = 340;
			this.finalScoreLabel.y = 400;
			
			this.alpha = 0.0;
		}

		public function beginRecap():void{
			this.animateGame.addChild(this.scoreLabel);
			
			//Retrieve the final values from the UI
			this.finalScore = this.animateGame.scoreBoard.getValue();
			this.finalTime = Math.floor(900/this.animateGame.timeElapsed.getValue()*100);
			this.longestCombo = this.animateGame.sweetGrid.longestComboStreak;
			
			this.timer = new Timer(1);
			this.timer.addEventListener(TimerEvent.TIMER,updateScoreField);
			this.animateGame.addChild(this.scoreField);
			this.timer.start();
		}
		
		private function updateScoreField(event:TimerEvent):void{
			var pointIncrement:uint = 50;
			
			if(this.scoreField.getValue() < this.finalScore){
				if(this.scoreField.getValue()+pointIncrement > this.finalScore){
					this.scoreField.updateText(this.finalScore - this.scoreField.getValue());
					this.animateGame.scoreBoard.updateText(-(this.finalScore - this.scoreField.getValue()));
				}else{
					this.scoreField.updateText(pointIncrement);
					this.animateGame.scoreBoard.updateText(-pointIncrement);
				}
				this.scoreField.updatePrefix("+");
			}else{
				trace("Done tallying score.");
				this.scoreField.updatePrefix("");
				this.timer.stop();
				this.timer.removeEventListener(TimerEvent.TIMER,updateScoreField);
				
				this.scoreField.y -= 50;
				this.scoreLabel.y -= 50;
				
				//Alright. Move this textField upward.
				this.beginTimerScoring();
			}
		}
		
		private function beginTimerScoring():void{
			this.finalTime = 356;
			
			this.animateGame.addChild(this.timerLabel);
			this.timer = new Timer(1);
			this.timer.addEventListener(TimerEvent.TIMER,updateTimerField);
			this.animateGame.addChild(this.timerField);
			this.timer.start();
		}
		
		private function updateTimerField(event:TimerEvent):void{
			var timerIncrement:uint = 50;
			
			trace(this.finalTime);
			if(this.timerField.getValue() < this.finalTime){
				if(this.timerField.getValue()+timerIncrement > this.finalTime){
					this.timerField.updateText(this.finalTime - this.timerField.getValue());
				}else{
					this.timerField.updateText(timerIncrement);
				}
				this.timerField.updatePrefix("+");
			}else{
				this.timerField.updatePrefix("");
				this.timer.stop();
				this.timer.removeEventListener(TimerEvent.TIMER,updateTimerField);
				
				this.scoreField.y -= 50;
				this.scoreLabel.y -= 50;
				this.timerField.y -= 50;
				this.timerLabel.y -= 50;
				
				this.beginLongestCombo();
			}
			
		}
		
		private function beginLongestCombo():void{
			this.animateGame.addChild(this.comboLabel);
			this.comboField.updatePrefix("x");
			this.comboField.updateText(this.longestCombo);
			this.animateGame.addChild(this.comboField);
			
			this.showFinalScore();
		}
		
		private function showFinalScore():void{
			this.finalScoreField.updateText(this.timerField.getValue()+this.scoreField.getValue());
			this.animateGame.addChild(this.finalScoreField);
			this.animateGame.addChild(this.finalScoreLabel);
			
			//Begin Anew
			this.addEventListener(MouseEvent.MOUSE_DOWN,this.startNewGame);
		}
		
		private function startNewGame(event:MouseEvent):void{
			this.removeAllTextFields();
			this.removeEventListener(MouseEvent.MOUSE_DOWN,this.startNewGame);
			this.animateGame.buildInitialSweetGrid("processMathces");
		}
		
		private function removeAllTextFields():void{
			this.animateGame.removeChild(this.scoreField);
			this.animateGame.removeChild(this.timerField);
			this.animateGame.removeChild(this.comboField);
			this.animateGame.removeChild(this.finalScoreField);
			this.animateGame.removeChild(this.scoreLabel);
			this.animateGame.removeChild(this.timerLabel);
			this.animateGame.removeChild(this.comboLabel);
			this.animateGame.removeChild(this.finalScoreLabel);
		}
	}
	
}
